from pathlib import Path
import sys,tempfile,unittest,copy
R=Path(__file__).resolve().parents[1];sys.path.insert(0,str(R/'scripts'))
import pymupdf as fitz
from engine import load,validate,digest,export
from check import check

def sample():
 s=load(R/'assets/templates/08-conceptual-logic-model.json')
 s['metadata'].pop('unresolved',None);s['approval']={'status':'confirmed','proposal_version':s['metadata']['proposal_version'],'user_confirmation':'Synthetic engineering QA only','spec_sha256':digest(s)};return s

class FlexibleTests(unittest.TestCase):
 def test_style_values_are_flexible_but_valid(self):
  s=sample();s['style']={'font_size':25,'margin':2,'padding':22,'stage_gap':70,'column_gap':100,'branch_gap':100};self.assertFalse(validate(s))
  s['style']['font_size']=0;self.assertTrue(validate(s))
 def test_dimensions_approximate_and_content_strict(self):
  with tempfile.TemporaryDirectory() as td:
   s=sample();export(s,td,'figure');base=Path(td)/'figure';self.assertEqual(check(s,base)['status'],'PASS')
   pdf=base.with_suffix('.pdf');doc=fitz.open(pdf);r=doc[0].mediabox;doc[0].set_mediabox(fitz.Rect(0,0,r.width+.4,r.height));new=Path(td)/'changed.pdf';doc.save(new);doc.close();new.replace(pdf)
   self.assertEqual(check(s,base)['status'],'PASS')
   doc=fitz.open(pdf);r=doc[0].mediabox;doc[0].set_mediabox(fitz.Rect(0,0,r.width+20,r.height));doc.save(new);doc.close();new.replace(pdf)
   self.assertEqual(check(s,base)['status'],'REVIEW')
   from pptx import Presentation
   deck=Presentation(base.with_suffix('.pptx'))
   next(x for x in deck.slides[0].shapes if x.has_text_frame and x.text).text='Changed study content';deck.save(base.with_suffix('.pptx'))
   with self.assertRaises(ValueError):check(s,base)
 def test_confirmation_unchanged(self):
  s=sample();s.pop('approval');self.assertTrue(validate(s,True))
 def test_no_reference_route_is_available(self):
  self.assertTrue((R/'references/independent-layout.md').is_file())
  self.assertNotIn('reference_review',load(R/'schemas/figure.schema.json')['properties']['metadata']['required'])

if __name__=='__main__':unittest.main(verbosity=2)
