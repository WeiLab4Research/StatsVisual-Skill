"""Verify current three-format scene consistency. Does not certify medical correctness or Office rendering."""
import argparse,sys,unicodedata,xml.etree.ElementTree as ET
from pathlib import Path
import pymupdf as fitz
from pptx import Presentation
from engine import load,validate,scene

def norm(s):return ''.join(unicodedata.normalize('NFKC',s).replace('\u00ad','-').split())
def check(spec,base,preview=None):
    errors=validate(spec,confirmed=True)
    if errors:raise ValueError('\n'.join(errors))
    s=scene(spec);base=Path(base);warnings=[]
    width_tol=max(1.0,s['width']*.005);height_tol=max(1.0,s['height']*.005)
    for ext in ['.svg','.pdf','.pptx']:
        p=base.with_suffix(ext)
        if not p.is_file() or not p.stat().st_size:raise ValueError('Missing/nonempty current output '+str(p))
    svg=ET.parse(base.with_suffix('.svg')).getroot();ns={'s':'http://www.w3.org/2000/svg'}
    if svg.attrib.get('data-spec-sha256')!=s['spec_digest']:raise ValueError('SVG was not generated from current specification')
    texts=[t['text'] for n in s['nodes'] for t in n['texts']]+[e['text']['text'] for e in s['edges'] if 'text' in e]
    expected=sorted(map(norm,texts))
    actual=sorted(norm(''.join(t.itertext())) for t in svg.findall('.//s:text',ns))
    if actual!=expected:raise ValueError('SVG text differs from current scene')
    vb=list(map(float,svg.attrib['viewBox'].split()))
    if abs(vb[2]-s['width'])>width_tol or abs(vb[3]-s['height'])>height_tol:warnings.append('SVG page dimensions differ noticeably; visually review proportions')
    ids={g.attrib.get('id') for g in svg.findall('.//s:g',ns)}
    if not {n['id'] for n in s['nodes']}.issubset(ids):raise ValueError('SVG node IDs missing')
    deck=Presentation(base.with_suffix('.pptx'))
    if deck.core_properties.keywords!=s['spec_digest']:raise ValueError('PPTX was not generated from current specification')
    if len(deck.slides)!=1:raise ValueError('Expected one diagram slide')
    if abs(deck.slide_width/12700-s['width'])>width_tol or abs(deck.slide_height/12700-s['height'])>height_tol:warnings.append('PPTX page dimensions differ noticeably; visually review proportions')
    shapes=deck.slides[0].shapes
    actual=sorted(norm(sh.text) for sh in shapes if sh.has_text_frame and sh.text)
    if actual!=expected:raise ValueError('PPTX editable text differs from current scene')
    names={sh.name for sh in shapes}
    for e in s['edges']:
        for i in range(len(e['points'])-1):
            if f"{e['id']}:segment:{i}" not in names:raise ValueError('PPTX connector missing')
        if e.get('label') and e['id']+':label' not in names:raise ValueError('PPTX edge label missing')
    if any(sh.shape_type==13 for sh in shapes):raise ValueError('Unexpected flattened picture in editable deck')
    doc=fitz.open(base.with_suffix('.pdf'))
    if doc.metadata.get('keywords')!=s['spec_digest']:raise ValueError('PDF was not generated from current specification')
    if len(doc)!=1:raise ValueError('PDF must have one page')
    pg=doc[0]
    if abs(pg.rect.width-s['width'])>width_tol or abs(pg.rect.height-s['height'])>height_tol:warnings.append('PDF page dimensions differ noticeably; visually review proportions')
    pdftext=norm(pg.get_text())
    for t in texts:
        if norm(t) not in pdftext:raise ValueError('PDF missing searchable text: '+t)
    if pg.get_images():raise ValueError('PDF contains raster images instead of expected vector scene')
    if preview:
        out=Path(preview);out.parent.mkdir(parents=True,exist_ok=True);pg.get_pixmap(matrix=fitz.Matrix(2,2),alpha=False).save(out)
    doc.close()
    return {'status':'REVIEW' if warnings else 'PASS','warnings':warnings,'width_pt':round(s['width'],3),'height_pt':round(s['height'],3),'margin_pt':s['margin'],'editable_text_lines':len(texts),'scope':'structure/text/canvas consistency; medical review and Office visual review remain'}

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('spec');p.add_argument('basename');p.add_argument('--preview');a=p.parse_args()
    try:print(check(load(a.spec),a.basename,a.preview));return 0
    except (ValueError,OSError) as e:print(str(e),file=sys.stderr);return 1
if __name__=='__main__':sys.exit(main())
