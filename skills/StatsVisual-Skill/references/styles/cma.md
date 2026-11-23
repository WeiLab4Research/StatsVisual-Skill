# Chinese Medical Association Journals Style

Use `cma` when the user requests the **Chinese Medical Association journal series**. This is a reusable cross-journal style. It is not a claim that the series has one official palette or that every member journal has identical artwork requirements.

## Evidence and Scope

- The [series-wide submission rules](https://www.cmaph.org/zjfc/890388.jhtml) provide the common publication framework. Check the named member journal's current instructions before submission.
- The [instructions for authors of Zhonghua Yi Xue Za Zhi](https://cs.medjournals.cn/cn/zhyxzz/authors/for-authors) require a chart type suited to the data, mathematically sound axis ticks, good clarity and contrast, and legible symbols and arrows. Its 7.5 cm half-column and 17.0 cm full-column limits are specific to that journal; do not apply them to the whole series.
- The colors, SimSun font, type sizes, and line widths below are **StatsVisual defaults**, not official series-wide mandates.

## Visual Rules

- Use a white background, dark text, visible left and bottom axes, and a clean two-dimensional statistical display. Avoid decorative borders, shadows, gradients, and 3D effects.
- Keep axis titles and units explicit. Use mathematically valid breaks and a zero baseline when bar length encodes magnitude. Keep the same group mapping across panels.
- Use regular-weight axis labels by default. Use bold only for a meaningful hierarchy such as a compact panel letter or table header. Place figure captions and methodological notes outside the plot body.
- At final output size, start with axis titles around 9-10 pt and ticks or legends around 8-9 pt. Rework dense layouts rather than shrinking text until it becomes unreadable.
- Use light major grid lines only when they help readers compare values. Keep error bars, confidence bands, labels, and legends visible without overlap or clipping.
- Do not depend on color alone: add line types, point shapes, or direct labels when grayscale reproduction or multiple groups make the colors hard to distinguish.

## Palette

This is a suggested StatsVisual palette, **not an official Chinese Medical Association palette**. For two groups, use deep blue and rust orange. Use the remaining colors in order as needed; prefer dark blue or dark gray for a single group.

| Role | Hex | Suggested use |
| --- | --- | --- |
| Background | `#FFFFFF` | Canvas and panel |
| Text and axes | `#222222` | Labels, axes, reference lines |
| Secondary text | `#555555` | Secondary annotations |
| Light guide | `#D9DDE1` | Major grid lines when needed |
| Deep blue | `#155A80` | First group, primary estimate |
| Rust orange | `#B65B35` | Second or comparison group |
| Teal | `#287A72` | Third group |
| Muted purple | `#725E85` | Fourth group |
| Ochre | `#9B762A` | Fifth group |

Use the same hue for a curve and its confidence band, with a low-opacity band that does not hide the curve. Do not use this categorical palette as a continuous gradient. Use a sequential lightness scale for ordered values, or a diverging scale only when a meaningful center exists.

```r
cma_base <- c("#155A80", "#B65B35", "#287A72", "#725E85", "#9B762A")
cma <- list(
  categorical = cma_base,
  categorical_2 = cma_base[1:2],
  categorical_3 = cma_base[1:3],
  categorical_4 = cma_base[1:4],
  categorical_5 = cma_base,
  neutral = c(text = "#222222", secondary = "#555555",
              guide = "#D9DDE1", background = "#FFFFFF")
)
```

## R Implementation

- Source `assets/styles/theme_registry.R` through `assets/theme_medical_graphics.R`.
- Use `rmg_theme("cma")` for the suggested white, compact theme and `rmg_palette(n, "cma")` for categorical groups. The default font for figure text and annotations is **SimSun**: use `rmg_font_family("cma")` when adding `geom_text()`, `geom_label()`, or `ggrepel` layers.
- Keep group colors stable with a named manual scale, for example `ggplot2::scale_colour_manual(values = stats::setNames(rmg_palette(2, "cma"), c("Intervention", "Control")))`.
- This style uses the registry's standard line and bar geometry defaults. Adjust them to the final figure size, data density, and chart family.
- Use `rmg_format_ci()` and `rmg_format_p()` for visible statistical text, then check the named journal's requirements for precision, symbols, and notation. Do not assume that one journal's numerical rules apply to the entire series.
- Export at the named journal's target width. Prefer `svglite` for editable SVG, `cairo_pdf` for PDF, and `ragg` for TIFF/PNG when available. Verify that SimSun is installed in the rendering environment and that the output has not substituted or outlined text unexpectedly.

## Quality and Submission Checks

- Apply the target journal's current limits on dimensions and file format; the 7.5 cm and 17.0 cm limits above are an example from one member journal.
- Inspect the exported figure at final print size. Check labels, units, ticks, confidence intervals, legend placement, clipping, contrast, and grayscale readability.
- Keep the editable source script and vector master. Do not present the suggested palette or theme as official publisher artwork rules.
