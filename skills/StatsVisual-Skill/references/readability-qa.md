# Figure Readability QA

Use this reference before final delivery and whenever a plot looks technically valid but may be hard to read at final size.

## Scale And Panel Policy

- Shared axes are appropriate only when panels compare the same measure on the same absolute scale.
- Do not force shared axes when the result makes one subgroup visually collapse. Consider `facet_wrap(scales = "free_y")`, log transformation, an inset, separate figures, or direct numeric labels.
- If a panel's data span uses less than 20% of its axis span, treat it as `WARN`.
- If a panel's data span uses less than 10% of its axis span, treat it as `FAIL` unless the compressed scale is scientifically intentional and explicitly explained.
- When panel data spans differ by more than 10-fold under a shared axis, reassess whether the axis should be shared.

## Overlap And Layout Checks

Treat overlap and layout as publication-readability issues, not cosmetic preferences.

- Label-label overlap: axis tick labels, direct labels, facet strips, legends, and annotations must not collide or become ambiguous. Treat unreadable or merged text as `FAIL`; treat close but still readable text as `WARN` and revise when feasible.
- Mark-label overlap: labels and annotations must not sit on top of points, bars, intervals, density ridges, survival steps, heatmap cells, or error bars unless the label is intentionally inside a large mark with adequate contrast.
- Mark-mark overlap: dense points, intervals, or categories should use jitter, dodging, transparency, summarization, faceting, or alternate geometry when overlap hides the distribution or ranking.
- Plot-edge clipping: no text, legend, confidence band, interval, or point should be clipped by panel edges or export margins.
- Layout balance: panels should have aligned plot areas, consistent spacing, and enough breathing room for labels. Avoid cramped legends, oversized titles, excessive empty space, and panels whose data region feels visually secondary to decoration or margins.
- Visual hierarchy: the main result should be immediately visible at final size; supporting annotations should guide interpretation without competing with the data.

## Mandatory Checks

- Axis titles include units, transformations, denominators, or time scales where relevant.
- Text remains readable at the final export size, not only in a zoomed preview.
- Labels, legends, and statistical annotations do not overlap each other or cover the main data.
- Data marks do not collide with labels, panel borders, legends, or annotations in a way that obscures values or comparisons.
- Legends are concise; direct labels are preferred when a legend becomes long or hard to scan.
- Colors remain distinguishable when printed small or viewed in grayscale.
- Multi-panel figures keep panel labels, shared encodings, and legends consistent.
- Multi-panel layouts look intentional: panel sizes, spacing, alignment, and shared legends should support the figure's message.
- Every statistical panel states or implies sample size, interval definition, and model/test source.
- No figure captions, explanatory text, or inline annotations appear inside the figure panel.
- SVG/PDF text should remain editable when feasible.

## Required QA Loop

Run both validators before delivery:

```text
Rscript scripts/validate_r_plot.R <project_dir>/figures
Rscript scripts/validate_figure_readability.R <plot_rds> <project_dir>/figures <figure_name> <width_in> <height_in> <project_dir>
```

If readability validation reports `FAIL`, revise the plot code and export again. Do not deliver a failed figure as publication-ready output.

If warnings remain after a reasonable revision, mention them in the final reply.

## Visual Review

When image viewing is available, inspect the final web PNG or TIFF preview directly. Check whether:

- the plotted data are large enough to read;
- the smallest panel is not visually dominated by empty space;
- labels, legends, and annotations do not overlap each other or the data;
- labels are not clipped by plot boundaries or export margins;
- marks are not hidden by other marks, labels, legends, or annotations;
- grouped or faceted subplots are not misleading because of shared scales;
- the layout is balanced, aligned, and visually calm at final size;
- the visual hierarchy matches the figure plan.

The scripted validator catches repeatable failures. Visual review catches human readability problems that metrics may miss.