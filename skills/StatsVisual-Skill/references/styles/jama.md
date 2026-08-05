# JAMA Style

Use this style when the user asks for `jama`, JAMA, JAMA Network, Journal of the American Medical Association, clinical research figures, rigorous statistical display, or a restrained editorial medical-journal style.

## Visual Rules

- Use a white background, strong black or near-black axes, visible ticks, and no decorative grid.
- Keep figures quiet and statistical. Avoid large display titles inside the plot unless the user needs a self-contained conference figure.
- Use uppercase bold panel labels `A`, `B`, `C`, placed consistently outside or at the upper-left edge of each panel.
- Prefer clear axis titles with units, denominators, exact interval definitions, and model definitions.
- Use restrained colour. Colour should separate clinically meaningful groups, highlight primary estimates, or support accessibility; do not use colour as decoration.
- Use top or right legends for grouped charts; prefer direct labels when there are only two or three groups and labels do not collide.
- Keep table-like panels aligned by row. Use whitespace and one header rule rather than boxed grid tables.
- Prefer 2D statistical graphics. Do not use 3D bars, shadows, glossy effects, or infographic decoration for manuscript figures.
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
# ggsci::pal_jama("default")(7)
jama_base <- c(
  "#374E55", "#DF8F44", "#00A1D5", "#B24745",
  "#79AF97", "#6A6599", "#80796B"
)

jama <- list(
  categorical = jama_base,

  categorical_2 = jama_base[c(1, 2)],
  categorical_3 = jama_base[c(1, 2, 3)],
  categorical_4 = jama_base[c(1, 2, 3, 4)],
  categorical_5_8 = jama_base,
  categorical_extended = jama_base,

  # StatsVisual derived from JAMA ggsci colors
  sequential_blue   = derive_sequential(jama_base[3]),
  sequential_orange = derive_sequential(jama_base[2]),
  sequential_green  = derive_sequential(jama_base[5]),

  diverging_blue_red = derive_diverging(
    low  = jama_base[3],
    high = jama_base[4]
  ),

  diverging_green_purple = derive_diverging(
    low  = jama_base[5],
    high = jama_base[6]
  ),

  accent = c(
    primary   = jama_base[1],
    secondary = jama_base[2]
  ),

  neutral = neutral,
  alpha = alpha_roles
)
```

Direct `ggsci` scales:

```r
p + ggsci::scale_color_jama()
p + ggsci::scale_fill_jama()
```



## R Implementation

- Source `assets/styles/theme_registry.R` through `assets/theme_medical_graphics.R`.
- Use `rmg_theme("jama", base_size = 11)` for ordinary JAMA-style manuscript panels. The theme is identical to `general`; only the palette differs.
- Use `rmg_palette(n, "jama")` for discrete groups.
- Use `rmg_font_family("jama")` for annotation layers such as `geom_text()`, `geom_label()`, and `ggrepel`; it returns the system default font. For Chinese/CJK labels, pass an explicit CJK-capable font.
- Use `rmg_format_ci()` and `rmg_format_p()` for visible CI and P-value text.
- Prefer `svglite` for SVG, `cairo_pdf` for PDF, and `ragg` for TIFF/PNG.
- Keep SVG/PDF text editable wherever feasible.