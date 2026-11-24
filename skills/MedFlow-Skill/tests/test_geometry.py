import sys,tempfile,unittest,copy,re
from pathlib import Path
R=Path(__file__).resolve().parents[1];sys.path.insert(0,str(R/'scripts'))
from engine import load,validate,scene,digest,export
from check import check

def sample():
    return {'schema_version':'2.4','metadata':{'type':'02-observational-selection','purpose':'Synthetic geometry test','study_design':'synthetic','journal':'lancet','proposal_version':'test-v1','guidance':[]},'nodes':[{'id':'a','label':'Assessed for eligibility','count':100,'unit':'participants','count_position':'prefix','source':'synthetic','x':0,'y':0,'w':180},{'id':'b','label':'Included in analysis','count':80,'unit':'participants','count_position':'prefix','source':'synthetic','x':0,'y':180,'w':180},{'id':'c','label':'Excluded','count':20,'unit':'participants','count_position':'prefix','source':'synthetic','x':230,'y':90,'w':180}],'edges':[{'id':'exit','from':'a','to':'c','relation':'exclusion','source':'synthetic','branch_from':'trunk'},{'id':'trunk','from':'a','to':'b','relation':'flow','source':'synthetic'}]}
def approve(s):s['approval']={'status':'confirmed','proposal_version':'test-v1' if s['metadata']['proposal_version']=='test-v1' else s['metadata']['proposal_version'],'user_confirmation':'Synthetic engineering QA only','spec_sha256':digest(s)}

class Tests(unittest.TestCase):
    def test_balanced_automatic_spacing(self):
        s=sample()
        for n,rank,lane in zip(s['nodes'],[0,1,1],[0,0,1]):
            n.pop('x');n.pop('y');n['rank']=rank;n['lane']=lane
        g=scene(s);nm={n['id']:n for n in g['nodes']};em={e['id']:e for e in g['edges']}
        junction=em['exit']['points'][0]
        self.assertAlmostEqual(nm['c']['x']-junction[0],24)
        self.assertAlmostEqual(nm['b']['y']-nm['a']['y']-nm['a']['h'],nm['c']['h']+48)
        self.assertGreater(nm['b']['y']-nm['a']['y'],90)
        self.assertLess(nm['b']['y']-nm['a']['y'],140)
    def test_content_based_width_groups(self):
        s=sample();s['nodes'][0]['width_group']='main';s['nodes'][1]['width_group']='main';g=scene(s)
        self.assertEqual(g['nodes'][0]['w'],g['nodes'][1]['w']);self.assertLess(g['nodes'][0]['w'],180)
        self.assertLess(g['nodes'][2]['w'],g['nodes'][0]['w'])
    def test_interior_anchor_independent_of_order(self):
        s=sample();g=scene(s);nodes={n['id']:n for n in g['nodes']};edges={e['id']:e for e in g['edges']}
        p=edges['exit']['points'][0];self.assertAlmostEqual(p[0],edges['trunk']['points'][0][0]);self.assertGreater(p[1],nodes['a']['y']+nodes['a']['h']);self.assertLess(p[1],nodes['b']['y'])
        self.assertAlmostEqual(nodes['c']['y']+nodes['c']['h']/2,p[1],places=3)
    def test_text_fit_and_preserved_width(self):
        s=sample();g=scene(s);n=g['nodes'][2];self.assertLess(n['h'],60);self.assertLess(n['w'],180)
        self.assertAlmostEqual(n['h'],len(n['lines'])*n['leading']+16)
        s['nodes'][2]['fit_width']=False;self.assertEqual(scene(s)['nodes'][2]['w'],180)
    def test_trunk_resizes_with_text(self):
        s=sample();before=scene(s);s['nodes'][0]['label']='Assessed for eligibility\nAdditional source-supported eligibility details';after=scene(s)
        self.assertGreater(after['nodes'][0]['h'],before['nodes'][0]['h']);self.assertGreater(after['edges'][0]['points'][0][1],before['edges'][0]['points'][0][1])
    def test_invalid_branch(self):
        s=sample();del s['edges'][0]['branch_from'];self.assertTrue(validate(s))
        s=sample();s['edges'][0]['branch_fraction']=0;self.assertTrue(validate(s))
        s=sample();s['edges'][0]['branch_from']='missing';self.assertTrue(validate(s))
    def test_confirmation_and_exports(self):
        s=sample()
        with tempfile.TemporaryDirectory() as td:
            with self.assertRaises(ValueError):export(s,td,'figure')
            approve(s);export(s,td,'figure');self.assertEqual(check(s,Path(td)/'figure')['status'],'PASS')
        approve(s);s['nodes'][0]['label']='Changed label';self.assertTrue(validate(s,True))
    def test_existing_templates(self):
        with tempfile.TemporaryDirectory() as td:
            for p in (R/'assets/templates').glob('*.json'):
                with self.subTest(template=p.name):
                    s=load(p);self.assertFalse(validate(s));s['metadata'].pop('unresolved',None);s.pop('equations',None)
                    for n in s['nodes']:
                        if 'count' in n:n['count']=100
                    approve(s);export(s,td,p.stem);self.assertEqual(check(s,Path(td)/p.stem)['status'],'PASS')
    def test_links(self):
        for p in R.rglob('*.md'):
            for link in re.findall(r'\]\(([^)]+)\)',p.read_text(encoding='utf-8')):
                if '://' not in link and not link.startswith('#'):self.assertTrue((p.parent/link.split('#')[0]).exists(),str(p)+':'+link)

if __name__=='__main__':unittest.main(verbosity=2)
