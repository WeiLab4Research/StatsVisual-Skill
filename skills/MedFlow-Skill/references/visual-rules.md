# Visual rules: balanced rather than numerically exact

## Requirements

- Preserve research content, paths, counts and meanings. Visual editing must not silently remove or merge study information.
- Keep text readable and fully visible, boxes clear of unrelated elements, and connectors away from unrelated boxes and labels. Use the correct node or trunk attachment for each relation.
- Keep a white canvas with a small, visually even outer margin. Do not put figure titles or explanatory annotations on the canvas; necessary study and structural labels remain.
- Deliver editable SVG, native editable PPTX and vector PDF with consistent information and readable appearance. Minor rendering differences are acceptable.

## Flexible visual guidance

Font sizes, line weights, box dimensions, gaps and margins are approximate starting values. Judge them at the intended viewing size, not against a fixed pt grid. Existing renderer defaults remain convenient initial settings, not mandatory specifications. Schema validation accepts alternative sensible dimensions; this does not mean very small or excessive values are visually recommended.

Fit boxes to text with comfortable padding, preserving coordinated widths for peer groups when useful. Let content drive height. Avoid both empty oversized boxes and text touching borders. Small outer margins do not mean tightly packed internal gaps. Reserve room above and below side boxes; shorten unnecessarily long empty connectors. Allow unequal branch heights and purposeful asymmetry.

Use [reference inspection](reference-learning.md) when examples are available, and [independent layout](independent-layout.md) when they are absent or unsuitable. Either route must produce a coherent and attractive proposal; no reference image is required to proceed.

## Styles

[General](journals/general.md), [NEJM](journals/nejm.md), [Lancet](journals/lancet.md), [JAMA](journals/jama.md) and [BMJ](journals/bmj.md) constrain appearance only. Their suggested numbers are advisory unless a current official requirement or explicit user instruction makes a particular value necessary. They do not constrain research directions, diagram content or study relationships.

## Proportionate verification

Produce one reasonable layout, export the three formats and perform one overall visual review. Repeat only for changed content, clipping, collisions, incorrect routes, obvious imbalance or a real export failure. Do not redraw for negligible coordinate, stroke or font-metric differences. Structural and content checks remain strict; visual fine tuning is discretionary.

Use pt consistently inside the renderer as an implementation unit, without implying a demand for exact measurements from the user. Preserve actual file-format size limits, such as PPTX slide constraints, rather than bypassing them with invalid output.
