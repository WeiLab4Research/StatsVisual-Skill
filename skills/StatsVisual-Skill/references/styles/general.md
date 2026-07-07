# General Style

Use this as the default `general` style for medical and statistical graphics. This style is derived from the plotting principles summarized from Peking University Professor Yongyue Wei's edited book *The Art of Statistical Graphics* (`统计图形艺术`). Keep chart choice, statistical honesty, and readability ahead of decoration.

## Core Principles

- Make the figure simple, not simplistic: every line, color, annotation, and panel must carry information.
- Prefer position on a common scale over angle, area, volume, or 3D perspective.
- Use whitespace to group information and reduce clutter.
- Use direct labels when they reduce legend lookup.
- Keep axes, units, sample sizes, error definitions, and statistical annotations explicit.
- Use consistent visual encoding across panels: the same group must keep the same color, line type, symbol, and label.

## Axes And Axis Titles

- Use clear axis titles with units: `Time since randomization (months)`, `Body mass index (kg/m^2)`.
- Use sensible breaks. For months, prefer `0, 6, 12, 18` or similar natural intervals.
- Do not truncate bar chart baselines unless the chart is not encoding magnitude by bar length and the break is explicit.
- For line, scatter, and regression plots, choose limits that show the data honestly without excessive empty space.
- Remove top and right spines for routine publication charts.
- Do not use legend background boxes.
- Use light grid lines only when they help read values; keep them pale and sparse.

Default theme function:

```r
theme_egraphics <- function(base_family = "Arial") {
  ggpubr::theme_pubr(base_family = base_family) +
    ggplot2::theme(
      axis.title.y = ggplot2::element_text(
        margin = ggplot2::margin(t = 0, r = 10, b = 0, l = 0)
      ),
      axis.title.x = ggplot2::element_text(
        margin = ggplot2::margin(t = 10, r = 0, b = 0, l = 0)
      ),
      axis.title = ggplot2::element_text(size = 13, face = "bold"),
      axis.line = ggplot2::element_line(linewidth = 0.6, color = "black"),
      axis.ticks = ggplot2::element_line(linewidth = 0.3),
      axis.ticks.length = grid::unit(0.15, "cm"),
      axis.text = ggplot2::element_text(size = 10),
      legend.background = ggplot2::element_blank(),
      legend.box.background = ggplot2::element_blank(),
      legend.key = ggplot2::element_blank(),
      plot.margin = ggplot2::margin(0.5, 0.5, 0.5, 0.5, "cm")
    )
}

theme_set(theme_egraphics())
```

If `ggpubr` is unavailable, use `theme_medical_graphics()` from `scripts/r_medical_graphics_helpers.R`; it follows the same axis, legend, and margin behavior with a `theme_classic()` fallback.

## Top-Journal Color Palettes

When no target journal is specified, use the default palette:

```r
PALETTE <- c(
  blue_main      = "#0F4D92",
  blue_secondary = "#3775BA",
  green_1 = "#DDF3DE",
  green_2 = "#AADCA9",
  green_3 = "#8BCF8B",
  red_1 = "#F6CFCB",
  red_2 = "#E9A6A1",
  red_strong = "#B64342",
  neutral_light = "#CFCECE",
  neutral_mid = "#767676",
  neutral_dark = "#4D4D4D",
  neutral_black = "#272727",
  gold = "#FFD700",
  teal = "#42949E",
  violet = "#9A4D8E",
  magenta = "#EA84DD"
)
```

For a unified low-saturation method-family palette, use:

```r
PALETTE_NMI_PASTEL <- c(
  baseline_dark = "#484878",
  baseline_mid = "#7884B4",
  baseline_soft = "#B4C0E4",
  ours_tiny = "#E4E4F0",
  ours_base = "#E4CCD8",
  ours_large = "#F0C0CC"
)
```

Default discrete color order:

```r
DEFAULT_COLOR_ORDER <- c(
  "#0F4D92",
  "#8BCF8B",
  "#B64342",
  "#42949E",
  "#9A4D8E",
  "#CFCECE"
)
```

Use color roles:

- Blue: primary method, main group, or central estimate.
- Green: improvement, favorable direction, or secondary positive signal.
- Red: risk, harm, decrease, or warning. Define direction clearly.
- Gray: baseline, reference, controls, or background context.
- Gold, teal, violet, and magenta: limited accents or callouts.

When a target journal is specified, prefer `ggsci` journal palettes:

```r
ggsci::scale_color_nejm()
ggsci::scale_fill_nejm()
ggsci::scale_color_jama()
ggsci::scale_fill_jama()
ggsci::scale_color_bmj()
ggsci::scale_fill_bmj()
ggsci::scale_color_npg()
ggsci::scale_fill_npg()
```

Keep palette choice secondary to data clarity. Avoid rainbow palettes and avoid red/green as the only distinction.

## Export Rules

Use white background for statistical plots. Increase width and height for multi-panel figures so labels, legends, and panels do not crowd.

PNG preview export must use `ggsave()`:

```r
ggplot2::ggsave(
  filename = file.path(output_dir, "figure_basic_bar_web.png"),
  plot = p,
  width = 6,
  height = 4.2,
  units = "in",
  dpi = 160,
  bg = "white"
)
```

TIFF submission export must use `ggsave()` and at least 600 dpi; use 700 dpi as a conservative default when feasible:

```r
ggplot2::ggsave(
  filename = file.path(output_dir, "figure_basic_bar_web.tiff"),
  plot = p,
  width = 6,
  height = 4.2,
  units = "in",
  dpi = 600,
  bg = "white"
)
```

For English-only or non-CJK PDF labels, use `ggsave()` with a PDF device:

```r
ggplot2::ggsave(
  filename = file.path(output_dir, "figure_basic_bar_web.pdf"),
  plot = p,
  width = 6,
  height = 4.2,
  units = "in",
  device = grDevices::cairo_pdf,
  bg = "white"
)
```

## Chinese PDF Font Handling

R's default `pdf()` device often cannot render Chinese labels reliably. For Chinese PDF export, use `export::graph2pdf()` with an explicit CJK font.

Windows:

```r
library(export)
library(ggplot2)

export::graph2pdf(
  p,
  file = "file_name.pdf",
  font = "SimSun"
)
```

macOS:

```r
library(export)
library(ggplot2)

export::graph2pdf(
  p,
  file = "file_name.pdf",
  font = "PingFang SC"
)
```

## Labels And Annotations

- Use concise labels; avoid repeating units in every tick label when an axis title can carry the unit.
- Align labels with their marks where possible.
- Use `ggrepel` for crowded point labels.
- Use arrows sparingly. A label connector line usually does not need an arrowhead.
- In biomedical diagrams, avoid arrow styles with specialized molecular meanings unless intended.

## Legends

- Remove legend title only when labels are self-explanatory.
- Collect shared legends in multi-panel figures.
- Avoid repeated legends in every facet or panel.
- Avoid legend background boxes.

## Statistical Display

Always define:

- `n` and what it counts.
- Center statistic: mean, median, rate, proportion, model estimate.
- Spread/interval: SD, SEM, IQR, 95% CI, prediction interval.
- Test/model: exact test, rank test, t-test, ANOVA, regression model, Cox model, etc.
- Adjustment: covariates and multiple-comparison correction when applicable.

## Forest Plot Rules

Reference image: `references/styles/examples/general-forest-plot.png`. Use it only as a visual reference; do not copy its data, labels, or exact column order blindly.

- Use a forest plot only when each row has an effect estimate and uncertainty interval, or when these can be computed from a declared model. Do not force a forest plot from raw groups, counts, or percentages without an effect estimate.
- Build an integrated table-and-forest display: descriptor columns on the left, the estimate axis near the middle, and numeric estimate/statistical columns on the right.
- Choose columns from the analysis, such as subgroup/level labels, treatment and comparator counts, study weights, HR/OR/RR/risk difference/mean difference/SMD with CI, P value, or P for interaction. Do not add unused columns just to mimic a reference image.
- Label the effect measure explicitly. Use `HR`, `OR`, `RR`, `risk difference`, `mean difference`, `SMD`, or another correct label instead of hard-coding HR.
- Include `P for interaction` only for subgroup interaction analyses; ordinary rows may need no P-value column.
- Use light row bands or subtle group shading only when they improve row tracking in dense tables.
- Keep the null-effect line, CI marks, axis ticks, favour labels, and CI text aligned to the same row coordinate system.
- Reject forest plots with missing CI definitions, unclear reference group, unreadable table text, or disconnected table and forest panels that only appear aligned by eye.

## Journal Defaults

- Use vector PDF/SVG for line art and editable text.
- Use TIFF for submission raster, at least 600 dpi; 700 dpi is a conservative default.
- Keep final text readable at target size.
- Use white background for statistical plots.
- Use black backgrounds only for image plates that require it, not for routine charts.
