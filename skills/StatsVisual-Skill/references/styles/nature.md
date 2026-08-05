# Nature Style

Use this style when the user asks for `nature`, Nature-family presentation, high-impact journal figures, compact manuscript figures, or a restrained multi-panel figure with a clear result hierarchy.

## Visual Rules

- Make the primary result visually dominant; supporting panels should be quieter.
- Use compact typography and tight but readable spacing. Do not fill the canvas with explanatory titles.
- Prefer lowercase panel labels `a`, `b`, `c`, placed consistently and outside the plotting region when possible.
- Keep SVG text editable. Avoid rasterizing text or flattening vector marks unless the data layer is genuinely raster-like.
- Use a white background, no legend frame, no decorative shadows, no heavy grid, and no boxed plot panel unless a specific matrix/image panel needs a boundary.
- Use direct labels or one shared legend when they reduce lookup. Avoid repeating legends across panels.
- Use thin axes and ticks. Keep grid lines absent or very pale.
- Use concise axis labels with units and explicit interval/test definitions.
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
# ggsci::pal_npg("nrc")(10)
nature_base <- c(
  "#E64B35", "#4DBBD5", "#00A087", "#3C5488", "#F39B7F",
  "#8491B4", "#91D1C2", "#DC0000", "#7E6148", "#B09C85"
)

nature <- list(
  categorical = nature_base,

  categorical_2 = nature_base[c(1, 2)],
  categorical_3 = nature_base[c(1, 2, 3)],
  categorical_4 = nature_base[c(1, 2, 3, 4)],
  categorical_5_8 = nature_base[1:8],
  categorical_extended = nature_base,

  # StatsVisual derived from NPG ggsci colors
  sequential_red   = derive_sequential(nature_base[1]),
  sequential_cyan  = derive_sequential(nature_base[2]),
  sequential_green = derive_sequential(nature_base[3]),
  sequential_blue  = derive_sequential(nature_base[4]),

  diverging_blue_red = derive_diverging(
    low  = nature_base[4],
    high = nature_base[1]
  ),

  diverging_green_purple = derive_diverging(
    low  = nature_base[3],
    high = nature_base[6]
  ),

  accent = c(
    primary   = nature_base[1],
    secondary = nature_base[4]
  ),

  neutral = neutral,
  alpha = alpha_roles
)
```

Direct `ggsci` scales:

```r
p + ggsci::scale_color_npg("nrc")
p + ggsci::scale_fill_npg("nrc")
```



## R Implementation

- Source `assets/styles/theme_registry.R` through `assets/theme_medical_graphics.R`.
- Use `rmg_theme("nature", base_size = 8-10)` for compact manuscript panels.
- Use `rmg_palette(n, "nature")` for discrete groups.
- Prefer `svglite` for SVG, `cairo_pdf` for PDF, and `ragg` for TIFF/PNG.
- Use final journal dimensions before export instead of scaling after export.