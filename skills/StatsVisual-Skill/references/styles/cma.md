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

## Supplemental Figure-Design Checklist

The following checklist translates the user-provided reference table. It describes **recommended design conventions**, not official requirements shared by every Chinese Medical Association journal. The named target journal's current author instructions take precedence.

| Design item | Recommended practice |
| --- | --- |
| Language | Prefer concise, standardized Chinese medical terminology for axis titles, group names, legends, and annotations in a Chinese-language article. Internationally recognized medical abbreviations, statistical symbols, gene and protein names, and measurement units may remain in English. Avoid unnecessary switching between Chinese and English. |
| Font and type size | Use SimSun for Chinese text. Times New Roman may be used for English text and numerals when the target journal and export workflow support it; the reusable `cma` theme continues to default to SimSun for all text. Keep the size of like elements consistent, use a clear type hierarchy, and treat approximately 8-11 pt at final size as a starting range rather than a fixed rule. Check mixed-font labels after export. |
| Axes and labels | Use readable, appropriately spaced ticks and labels. Keep decimal precision consistent for the same measure, distinguish proportions from percentages, and choose axis limits that represent the data faithfully without hiding relevant values. |
| Color | Use a single-color family for simple one-series figures when appropriate and clearly contrasting colors for multiple groups. Use a sequential gradient for continuous values and discrete colors for categories. Avoid meaningless gradients, excessive saturation, and too many colors. |
| Background and borders | Prefer a white background without decorative borders, shadows, textures, or 3D effects. Ordinary Cartesian charts may keep only the left and bottom axes. Heatmaps, contour plots, and radar charts may retain a complete frame or guides when needed to interpret the data. |
| Legend | Explain every meaningful color, point shape, line type, and fill. Place the legend in available whitespace or adjacent to the figure as permitted by the target journal; never cover data marks or labels. |
| Statistical notation and units | Use standard statistical symbols, with symbols such as *P*, *t*, *F*, *r*, and *n* in italics when required by the target journal. Keep abbreviations such as HR, OR, RR, and CI consistent. Use legal SI-compatible unit names and symbols, for example kg, mmol/L, µg/L, and kg/m²; avoid inconsistent mixtures of Chinese unit names and international symbols. |
| Aspect ratio and overall layout | Ratios such as 3:2, 4:3, 5:7, and 16:9 are possible starting points, not universal targets. Adjust to the data: Kaplan-Meier plots may need more vertical space, while longitudinal time-series plots may need more width. Control whitespace, element spacing, and the share of the canvas used by data; prevent overlap, clipping, and crowding. |
| Multipanel figures | Order panels by the study's logic and label them consistently as A, B, C, D, and so on. Coordinate fonts, line widths, colors, symbols, and backgrounds. Use consistent axes for the same variable when comparison is intended; combine shared legends and avoid repeated labels where possible. |

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
