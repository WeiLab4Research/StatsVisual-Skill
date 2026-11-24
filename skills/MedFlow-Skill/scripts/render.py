"""Render a confirmed MedFlow specification to editable SVG/PPTX and vector PDF."""
import argparse,sys
from engine import load,export

def main():
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('spec');ap.add_argument('--out-dir',required=True);ap.add_argument('--name',default='figure');a=ap.parse_args()
    try:
        s=export(load(a.spec),a.out_dir,a.name)
        print(f'Exported SVG, PPTX, PDF; tight canvas {s["width"]:.2f} x {s["height"]:.2f} pt. Run check.py and visually review.');return 0
    except (ValueError,OSError,ImportError,RuntimeError) as exc:print(f'Incomplete export: {exc}',file=sys.stderr);return 1
if __name__=='__main__':sys.exit(main())
