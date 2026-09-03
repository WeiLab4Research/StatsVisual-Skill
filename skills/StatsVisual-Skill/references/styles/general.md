# General Style

Use this as the default `general` style for medical and statistical graphics. This style is derived from the plotting principles summarized from Peking University Professor Yongyue Wei's edited book *The Art of Statistical Graphics* (`统计图形艺术`). Keep chart choice, statistical honesty, and readability ahead of decoration.

## Axes And Axis Titles

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

