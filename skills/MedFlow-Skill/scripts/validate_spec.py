"""Validate specification; record confirmation only after actual user approval."""
import argparse,json,sys
from pathlib import Path
from engine import load,validate,digest

def main():
    ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('spec');ap.add_argument('--record-confirmation');ap.add_argument('--confirmed',action='store_true');args=ap.parse_args()
    try:
        s=load(args.spec);errors=validate(s,confirmed=args.confirmed)
        if errors:
            print('\n'.join(errors),file=sys.stderr);return 1
        if args.record_confirmation is not None:
            if not args.record_confirmation.strip():raise ValueError('Confirmation quote cannot be empty')
            s['approval']={'status':'confirmed','user_confirmation':args.record_confirmation,'proposal_version':s['metadata']['proposal_version'],'spec_sha256':digest(s)}
            Path(args.spec).write_text(json.dumps(s,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
        print('PASS: structural checks only; research and visual review still required.');return 0
    except (ValueError,OSError,TypeError) as exc:print(str(exc),file=sys.stderr);return 2
if __name__=='__main__':sys.exit(main())
