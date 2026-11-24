"""List local references, or generate an internal contact sheet. Does not download or infer sources."""
import argparse,csv
from pathlib import Path
ROOT=Path(__file__).resolve().parent.parent

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--type',required=True);p.add_argument('--sheet');a=p.parse_args()
    dirs={d.name:d for d in (ROOT/'assets/exemplars').iterdir() if d.is_dir()}
    if a.type == 'custom':
        print('Custom diagrams have no required local folder. Inspect relevant priority/style references and explain gaps in the proposal.');return
    if a.type not in dirs:p.error('Unknown local reference folder; use --type custom for the custom route')
    images=[f for f in sorted(dirs[a.type].iterdir()) if f.suffix.lower() in {'.png','.jpg','.jpeg','.gif','.webp'}]
    for i,f in enumerate(images,1):print(f'{i}. {f.resolve()}')
    if not images:print('No local references for this type. State the gap; do not invent examples.')
    if a.sheet and images:
        from PIL import Image,ImageOps,ImageDraw
        thumb_w,thumb_h=360,280;sheet=Image.new('RGB',(thumb_w*3,((len(images)+2)//3)*(thumb_h+30)),'white');draw=ImageDraw.Draw(sheet)
        for i,f in enumerate(images):
            with Image.open(f) as im:im=ImageOps.contain(im.convert('RGB'),(thumb_w-12,thumb_h-12));sheet.paste(im,((i%3)*thumb_w+6,(i//3)*(thumb_h+30)+6))
            draw.text(((i%3)*thumb_w+6,(i//3)*(thumb_h+30)+thumb_h),str(i+1),fill='black')
        out=Path(a.sheet);out.parent.mkdir(parents=True,exist_ok=True);sheet.save(out)
if __name__=='__main__':main()
