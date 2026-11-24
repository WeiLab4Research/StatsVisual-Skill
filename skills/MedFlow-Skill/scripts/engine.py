"""MedFlow: source-traceable scene validation, shared pt geometry and three native vector outputs."""
from __future__ import annotations
import argparse, base64, copy, hashlib, html, io, json, math, os, sys, tempfile
from pathlib import Path
import pymupdf as fitz

HERE=Path(__file__).resolve().parent
ROOT=HERE.parent
KINDS={'rect','diamond','ellipse','text'}

def load(path):
    return json.loads(Path(path).read_text(encoding='utf-8-sig'))

def digest(spec):
    data={k:v for k,v in spec.items() if k!='approval'}
    return hashlib.sha256(json.dumps(data,ensure_ascii=False,sort_keys=True,separators=(',',':')).encode()).hexdigest()

def validate(spec, confirmed=False):
    import jsonschema
    errors=[]
    def finite(x):
        if isinstance(x,float) and not math.isfinite(x):return False
        if isinstance(x,dict):return all(finite(v) for v in x.values())
        if isinstance(x,list):return all(finite(v) for v in x)
        return True
    if not finite(spec):return ['All numeric fields must be finite']
    schema=load(ROOT/'schemas/figure.schema.json')
    for e in sorted(jsonschema.Draft202012Validator(schema).iter_errors(spec),key=lambda e:str(e.path)):
        errors.append(f'{list(e.path)}: {e.message}')
    if errors: return errors
    if spec['metadata']['type']=='01-rct-flow' and not spec['metadata'].get('trial_subtypes'): errors.append('RCT subtype required: select the actual trial design')
    if spec['metadata']['type']!='01-rct-flow' and spec['metadata'].get('trial_subtypes'): errors.append('trial_subtypes applies only to RCT participant flow')
    ids={n['id'] for n in spec['nodes']}
    if len(ids)!=len(spec['nodes']): errors.append('Duplicate node IDs')
    edgeids=[e['id'] for e in spec.get('edges',[])]
    if len(set(edgeids))!=len(edgeids) or ids.intersection(edgeids): errors.append('IDs must be globally unique')
    nm={n['id']:n for n in spec['nodes']}
    for n in spec['nodes']:
        if not n.get('source','').strip(): errors.append(f"{n['id']}: source location required")
        if n.get('parent') and n['parent'] not in ids: errors.append(f"{n['id']}: missing parent")
        seen={n['id']}; parent=n.get('parent')
        while parent in nm:
            if parent in seen: errors.append(f"{n['id']}: containment cycle"); break
            seen.add(parent); parent=nm[parent].get('parent')
        if 'count' in n and not n.get('unit'): errors.append(f"{n['id']}: counted objects need unit")
    for e in spec.get('edges',[]):
        if e['from'] not in ids or e['to'] not in ids: errors.append(f"{e['id']}: unresolved endpoint")
        if e.get('branch_from') and e['branch_from'] not in edgeids: errors.append(f"{e['id']}: branch trunk missing")
        if e.get('branch_from')==e['id']: errors.append(f"{e['id']}: branch cannot reference itself")
        if e['relation']=='exclusion' and not e.get('branch_from'): errors.append(f"{e['id']}: exclusion must attach to a trunk edge using branch_from")
        if e.get('branch_from') and e.get('points'): errors.append(f"{e['id']}: branch_from cannot be combined with absolute points")
        if e['from']==e['to']: errors.append(f"{e['id']}: use distinct state/time nodes, not self-edge")
    for eq in spec.get('equations',[]):
        parts=eq['parts']; total=eq['total']
        if total not in ids or any(p not in ids for p in parts): errors.append('Equation endpoint missing'); continue
        if total in parts or len(set(parts))!=len(parts): errors.append('Equation repeats a part or includes its total'); continue
        vals=[nm[x] for x in [total]+parts]
        if len({n.get('unit') for n in vals})!=1 or not vals[0].get('unit'): errors.append('Equation mixes counting units'); continue
        if not eq['disjoint'] or not eq['exhaustive']: errors.append('Only declared disjoint exhaustive partitions can be added'); continue
        if any(n.get('count') is None for n in vals):
            if confirmed:errors.append('Equation includes unknown counts')
            continue
        if vals[0]['count']!=sum(n['count'] for n in vals[1:]): errors.append(f'Count mismatch: {total}')
    for w in spec.get('time_windows',[]):
        if w['end']<w['start']: errors.append(f"{w['id']}: reversed time window")
    if confirmed:
        a=spec.get('approval',{})
        if a.get('status')!='confirmed' or not a.get('user_confirmation','').strip() or not a.get('proposal_version','').strip(): errors.append('Explicit current-proposal confirmation required')
        if a.get('proposal_version')!=spec['metadata']['proposal_version']:errors.append('Approval proposal version mismatch')
        if a.get('spec_sha256')!=digest(spec): errors.append('Approval hash does not match current content; reconcile changes with confirmed proposal')
        for n in spec['nodes']:
            if 'count' in n and n['count'] is None: errors.append(f"{n['id']}: unresolved count; resolve before final rendering")
        if spec['metadata'].get('unresolved'): errors.append('Unresolved structural/content items remain')
    return errors

def fonts_for(spec):
    cfg=spec.get('style',{})
    candidates=[cfg.get('font_file'), 'C:/Windows/Fonts/arial.ttf','/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf','/System/Library/Fonts/Supplemental/Arial.ttf']
    path=next((Path(x) for x in candidates if x and Path(x).is_file()),None)
    if not path: raise ValueError('No primary TrueType font: set style.font_file')
    text=''.join(n['label']+str(n.get('count',''))+n.get('unit','') for n in spec['nodes'])+''.join(e.get('label','') for e in spec.get('edges',[]))
    font=fitz.Font(fontfile=str(path)); missing={c for c in text if not c.isspace() and not font.has_glyph(ord(c))}
    if missing:
        alt=[cfg.get('cjk_font_file'),'C:/Windows/Fonts/simhei.ttf','/usr/share/fonts/truetype/wqy/wqy-zenhei.ttc']
        path=next((Path(x) for x in alt if x and Path(x).is_file()),None)
        if not path: raise ValueError('Primary font lacks characters; set style.cjk_font_file to an embeddable font')
        font=fitz.Font(fontfile=str(path))
        missing={c for c in text if not c.isspace() and not font.has_glyph(ord(c))}
        if missing: raise ValueError('Font has missing glyphs: '+''.join(sorted(missing)))
    from fontTools.ttLib import TTFont
    tt=TTFont(str(path),fontNumber=0)
    if tt['OS/2'].fsType & 0x0202: raise ValueError('Font forbids embedding or allows bitmap embedding only')
    names=tt['name'].names
    fam=next((n.toUnicode() for n in names if n.nameID==1),font.name)
    tt.close()
    return path,font,fam

def wrap(text,font,size,width):
    lines=[]
    for para in text.split('\n'):
        current=''
        for char in para:
            if current and font.text_length(current+char,fontsize=size)>width:
                cut=current.rfind(' ')
                if cut>0:
                    lines.append(current[:cut]); current=current[cut+1:]+char
                else: lines.append(current); current=char
            else: current+=char
        lines.append(current.rstrip())
    return lines

def ancestor(a,b,nm):
    cur=nm[b].get('parent'); visited=set()
    while cur in nm and cur not in visited:
        if cur==a:return True
        visited.add(cur); cur=nm[cur].get('parent')
    return False

def scene(spec):
    path,font,family=fonts_for(spec)
    size=spec.get('style',{}).get('font_size',10)
    stroke=spec.get('style',{}).get('line_width',.7)
    pad=spec.get('style',{}).get('padding',8)
    stage_gap=spec.get('style',{}).get('stage_gap',24)
    column_step=max(n.get('w',180) for n in spec['nodes'])+spec.get('style',{}).get('column_gap',36)
    nodes=[]
    for src in spec['nodes']:
        n=copy.deepcopy(src); n['shape']=n.get('shape','rect')
        n['size']=n.get('font_size',size); n['w']=n.get('w',180); requested_w=n['w']
        label=n['label']
        if n.get('count') is not None:
            label=(f"{n['count']:,} {label}" if n.get('count_position','separate')=='prefix' else label+f"\n{n['unit']} = {n['count']:,}")
        text_width=n['w']-(0 if n['shape']=='text' else 2*pad)
        if n['shape']=='diamond': text_width=n['w']*.54
        if n['shape']=='ellipse': text_width=n['w']*.72
        if text_width<=0:raise ValueError('Node width leaves no room for text')
        n['lines']=wrap(label,font,n['size'],text_width)
        if n.get('fit_width',True) and not n.get('container'):
            ink=max(font.text_length(line,fontsize=n['size']) for line in n['lines'])
            factor=.54 if n['shape']=='diamond' else .72 if n['shape']=='ellipse' else 1
            n['w']=max(ink/factor+(0 if n['shape']=='text' else 2*pad),1)
        n['leading']=max(1.25,font.ascender-font.descender)*n['size']
        needed=len(n['lines'])*n['leading']+(0 if n['shape']=='text' else 2*pad)
        if n['shape'] in {'diamond','ellipse'}:needed*=1.7
        n['h']=n.get('h',needed)
        if n['h']+0.01<needed:raise ValueError(f"{n['id']}: text exceeds node height ({needed:.1f} pt needed)")
        n['x']=n.get('x',180+n.get('lane',0)*column_step-requested_w/2)+(requested_w-n['w'])/2
        n['y']=n.get('y',n.get('rank',0)*90)
        n['fill']=n.get('fill','#ffffff'); n['stroke']=n.get('stroke','#333333')
        n['texts']=[]
        y=n['y']+(n['h']-len(n['lines'])*n['leading'])/2+font.ascender*n['size']
        for line in n['lines']:
            width=font.text_length(line,fontsize=n['size'])
            x=n['x']+(n['w']-width)/2 if n.get('align','center')=='center' else n['x']+pad
            n['texts'].append({'x':x,'y':y,'text':line,'size':n['size']}); y+=n['leading']
        nodes.append(n)
    groups={}
    for n in nodes:
        if n.get('width_group'):groups.setdefault(n['width_group'],[]).append(n)
    for members in groups.values():
        width=max(n['w'] for n in members)
        for n in members:
            centre=n['x']+n['w']/2;n['x']=centre-width/2;n['w']=width
            for t in n['texts']:
                t['x']=n['x']+(width-font.text_length(t['text'],fontsize=t['size']))/2 if n.get('align','center')=='center' else n['x']+pad
    auto=[n for n,source in zip(nodes,spec['nodes']) if 'y' not in source]
    levels=sorted({n.get('rank',0) for n in auto});top=0
    for rank in levels:
        members=[n for n in auto if n.get('rank',0)==rank]
        for n in members:
            delta=top-n['y'];n['y']=top
            for t in n['texts']:t['y']+=delta
        clearance=stage_gap
        for e in spec.get('edges',[]):
            if e.get('branch_from'):
                trunk=next(m for m in spec['edges'] if m['id']==e['branch_from'])
                if any(n['id']==trunk['from'] for n in members):
                    target=next(n for n in nodes if n['id']==e['to']);clearance=max(clearance,target['h']+2*stage_gap)
        top+=max(n['h'] for n in members)+clearance
    nm={n['id']:n for n in nodes}
    # Side boxes align to the selected trunk junction, not the next main box.
    em={e['id']:e for e in spec.get('edges',[])}
    for e in spec.get('edges',[]):
        if not e.get('branch_from') or not e.get('align_branch',True):continue
        trunk=em[e['branch_from']];a,b=nm[trunk['from']],nm[trunk['to']]
        if trunk.get('points'):pts=trunk['points']
        else:
            u=[a['x']+a['w']/2,a['y']+a['h']];v=[b['x']+b['w']/2,b['y']]
            if trunk.get('from_port','bottom')!='bottom' or trunk.get('to_port','top')!='top':raise ValueError('Use align_branch:false for nonvertical trunks and position explicitly')
            pts=[u,v] if abs(u[0]-v[0])<.01 else [u,[u[0],(u[1]+v[1])/2],[v[0],(u[1]+v[1])/2],v]
        idx=e.get('branch_segment',0)
        if idx>=len(pts)-1:raise ValueError('Branch segment index outside trunk')
        u,v=pts[idx:idx+2];f=e.get('branch_fraction',.5);anchor_y=u[1]+f*(v[1]-u[1])
        target=nm[e['to']];delta=anchor_y-target['y']-target['h']/2;target['y']+=delta
        for t in target['texts']:t['y']+=delta
        original=next(n for n in spec['nodes'] if n['id']==target['id'])
        if 'x' not in original:
            anchor_x=u[0]+f*(v[0]-u[0]);gap=spec.get('style',{}).get('branch_gap',24)
            new_x=anchor_x+gap if target['x']+target['w']/2>anchor_x else anchor_x-gap-target['w']
            shift=new_x-target['x'];target['x']=new_x
            for t in target['texts']:t['x']+=shift
    # Containers intentionally overlap descendants, but all other node overlaps are errors.
    for i,a in enumerate(nodes):
        for b in nodes[i+1:]:
            if ancestor(a['id'],b['id'],nm) or ancestor(b['id'],a['id'],nm):continue
            if fitz.Rect(a['x'],a['y'],a['x']+a['w'],a['y']+a['h']).intersects(fitz.Rect(b['x'],b['y'],b['x']+b['w'],b['y']+b['h'])):
                raise ValueError(f"Overlapping nodes: {a['id']} / {b['id']}")
    edges=[]
    def port(n,side):
        return {'top':(n['x']+n['w']/2,n['y']),'bottom':(n['x']+n['w']/2,n['y']+n['h']),'left':(n['x'],n['y']+n['h']/2),'right':(n['x']+n['w'],n['y']+n['h']/2)}[side]
    edge_map={e['id']:e for e in spec.get('edges',[])}
    raw_cache={}; active=set()
    def raw_route(e):
        if e['id'] in raw_cache:return raw_cache[e['id']]
        if e['id'] in active:raise ValueError('Cyclic branch anchor references')
        active.add(e['id']);a,b=nm[e['from']],nm[e['to']]
        if e.get('branch_from'):
            trunk=edge_map[e['branch_from']]
            if e['from']!=trunk['from']:raise ValueError('Branch semantic source must match its trunk source')
            if trunk.get('branch_from'):raise ValueError('Use a main trunk as branch_from, not another side branch')
            trunk_points=raw_route(trunk);idx=e.get('branch_segment',0)
            if idx>=len(trunk_points)-1:raise ValueError('Branch segment index outside trunk')
            u,v=trunk_points[idx:idx+2];f=e.get('branch_fraction',.5)
            p=(u[0]+f*(v[0]-u[0]),u[1]+f*(v[1]-u[1]))
            side=e.get('to_port','left' if b['x']+b['w']/2>p[0] else 'right');q=port(b,side)
            if abs(p[1]-q[1])<.01:points=[p,q]
            else:
                mid=(p[0]+q[0])/2;points=[p,(mid,p[1]),(mid,q[1]),q]
        elif e.get('points'):points=[tuple(p) for p in e['points']]
        else:
            p=port(a,e.get('from_port','bottom'));q=port(b,e.get('to_port','top'))
            if abs(p[0]-q[0])<.01:points=[p,q]
            else:
                mid=(p[1]+q[1])/2;points=[p,(p[0],mid),(q[0],mid),q]
        points=[p for i,p in enumerate(points) if i==0 or math.dist(p,points[i-1])>=.01]
        if len(points)<2:raise ValueError(f"{e['id']}: empty route")
        raw_cache[e['id']]=points;active.remove(e['id']);return points
    for src in spec.get('edges',[]):
        e=copy.deepcopy(src);points=raw_route(e)
        e['points']=points; e['stroke']=e.get('stroke','#333333'); e['head']=[]
        if e.get('arrow',True):
            p,q=points[-2:]; d=math.dist(p,q); ux=(q[0]-p[0])/d; uy=(q[1]-p[1])/d
            tip=(q[0]-ux*2,q[1]-uy*2); base=(tip[0]-ux*5,tip[1]-uy*5)
            if d<8:raise ValueError(f"{e['id']}: terminal segment too short for arrow")
            e['head']=[tip,(base[0]-uy*1.8,base[1]+ux*1.8),(base[0]+uy*1.8,base[1]-ux*1.8)]
            e['points']=points[:-1]+[tip]
        if e.get('label'):
            if 'label_at' not in e:raise ValueError(f"{e['id']}: labelled edges require label_at baseline [x,y]")
            e['text']={'x':e['label_at'][0],'y':e['label_at'][1],'text':e['label'],'size':size}
        # Check line intersections with unrelated nodes. Container crossings are intentional.
        for n in nodes:
            if n['id'] in {e['from'],e['to']} or n['shape']=='text' or n.get('container'):continue
            if ancestor(n['id'],e['from'],nm) or ancestor(n['id'],e['to'],nm):continue
            rect=fitz.Rect(n['x']+.5,n['y']+.5,n['x']+n['w']-.5,n['y']+n['h']-.5)
            for p,q in zip(e['points'],e['points'][1:]):
                if segment_hits(p,q,rect):raise ValueError(f"{e['id']}: route crosses unrelated node {n['id']}")
        edges.append(e)
    bounds=[]
    for n in nodes:bounds.append((n['x']-stroke/2,n['y']-stroke/2,n['x']+n['w']+stroke/2,n['y']+n['h']+stroke/2))
    for e in edges:
        for x,y in e['points']+e['head']:bounds.append((x-stroke/2,y-stroke/2,x+stroke/2,y+stroke/2))
        if 'text' in e:
            t=e['text'];bounds.append((t['x'],t['y']-font.ascender*size,t['x']+font.text_length(t['text'],fontsize=size),t['y']-font.descender*size))
    x0=min(b[0] for b in bounds); y0=min(b[1] for b in bounds); x1=max(b[2] for b in bounds); y1=max(b[3] for b in bounds)
    margin=spec.get('style',{}).get('margin',6)
    dx,dy=margin-x0,margin-y0
    for n in nodes:
        n['x']+=dx;n['y']+=dy
        for t in n['texts']:t['x']+=dx;t['y']+=dy
    for e in edges:
        for key in ['points','head']:e[key]=[(x+dx,y+dy) for x,y in e[key]]
        if 'text' in e:e['text']['x']+=dx;e['text']['y']+=dy
    if min(x1-x0+2*margin,y1-y0+2*margin)<72 or max(x1-x0+2*margin,y1-y0+2*margin)>4032:
        raise ValueError('PPTX requires canvas dimensions within 72–4032 pt. Reorganize the layout at the intended text size; do not add oversized blank margins.')
    # Outer containers first, then connectors, then children.
    return {'nodes':nodes,'edges':edges,'width':x1-x0+2*margin,'height':y1-y0+2*margin,'font_path':path,'font':font,'family':family,'stroke':stroke,'margin':margin,'spec_digest':digest(spec)}

def segment_hits(p,q,r):
    # Liang-Barsky clipping, excludes boundary-only contacts by caller's inset.
    dx=q[0]-p[0];dy=q[1]-p[1];lo,hi=0.,1.
    for a,b in [(-dx,p[0]-r.x0),(dx,r.x1-p[0]),(-dy,p[1]-r.y0),(dy,r.y1-p[1])]:
        if abs(a)<1e-10:
            if b<0:return False
        else:
            v=b/a
            if a<0:lo=max(lo,v)
            else:hi=min(hi,v)
            if lo>hi:return False
    return True

def polygon(n):
    x,y,w,h=n['x'],n['y'],n['w'],n['h']
    return [(x+w/2,y),(x+w,y+h/2),(x+w/2,y+h),(x,y+h/2)]

def font_bytes(s,text):
    from fontTools import subset
    from fontTools.ttLib import TTFont
    f=TTFont(str(s['font_path']),fontNumber=0)
    opt=subset.Options();opt.notdef_glyph=True
    sub=subset.Subsetter(options=opt);sub.populate(text=text);sub.subset(f)
    out=io.BytesIO();f.save(out);f.close();return out.getvalue()

def svg_text(t):
    return f'<text x="{t["x"]:.4f}" y="{t["y"]:.4f}" font-size="{t["size"]}">{html.escape(t["text"])}</text>'

def svg(s):
    alltext=''.join(t['text'] for n in s['nodes'] for t in n['texts'])+''.join(e.get('label','') for e in s['edges'])
    data=base64.b64encode(font_bytes(s,alltext)).decode()
    out=[f'<svg xmlns="http://www.w3.org/2000/svg" data-spec-sha256="{s["spec_digest"]}" width="{s["width"]:.4f}pt" height="{s["height"]:.4f}pt" viewBox="0 0 {s["width"]:.4f} {s["height"]:.4f}">',f'<style>@font-face{{font-family:MedFlowEmbedded;src:url(data:font/ttf;base64,{data})}}text{{font-family:MedFlowEmbedded;fill:#222}}</style>',f'<rect width="{s["width"]}" height="{s["height"]}" fill="#ffffff"/>']
    def node(n):
        x,y,w,h=n['x'],n['y'],n['w'],n['h'];st=f'fill="{n["fill"]}" stroke="{n["stroke"]}" stroke-width="{s["stroke"]}"'
        out.append(f'<g id="{html.escape(n["id"],quote=True)}">')
        if n['shape']=='rect':out.append(f'<rect x="{x}" y="{y}" width="{w}" height="{h}" {st}/>')
        if n['shape']=='ellipse':out.append(f'<ellipse cx="{x+w/2}" cy="{y+h/2}" rx="{w/2}" ry="{h/2}" {st}/>')
        if n['shape']=='diamond':out.append(f'<polygon points="'+ ' '.join(f'{x},{y}' for x,y in polygon(n))+f'" {st}/>')
        out.extend(svg_text(t) for t in n['texts']);out.append('</g>')
    for n in s['nodes']:
        if n.get('container'):node(n)
    for e in s['edges']:
        out.append(f'<g id="{html.escape(e["id"],quote=True)}">')
        dash=' stroke-dasharray="4 3"' if e.get('dashed') else ''
        out.append('<polyline points="'+' '.join(f'{x},{y}' for x,y in e['points'])+f'" fill="none" stroke="{e["stroke"]}" stroke-width="{s["stroke"]}"{dash}/>')
        if e['head']:out.append('<polygon points="'+' '.join(f'{x},{y}' for x,y in e['head'])+f'" fill="{e["stroke"]}"/>')
        if 'text' in e:out.append(svg_text(e['text']))
        out.append('</g>')
    for n in s['nodes']:
        if not n.get('container'):node(n)
    out.append('</svg>');return '\n'.join(out)

def rgb(v):return tuple(int(v[i:i+2],16)/255 for i in (1,3,5))

def pdf(s,path):
    doc=fitz.open();page=doc.new_page(width=s['width'],height=s['height'])
    def text(t):
        tw=fitz.TextWriter(page.rect);tw.append((t['x'],t['y']),t['text'],font=s['font'],fontsize=t['size']);tw.write_text(page,color=(.133,.133,.133))
    def node(n):
        if n['shape']!='text':
            sh=page.new_shape();r=fitz.Rect(n['x'],n['y'],n['x']+n['w'],n['y']+n['h'])
            if n['shape']=='rect':sh.draw_rect(r)
            elif n['shape']=='ellipse':sh.draw_oval(r)
            else:sh.draw_polyline(polygon(n)+[polygon(n)[0]])
            sh.finish(color=rgb(n['stroke']),fill=rgb(n['fill']),width=s['stroke'],closePath=True);sh.commit()
        for t in n['texts']:text(t)
    for n in s['nodes']:
        if n.get('container'):node(n)
    for e in s['edges']:
        sh=page.new_shape();sh.draw_polyline(e['points']);sh.finish(color=rgb(e['stroke']),width=s['stroke'],closePath=False,dashes='[4 3] 0' if e.get('dashed') else None);sh.commit()
        if e['head']:
            sh=page.new_shape();sh.draw_polyline(e['head']+[e['head'][0]]);sh.finish(color=rgb(e['stroke']),fill=rgb(e['stroke']),width=.1,closePath=True);sh.commit()
        if 'text' in e:text(e['text'])
    for n in s['nodes']:
        if not n.get('container'):node(n)
    doc.set_metadata({'keywords':s['spec_digest']});doc.subset_fonts();doc.save(path,garbage=4,deflate=True);doc.close()

def pptx(s,path):
    from pptx import Presentation
    from pptx.util import Pt
    from pptx.enum.shapes import MSO_SHAPE,MSO_CONNECTOR
    from pptx.dml.color import RGBColor
    from pptx.enum.dml import MSO_LINE_DASH_STYLE
    from pptx.oxml.xmlchemy import OxmlElement
    prs=Presentation();prs.core_properties.keywords=s['spec_digest'];prs.slide_width=Pt(s['width']);prs.slide_height=Pt(s['height']);sl=prs.slides.add_slide(prs.slide_layouts[6])
    sl.background.fill.solid();sl.background.fill.fore_color.rgb=RGBColor(255,255,255)
    def clean(sh):
        for el in list(sh._element):
            if el.tag.endswith('}style'):sh._element.remove(el)
    def color(v):return RGBColor.from_string(v[1:])
    def text(t,name):
        top=t['y']-s['font'].ascender*t['size'];w=s['font'].text_length(t['text'],fontsize=t['size'])+3
        sh=sl.shapes.add_textbox(Pt(t['x']),Pt(top),Pt(max(w,1)),Pt((s['font'].ascender-s['font'].descender)*t['size']+3));sh.name=name;clean(sh)
        tf=sh.text_frame;tf.clear();tf.word_wrap=False
        tf.margin_left=tf.margin_right=tf.margin_top=tf.margin_bottom=0
        p=tf.paragraphs[0];p.text=t['text'];p.font.name=s['family'];p.font.size=Pt(t['size']);p.font.color.rgb=color('#222222');p.space_before=p.space_after=Pt(0)
        for r in p.runs:
            rp=r._r.get_or_add_rPr()
            for tag in ['a:latin','a:ea','a:cs']:
                el=OxmlElement(tag);el.set('typeface',s['family']);rp.append(el)
    def node(n):
        if n['shape']!='text':
            kind={'rect':MSO_SHAPE.RECTANGLE,'ellipse':MSO_SHAPE.OVAL,'diamond':MSO_SHAPE.DIAMOND}[n['shape']]
            sh=sl.shapes.add_shape(kind,Pt(n['x']),Pt(n['y']),Pt(n['w']),Pt(n['h']));sh.name=n['id'];clean(sh)
            sh.fill.solid();sh.fill.fore_color.rgb=color(n['fill']);sh.line.color.rgb=color(n['stroke']);sh.line.width=Pt(s['stroke'])
        for i,t in enumerate(n['texts']):text(t,f"{n['id']}:text:{i}")
    for n in s['nodes']:
        if n.get('container'):node(n)
    for e in s['edges']:
        for i,(p,q) in enumerate(zip(e['points'],e['points'][1:])):
            sh=sl.shapes.add_connector(MSO_CONNECTOR.STRAIGHT,Pt(p[0]),Pt(p[1]),Pt(q[0]),Pt(q[1]));sh.name=f"{e['id']}:segment:{i}";clean(sh)
            sh.line.color.rgb=color(e['stroke']);sh.line.width=Pt(s['stroke'])
            if e.get('dashed'):sh.line.dash_style=MSO_LINE_DASH_STYLE.DASH
        if e['head']:
            pts=e['head'];fb=sl.shapes.build_freeform(pts[0][0],pts[0][1],scale=12700)
            fb.add_line_segments(pts[1:],close=True);sh=fb.convert_to_shape();sh.name=e['id']+':head';clean(sh)
            sh.fill.solid();sh.fill.fore_color.rgb=color(e['stroke']);sh.line.fill.background()
        if 'text' in e:text(e['text'],e['id']+':label')
    for n in s['nodes']:
        if not n.get('container'):node(n)
    prs.save(path)

def export(spec,outdir,name):
    errors=validate(spec,confirmed=True)
    if errors:raise ValueError('\n'.join(errors))
    s=scene(spec);outdir=Path(outdir);outdir.mkdir(parents=True,exist_ok=True)
    if Path(name).name!=name or name in {'.','..'}:raise ValueError('Output name must be a basename')
    # Stage all outputs: a failed conversion never counts an older file as a current success.
    with tempfile.TemporaryDirectory(prefix='medflow-',dir=outdir) as td:
        base=Path(td)/name;base.with_suffix('.svg').write_text(svg(s),encoding='utf-8')
        pdf(s,base.with_suffix('.pdf'));pptx(s,base.with_suffix('.pptx'))
        for ext in ['.svg','.pdf','.pptx']:
            p=base.with_suffix(ext)
            if not p.is_file() or not p.stat().st_size:raise ValueError('Incomplete three-format export')
        for ext in ['.svg','.pdf','.pptx']:os.replace(base.with_suffix(ext),outdir/(name+ext))
    return s
