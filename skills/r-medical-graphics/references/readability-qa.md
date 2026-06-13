# Figure Readability QA

Use this reference before final delivery and whenever a plot looks technically valid but may be hard to read at final size.

## Scale And Panel Policy

- Shared axes are appropriate only when panels compare the same measure on the same absolute scale.
- Do not force shared axes when the result makes one subgroup visually collapse. Consider `facet_wrap(scales = "free_y")`, log transformation, an inset, separate figures, or direct numeric labels.
- If a panel's data span uses less than 20% of its axis span, treat it as `WARN`.
- If a panel's data span uses less than 10% of its axis span, treat it as `FAIL` unless the compressed scale is scientifically intentional and explicitly explained.
- When panel data spans differ by more than 10-fold under a shared axis, reassess whether the axis should be shared.

## Mandatory Checks

- Axis titles include units, transformations, denominators, or time scales where relevant.
- Text remains readable at the final export size, not only in a zoomed preview.
- Labels, legends, and statistical annotations do not cover the main data.
- Legends are concise; direct labels are preferred when a legend becomes long or hard to scan.
- Colors remain distinguishable when printed small or viewed in grayscale.
- Multi-panel figures keep panel labels, shared encodings, and legends consistent.
- Every statistical panel states or implies sample size, interval definition, and model/test source.
- SVG/PDF text should remain editable when feasible.

## Required QA Loop

Run both validators before delivery:

```text
Rscript scripts/validate_r_plot.R <project_dir>/figures
Rscript scripts/validate_figure_readability.R <plot_rds> <project_dir>/figures <figure_name> <width_in> <height_in> <project_dir>
```

If readability validation reports `FAIL`, revise the plot code and export again. Do not deliver a failed figure as publication-ready output.

If warnings remain after a reasonable revision, mention them in the final reply and in `output/figure_qa.md`.

## Visual Review

When image viewing is available, inspect the final web PNG or TIFF preview directly. Check whether:

- the plotted data are large enough to read;
- the smallest panel is not visually dominated by empty space;
- labels, legends, and annotations do not overlap;
- grouped or faceted subplots are not misleading because of shared scales;
- the visual hierarchy matches the figure contract.

The scripted validator catches repeatable failures. Visual review catches human readability problems that metrics may miss.
