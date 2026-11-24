# Validation status

Updated: 2026-11-24. Eight priority reference types plus custom diagrams remain supported. Approval, source traceability, counting units, path preservation, correct attachments and editable SVG/PPTX/vector PDF delivery remain required.

Visual dimensions and spacing are advisory. The schema accepts positive/nonnegative style settings beyond the former narrow ranges. Page-size comparisons tolerate small differences and flag noticeable mismatches for visual review rather than forcing exact resizing; stale-source and changed-text checks remain strict.

The independent-layout guide supports design without a useful reference. Reference inspection is proportionate; separate review documents and repeated measurements are not mandatory. Attractive composition still depends on applying and visually reviewing the plan; documentation and program checks alone cannot prove aesthetic quality.

Verification: nine geometry/attachment/template regression tests and four flexible-layout tests passed. These cover trunk-side exits, text fitting, peer widths, balanced gaps, existing three-format starters, positive settings beyond old ranges, approximate page dimensions, missing-reference workflow availability and retained approval/content checks. Local links and skill metadata are also checked. Run tests/test_geometry.py and tests/test_flexible.py to reproduce engineering checks.

No runtime improvement is claimed without profiling. Native Office visual fidelity and scientific correctness are not certified by these tests.
