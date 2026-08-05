# Lancet Style

Use this style when the user asks for `lancet`, The Lancet, 柳叶刀, Lancet-family clinical presentation, clinical trial/profile figures, editable journal artwork, or a clinical epidemiology figure with high legibility and table-plus-estimate discipline.

## Visual Rules

- Use a white background, strong black or near-black axes, visible ticks, readable labels, and minimal decoration.
- Prefer solid contrasting coloured lines. Avoid multiple dotted or dashed line styles; use dashed lines only for a reference line or a clearly meaningful comparator.
- Default forest plots, trial profiles, study profiles, and CONSORT-like diagrams to black-and-white unless colour carries explicit scientific meaning.
- Use uppercase bold panel labels `A`, `B`, `C`, placed consistently outside the plotting region when possible.
- Keep serial panels consistent in scale and tick marks when they compare the same measure.
- Use top or in-panel legends for line, scatter, and bar figures. Bottom legends are acceptable for very wide stacked bars.
- Use direct numeric labels, hazard-ratio text blocks, confidence-interval text, and number-at-risk tables when they reduce lookup burden.
- Use pastel fills with dark outlines for bars, boxes, and areas. Use stronger clinical colours for lines and points.
- Prefer 2D graphics. Do not use 3D graphs for ordinary statistical data.
- Axis titles should be bold relative to tick labels.
- Use midline decimal points in Lancet numeric text, including axis labels, direct labels, CI text, P values, and table-like figure text. Use `rmg_format_number()`, `rmg_format_ci()`, `rmg_format_p()`, and `rmg_label_number("lancet")` instead of raw `sprintf()` or `scales::label_number()` for visible numbers.
- Use a clean sans-serif font for figure-internal labels, axes, legends, forest-plot columns, and table-like annotations. The style does not force a specific font; the system default is used unless the user explicitly requests another font.
- Treat the official 10 pt Times New Roman guidance as manuscript submission guidance for main figure headings, legends, and supplementary material, not as the default for all text inside generated figure artwork.

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
# ggsci::pal_lancet("lanonc")(9)
lancet_base <- c(
  "#00468B", "#ED0000", "#42B540", "#0099B4", "#925E9F",
  "#FDAF91", "#AD002A", "#ADB6B6", "#1B1919"
)

lancet <- list(
  categorical = lancet_base,

  categorical_2 = lancet_base[c(1, 2)],
  categorical_3 = lancet_base[c(1, 2, 3)],
  categorical_4 = lancet_base[c(1, 2, 3, 4)],
  categorical_5_8 = lancet_base[1:8],
  categorical_extended = lancet_base,

  # StatsVisual derived from Lancet ggsci colors
  sequential_blue = derive_sequential(lancet_base[1]),
  sequential_red  = derive_sequential(lancet_base[2]),
  sequential_teal = derive_sequential(lancet_base[4]),

  diverging_blue_red = derive_diverging(
    low  = lancet_base[1],
    high = lancet_base[2]
  ),

  diverging_green_purple = derive_diverging(
    low  = lancet_base[3],
    high = lancet_base[5]
  ),

  accent = c(
    primary   = lancet_base[1],
    secondary = lancet_base[2]
  ),

  neutral = neutral,
  alpha = alpha_roles
)
```

Direct `ggsci` scales:

```r
p + ggsci::scale_color_lancet("lanonc")
p + ggsci::scale_fill_lancet("lanonc")
```



## R Implementation

- Source `assets/styles/theme_registry.R` through `assets/theme_medical_graphics.R`.
- Use `rmg_theme("lancet", base_size = 11)` for ordinary manuscript panels. The theme is identical to `general`; only the palette differs.
- Use `rmg_palette(n, "lancet")` for discrete groups.
- Use `rmg_font_family("lancet")` for annotation layers such as `geom_text()`, `geom_label()`, and `ggrepel`; it returns the system default font. Use `rmg_font_family("lancet", role = "submission")` only for manuscript heading/legend or supplementary text requirements. For Chinese/CJK labels, pass an explicit CJK-capable font instead.
- For dense forest plots and table-like panels, finished in-figure text around 7-8 pt is acceptable when readability QA passes; keep bold headers compact and numeric text regular.
- Prefer `svglite` for SVG, `cairo_pdf` for PDF, and `ragg` for TIFF/PNG.
- Keep SVG/PDF text editable wherever feasible. Do not deliberately outline or rasterize text.
- Use final journal dimensions before export instead of scaling after export.