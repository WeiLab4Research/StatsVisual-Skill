# BMJ Style

Use this style when the user asks for `bmj`, BMJ, The BMJ, British Medical Journal, pragmatic clinical research, public-health figures, health-services research figures, or a reader-friendly medical journal style.

## Visual Rules

- Use a white background, clear axes, visible ticks, and minimal grid lines.
- Prefer plain, reader-friendly evidence displays over dense editorial styling.
- Keep titles and subtitles concise. The figure itself should communicate the result without becoming a poster.
- Use uppercase bold panel labels `A`, `B`, `C` for multi-panel manuscript figures.
- Use direct labels when they reduce legend lookup, especially for two or three time-series or survival groups.
- Prefer readable labels, explicit denominators, and plain-language annotation over visual compression.
- Use restrained colours and enough contrast for accessibility. Avoid red/green-only encodings and decorative colour ramps.
- Avoid boxed panel backgrounds, shadows, 3D graphics, and heavy table grids.
- Axis titles should be bold relative to tick labels.

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
# ggsci::pal_bmj("default")(9)
bmj_base <- c(
  "#2A6EBB", "#F0AB00", "#C50084", "#7D5CC6", "#E37222",
  "#69BE28", "#00B2A9", "#CD202C", "#747678"
)

bmj <- list(
  categorical = bmj_base,

  categorical_2 = bmj_base[c(1, 8)],
  categorical_3 = bmj_base[c(1, 8, 6)],
  categorical_4 = bmj_base[c(1, 8, 6, 4)],
  categorical_5_8 = bmj_base[1:8],
  categorical_extended = bmj_base,

  # StatsVisual derived from BMJ ggsci colors
  sequential_blue   = derive_sequential(bmj_base[1]),
  sequential_orange = derive_sequential(bmj_base[5]),
  sequential_teal   = derive_sequential(bmj_base[7]),

  diverging_blue_red = derive_diverging(
    low  = bmj_base[1],
    high = bmj_base[8]
  ),

  diverging_green_purple = derive_diverging(
    low  = bmj_base[6],
    high = bmj_base[4]
  ),

  accent = c(
    primary   = bmj_base[1],
    secondary = bmj_base[8]
  ),

  neutral = neutral,
  alpha = alpha_roles
)
```

Direct `ggsci` scales:

```r
p + ggsci::scale_color_bmj()
p + ggsci::scale_fill_bmj()
```



## R Implementation

- Source `assets/styles/theme_registry.R` through `assets/theme_medical_graphics.R`.
- Use `rmg_theme("bmj", base_size = 11)` for ordinary BMJ-style manuscript panels. The theme is identical to `general`; only the palette differs.
- Use `rmg_palette(n, "bmj")` for discrete groups.
- Use `rmg_font_family("bmj")` for annotation layers such as `geom_text()`, `geom_label()`, and `ggrepel`; it returns the system default font. For Chinese/CJK labels, pass an explicit CJK-capable font.
- Use `rmg_format_ci()` and `rmg_format_p()` for visible CI and P-value text.
- Prefer `svglite` for SVG, `cairo_pdf` for PDF, and `ragg` for TIFF/PNG.
- Keep SVG/PDF text editable wherever feasible.