---
name: medflow-skill
description: >
  Propose, create and revise academic flow, study-design and architecture diagrams. Use eight priority reference types: trial participant flow, observational selection, review selection, diagnostic flow, biospecimen flow, study timelines, analysis/model validation, and conceptual/logic frameworks; use a custom route for unlisted structures. Select from user materials, apply relevant reporting and journal guidance, wait for explicit proposal confirmation, then deliver editable SVG, PPTX and vector PDF.
---

# MedFlow: Medical Study Diagrams

## Scope and rules

- Use the [eight priority types](references/taxonomy.md) and their [type cards](references/types/) as preferred reference entry points, not a capability ceiling. For an unlisted flow, study-design or architecture diagram, use the [custom design route](references/custom-design.md). Do not force a match or refuse solely because no local folder exists. Panels may combine priority and custom types.
- **Propose first; draw only after explicit confirmation.** Before confirmation, inspect materials/references and present a text proposal. Do not generate diagram files or trial previews. Do not invent an approval record.
- **No figure title or explanatory annotations on the canvas.** Retain only study nodes, counts/units, necessary conditions, time labels and agreed structural labels. Put captions, footnotes, abbreviation lists, provenance and explanatory keys in the proposal/manuscript.
- White canvas, compact content-based cropping, a small, visually even outer margin; numerical defaults are advisory. Deliver only matching SVG, native editable PPTX and vector PDF; keep internal previews and records outside the deliverables.
- Unknown is not zero. Do not invent stages, counts, study relationships or methodological claims. A reference image supplies visual ideas, not study data or proof of reporting compliance.

## Separation of content and style

Type selection, research content and reporting requirements are determined from the user materials and confirmed proposal. The five style cards govern visual presentation only: layout, colours, fonts, sizes, strokes, shapes, alignment and spacing. Every style is available across the eight priority types and custom diagrams. A reference image's subject must never become a research-direction or content restriction. Adapt presentation to the approved content, not content to a reference's topology.

## Selection and proposal

1. Read [taxonomy](references/taxonomy.md). Select an existing type only when its purpose and relations fit; otherwise read [custom design](references/custom-design.md) and use `metadata.type: custom`. Consult applicable [reporting guidance](references/standards/reporting-guidelines.md) independently.
2. Read the selected style: [General](references/journals/general.md), [NEJM](references/journals/nejm.md), [Lancet](references/journals/lancet.md), [JAMA](references/journals/jama.md) or [BMJ](references/journals/bmj.md). If no journal is specified, propose General; do not choose a journal silently. Style cards describe visual intent and implementation limits, not automatic renderer capabilities.
3. Follow [reference inspection](references/reference-learning.md). Actually view a useful target or a small selection of relevant examples, usually one to three; do not scan the entire library or require a separate review document for a simple figure. If no useful reference is available, follow [independent layout](references/independent-layout.md) and design an attractive composition from the content, hierarchy, alignment and spacing. Briefly record the design basis in the proposal; never invent a viewed example. Reference availability is not a prerequisite for proceeding. Existing exemplars and style-reference images are optional visual aids, not topology templates.
4. Extract source-supported objects, units, counts, stages, times and relations. Use the [proposal template](references/proposal-template.md) to cover all eight design dimensions, guidance/version and unresolved points. For custom diagrams, record this plan in `metadata.custom_design` before rendering. Distinguish official requirements, reference observations and adjustable defaults. Check current official requirements for submission; do not claim unverified compliance.
5. **End the proposal turn and wait for clear approval.** Material changes to facts, branches or study logic require an updated proposal and confirmation. Pure layout corrections may continue within existing authorisation.

## Draw after confirmation

Keep `proposal.md` and `spec.json` in the user's project, outside this skill. Follow [specification guidance](references/spec-guide.md). Record the user's actual confirmation only after it is received:

```bash
python scripts/validate_spec.py project/spec.json
python scripts/validate_spec.py project/spec.json --record-confirmation "Actual user confirmation"
python scripts/render.py project/spec.json --out-dir project/deliverables --name figure
python scripts/check.py project/spec.json project/deliverables/figure --preview project/internal-preview.png
```

Use [visual rules](references/visual-rules.md). Encode side exclusions as trunk attachments rather than automatic box-to-box exits. Fit boxes to measured text; preserve equal widths only when deliberately specified. Review the rendered composition once against useful reference observations, or independent-layout principles when no reference was used. Do not iterate for negligible numerical differences. The generic engine measures text and shares point-based geometry across outputs. Simple flow layouts may use ranks/lanes; timelines, complex branching and logic frameworks need explicit geometry. Use project-specific drawing code when a selected style requires features absent from the generic renderer; preserve three-format checks rather than falsely claiming complete style support.

## Review and deliver

Follow the [review checklist](references/review-checklist.md). Inspect one internal preview at intended size; enlarge only a region with a suspected problem, verify study facts separately, and check editable PPTX objects and text. Use native Office rendering when available; otherwise state that application-specific layout has not been visually verified. A script PASS does not certify scientific or clinical correctness.

Deliver only `figure.svg`, `figure.pptx` and `figure.pdf`. Missing formats mean incomplete delivery. Dependencies: `pip install -r scripts/requirements.txt`. Use installed, embeddable fonts with complete glyph coverage; PPTX recipients need the referenced fonts. Test scope and limitations are recorded in [validation status](references/validation-status.md).
