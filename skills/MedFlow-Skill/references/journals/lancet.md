# The Lancet: Visual Style Reference

Updated: 2026-11-24.

## Scope: visual presentation only

This style card constrains appearance: layout, colours, typography, font sizes, shapes, strokes, spacing, alignment and visual emphasis. It applies across all priority and custom diagram types and research topics. Selecting it must not select or exclude a research design, topic, dataset, analysis method, clinical pathway or substantive diagram content.

The user materials, confirmed proposal, type card and applicable reporting guidance determine content, stages, relations, counting units and labels. This card only presents that content visually. Do not add, remove, merge or reinterpret study information to make it resemble a reference. When a layout does not fit, adapt its visual organisation while preserving the approved relationships; do not force the reference's topology.

Reference images demonstrate visual devices. Their subjects, numbers, terminology, methods and conclusions are not templates for the new study. Publication attribution and permissions remain unverified unless separately documented. Suggested colours and dimensions are working defaults, not verified official journal specifications.

## Shared visual and delivery requirements

- Keep a white canvas and compact content-based cropping: default outer padding 6 pt, normally within 4–10 pt. Retain enough internal space for legible text and clean routes.
- No figure title or explanatory annotations on the canvas. Necessary node, group, condition and time labels remain structural content; captions, footnotes, abbreviation lists and explanatory keys belong outside the figure.
- Start near 10 pt text at final size, then adjust according to verified visual requirements and the confirmed proposal. Measure actual glyph widths and regular/bold/italic faces. Do not copy apparent pixel sizes from raster images.
- The approved specification determines arrow direction and meaning. Style controls colour, weight, routing appearance and arrowhead geometry, not the underlying relation. Use consistent visual encodings without making colour the sole way to read a distinction.
- Deliver only editable SVG, native editable PPTX and vector PDF with consistent visible content and geometry. Preserve live text; do not flatten the diagram into an image in PPTX.
- Record the visual choice in the proposal and follow the skill's confirmation workflow. Review outputs at final size and enlarged scale. State when native Office rendering was unavailable.

Official visual-guidance entry point: [The Lancet artwork guidance](https://www.thelancet.com/pb/assets/raw/Lancet/authors/artwork-guidelines.pdf). The earlier access attempt returned HTTP 403. This revision does not newly verify that document or substitute a specialty journal's rules. Treat the visual values below as reference-based defaults unless official specifications are available.

## Visual references

- [Reference 1](../../assets/style-references/nejm-lancet/trial-recruitment-followup.jpg): white square boxes, clear dark outlines, orthogonal connectors and aligned parallel regions.
- [Reference 2](../../assets/style-references/nejm-lancet/cohort-selection-matching.jpg): mostly white boxes, occasional pale emphasis fills and labelled connectors.
- [Reference 3](../../assets/style-references/nejm-lancet/clinical-classification-emphasis.jpg): white ordinary nodes with selected coloured label boxes and consistent directional routing.

The user supplied these as a collective NEJM/Lancet visual reference set; individual journal attribution is unverified. Do not invent journal-specific differences from these images. Their original research subjects do not restrict the use of this preset or prescribe any stages, criteria or categories.

## Appearance

| Element | Preferred treatment |
|---|---|
| Canvas and ordinary nodes | White canvas and white square-cornered boxes; no automatic tint on every node |
| Outlines | Clear black or dark-grey strokes, consistently weighted |
| Connectors | Solid dark orthogonal routes with compact filled arrowheads and clean junctions |
| Typography | Readable dark sans-serif type; centred short labels, left-aligned lists and hanging indents |
| Counts | When present, count-first labels are available; regular-weight counts are acceptable; no mandatory badge or bold treatment |
| Composition | Align comparable columns and rows; size boxes from text, with sufficient space for existing branches and labels |

Start near 10 pt body text, 0.6–0.9 pt strokes, 6–8 pt inner padding and zero corner radius. These are adjustable design suggestions, not official measurements. Do not copy the screenshot frame or its surrounding blank areas.

## Optional visual emphasis

White boxes remain the default. A small number of selected nodes may use a restrained pale fill, such as suggested `#EEF4F6`, for an emphasis role explicitly agreed in the proposal. Several muted colours are permitted when they make existing distinctions clearer. Keep dark readable text and consistent colours for equivalent roles.

Colour is a presentation choice, not a reason to add categories or imply new scientific meaning. Existing labels must remain sufficient to understand the distinctions. Avoid saturated fills behind dense text, gradients, shadows and large coloured canvas panels.

## Implementation note

The generic renderer supports the core white boxes, explicit fills and orthogonal routes. It does not automatically reproduce every nested text layout, mixed font run or complex label position. Use explicit geometry or project-specific vector code as needed. A colour or metadata change alone is not proof of full visual fidelity.

## Flexible use without an exemplar
All numerical styling values above are advisory starting points, not hard layout limits, unless independently required by a current official specification or the user. This style can be applied without a close reference image: use [independent layout](../independent-layout.md), the approved content and visual judgement. Preserve readability, balance and content fidelity; do not iterate for pixel-level agreement.
