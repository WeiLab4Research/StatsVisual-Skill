# General: Flexible Visual Style

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

Use this card when General is requested or no journal style is specified. General offers a flexible visual language, not a research classification.

## Visual references

- [Reference 1](../../assets/style-references/general/validation-hierarchy.png): dark-blue header bands, white card bodies, aligned branching and restrained accents.
- [Reference 2](../../assets/style-references/general/parallel-validation-cohorts.webp): parallel columns, pale-blue boxes, white side boxes and subtle separators.
- [Reference 3](../../assets/style-references/general/intervention-logic-model.webp): grouped regions, pale role-based fills, differentiated connectors and varied content density.

These observations describe appearance only; none restricts the research topic or requires the source image's categories or stages.

## Layout treatments

| Treatment | Visual characteristics |
|---|---|
| G1: Banded cards | Deep-blue label bands with white text, white card bodies, consistent hierarchy spacing and aligned branches |
| G2: Parallel columns | Stable column widths, coordinated pale fills, aligned comparable rows and optional subtle separators |
| G3: Grouped regions | Small sets of pale fills, visible group boundaries and deliberate spacing between connected regions |

Select or combine these treatments according to the already approved content. They are compositional options, not exclusive diagram types, research directions or fixed sequences. Do not invent a split, extra level or group solely to reproduce their appearance.

## Palette and typography

Suggested colours: header `#214F7D`, connector `#4D7EA8`, pale-blue fill `#E4EFF7`, outline `#B9C1C7`, pale-green fill `#F0F6E8`, optional peach accent `#FAD9BA`. These are suggested design values rather than official source colours. Use a restrained subset and consistent roles.

Use one coherent readable font family per figure. Sans-serif is the default; a serif alternative is allowed when requested or appropriate to the confirmed visual plan. Use bold selectively for existing headings or counts. Body text starts near 10 pt, strokes near 0.6–0.9 pt and inner padding near 6–8 pt. White type requires a sufficiently dark background.

Avoid copying decorative banners, dense explanatory panels or legends. Existing essential information must remain readable through the approved labels and structure; do not delete content to satisfy a visual simplification.

## Implementation note

The generic renderer supports basic shapes, fills and explicit routes, but not every compound header/body card, mixed text run or grouping treatment. Metadata selecting General does not automatically implement these treatments. Use project-specific vector code or extend the shared scene and exporters when necessary; inspect all three formats.

## Flexible use without an exemplar
All numerical styling values above are advisory starting points, not hard layout limits, unless independently required by a current official specification or the user. This style can be applied without a close reference image: use [independent layout](../independent-layout.md), the approved content and visual judgement. Preserve readability, balance and content fidelity; do not iterate for pixel-level agreement.
