# NEJM Style

Use this style when the user asks for `nejm`, NEJM, New England Journal of Medicine, 新英格兰医学杂志, clinical-trial survival figures, oncology time-to-event figures, or table-like subgroup forest plots matching the local NEJM examples.

## Visual Rules

- Use a white background, strong black or near-black axes, visible ticks, and no decorative grid.
- Use larger, highly readable clinical typography than compact Nature-style panels. Axis titles and panel headings are usually bold.
- Prefer uppercase bold panel labels such as `A`, `B`, and `C`, usually paired with a short bold panel title.
- Prefer direct labels near curve endpoints for two-arm trial curves. Use detached legends only when direct labels would collide or when more than two groups are shown.
- Use in-panel statistical summaries for key clinical results, such as hazard ratio, confidence interval, and P value.
- Keep colour semantic and restrained. Blue is the usual primary or active-treatment colour; orange, green, red, gray, and black are supporting colours.
- Use black-and-white line types for older or monochrome-style references only when colour is not needed for interpretation.
- Axis titles should be bold relative to tick labels.
- Use a clean sans-serif font for figure-internal labels, axes, legends, risk tables, forest-plot columns, and annotations. The style does not force a specific font; the system default is used unless the user specifies otherwise.
- Use ordinary decimal points. Do not use Lancet-style midline decimal points.
- Use en dashes in confidence-interval ranges.
- Format P values compactly, for example `P<0.001` or `P=0.005`, and avoid excess trailing zeros.
- Keep risk-table and forest-table text readable at final size; dense table-like panels may be smaller than axis text when readability QA passes.

## Palette

> The categorical palettes below use the exact colors defined by `ggsci`.  

```r
library(ggsci)
library(scales)

# Shared neutral roles
neutral <- c(
  text       = "#1A1A1A",
  axis       = "#222222",
  border     = "#555555",
  reference  = "#7F7F7F",
  background = "#FFFFFF",
  muted      = "#B3B3B3",
  missing    = "#D9D9D9"
)

# Shared transparency roles
alpha_roles <- c(
  raw_points      = 0.55,
  confidence_band = 0.20,
  background      = 0.28,
  highlight       = 1.00
)

# Derive ordered palettes from one ggsci anchor color
derive_sequential <- function(high, n = 5, low = "#FFFFFF") {
  grDevices::colorRampPalette(c(low, high))(n)
}

# Derive a midpoint-centered palette from two ggsci anchor colors
derive_diverging <- function(low, high, n = 5, mid = "#F7F7F7") {
  grDevices::colorRampPalette(c(low, mid, high))(n)
}
```

```r
# Exact ggsci palette:
# ggsci::pal_nejm("default")(8)
nejm_base <- c(
  "#BC3C29", "#0072B5", "#E18727", "#20854E",
  "#7876B1", "#6F99AD", "#FFDC91", "#EE4C97"
)

nejm <- list(
  categorical = nejm_base,

  categorical_2 = nejm_base[c(1, 2)],
  categorical_3 = nejm_base[c(1, 2, 3)],
  categorical_4 = nejm_base[c(1, 2, 3, 4)],
  categorical_5_8 = nejm_base,
  categorical_extended = nejm_base,

  # StatsVisual derived from NEJM ggsci colors
  sequential_red    = derive_sequential(nejm_base[1]),
  sequential_blue   = derive_sequential(nejm_base[2]),
  sequential_green  = derive_sequential(nejm_base[4]),

  diverging_blue_red = derive_diverging(
    low  = nejm_base[2],
    high = nejm_base[1]
  ),

  diverging_green_purple = derive_diverging(
    low  = nejm_base[4],
    high = nejm_base[5]
  ),

  accent = c(
    primary   = nejm_base[1],
    secondary = nejm_base[2]
  ),

  neutral = neutral,
  alpha = alpha_roles
)
```

Direct `ggsci` scales:

```r
p + ggsci::scale_color_nejm()
p + ggsci::scale_fill_nejm()
```



## R Implementation

- Source `assets/styles/theme_registry.R` through `assets/theme_medical_graphics.R`.
- Use `rmg_theme("nejm", base_size = 11)` for ordinary NEJM-style panels. The theme is identical to `general`; only the palette differs.
- Use `rmg_palette(n, "nejm")` for discrete groups.
- Use `rmg_font_family("nejm")` for annotation layers such as `geom_text()`, `geom_label()`, and `ggrepel`; it returns the system default font. For Chinese/CJK labels, pass an explicit CJK-capable font.
- Use `rmg_format_ci()` and `rmg_format_p()` for visible CI and P-value text.
- Prefer `svglite` for SVG, `cairo_pdf` for PDF, and `ragg` for TIFF/PNG.
- Keep SVG/PDF text editable wherever feasible.
- No official local NEJM guideline files are currently available. Do not invent official font, file-format, dimension, or DPI requirements for NEJM. Continue to follow the skill's general export requirements: editable PDF/SVG, high-resolution TIFF, web image under 1 MB, and final dimensions chosen before export. If official NEJM guidance is provided later, revise this section to separate official submission constraints from example-derived production style.