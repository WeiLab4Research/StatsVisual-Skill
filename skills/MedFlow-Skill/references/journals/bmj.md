# The BMJ: Visual Style Reference

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

- [Blue reference](../../assets/style-references/bmj/blue-evidence-flow.jpg): pale-blue rounded boxes, blue connectors, compact count badges and aligned parallel regions.
- [Purple reference](../../assets/style-references/bmj/purple-updated-review-flow.jpg): pale-purple rounded boxes, purple connectors, white-on-dark counts and aligned number/text columns.

These references inform appearance across priority and custom diagrams. Their original subject does not restrict this preset to evidence reviews or require any particular screening stages.

## Appearance

| Element | Preferred treatment |
|---|---|
| Nodes | Solid pale-blue or pale-purple rounded rectangles; no prominent dark outline |
| Connectors | Match the dark accent colour; consistent solid strokes and compact filled arrowheads; gentle rounded turns where appropriate |
| Count emphasis | Where the approved content contains a count, an optional compact dark rounded badge with bold white type; otherwise do not add a number or badge |
| Body text | Dark sans-serif type; centred short labels and left-aligned multiline lists |
| Alignment | Consistent padding, aligned comparable boxes, right-aligned number columns when present, hanging indents for wrapped text |

Blue preset: fill `#C7D3ED`, accent `#1679AC`. Purple preset: fill `#CCC5E4`, accent `#715AA8`. Body text `#292929`; badge text `#FFFFFF`. Fill values approximately reflect the supplied JPEGs; accent values are suggestions. Use one main palette per figure.

Start near 10 pt body text, 0.8–1 pt connectors, 4–6 pt node corner radii and 3–4 pt badge radii, adjusted to the actual geometry. Keep numeric grouping consistent with the manuscript. Decorative document icons are optional and should be omitted when irrelevant; they do not define an object or unit.

These visual treatments override generic neutral outlines and black connectors, but do not change the diagram's information, topology or terminology.

## Source and implementation limits

[BMJ author guidance](https://www.bmj.com/about-bmj/resources-authors/article-types) is a source entry point, not evidence that every visual value here is mandatory. This revision does not newly verify official specifications. Keep reporting and submission requirements in the appropriate task records, not as topic restrictions in this card.

The current generic renderer does not fully implement count badges, mixed bold spans, rounded nodes or curved turns. Use project-specific vector code or extend all exporters before claiming visual fidelity.

## Flexible use without an exemplar
All numerical styling values above are advisory starting points, not hard layout limits, unless independently required by a current official specification or the user. This style can be applied without a close reference image: use [independent layout](../independent-layout.md), the approved content and visual judgement. Preserve readability, balance and content fidelity; do not iterate for pixel-level agreement.
