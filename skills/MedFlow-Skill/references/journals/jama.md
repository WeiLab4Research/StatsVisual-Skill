# JAMA: Visual Style Reference

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

## Visual references

- [Reference 1](../../assets/style-references/jama/diagnostic-classification-flow.png): pale blue-grey square boxes, fine grey lines, inline bold counts and nested indentation.
- [Reference 2](../../assets/style-references/jama/recruitment-evaluation-flow.png): a stable central alignment, lateral boxes, parallel columns and consistent downstream spacing.

The subjects of these examples do not limit this preset to diagnostic or recruitment studies. Use its appearance with any approved priority or custom diagram content, without copying their categories, lists or branching structure.

## Appearance

| Element | Preferred treatment |
|---|---|
| Nodes | Square-cornered rectangles with pale blue-grey fill and thin neutral-grey outlines |
| Connectors | Fine neutral-grey solid lines, clean orthogonal turns and small filled triangular arrowheads |
| Typography | Dark sans-serif text; when counts are present, bold counts followed by regular descriptions |
| Lists | Right-aligned counts in a separate visual column, aligned descriptions, consistent nested indents and hanging continuation lines |
| Composition | Align comparable boxes and rows; let heights follow content rather than forcing identical heights |

Suggested fill `#EAF1F4` or `#E6EDF1`, text `#231F20`, neutral outline/connector approximately `#858689`. Use one fill consistently. The fills/text reflect representative PNG samples; stroke colour and dimensions are adjustable suggestions rather than official specifications.

Start near 10 pt body text, 0.5–0.7 pt strokes, 6–8 pt inner padding and zero corner radius. Measure regular and bold faces. Do not compress character spacing or force a narrow font simply to fit text. A short count-description unit may be centred; multiline content should retain a stable text column. Do not add count badges, numbers or explanatory text absent from the approved content.

## Source and implementation limits

[JAMA Instructions for Authors](https://jamanetwork.com/journals/jama/pages/instructions-for-authors) provides the official source entry point. This card's supplied examples have not been individually attributed to the main journal or a specialty journal. Do not label inferred visual values as verified universal JAMA mandates; confirm task-specific visual requirements separately.

The generic renderer handles basic rectangular nodes and neutral connectors but not all mixed bold/regular inline runs, aligned count columns or nested list treatments. Extend the shared scene and exporters, or use project-specific vector code, when required for faithful appearance.

## Flexible use without an exemplar
All numerical styling values above are advisory starting points, not hard layout limits, unless independently required by a current official specification or the user. This style can be applied without a close reference image: use [independent layout](../independent-layout.md), the approved content and visual judgement. Preserve readability, balance and content fidelity; do not iterate for pixel-level agreement.
