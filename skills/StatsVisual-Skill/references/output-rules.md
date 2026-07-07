# Output Rules

## Folder Rules

Default output locations inside the project:

- Figures: `skills/r-medical-graphics/output/figures/` or project-local`output/figures/`
- Scripts: `skills/r-medical-graphics/output/script/` or project-local `output/script/`

When generating a user-specific figure, prefer project-local `output/figures/` and `output/script/` unless the user asks to write inside the skill folder.

## File Naming

Use descriptive, stable names:

```text
fig01_km_overall_survival
fig02_grouped_biomarker_boxplot
fig03_adjusted_cox_forest
```

Avoid spaces, Chinese punctuation, and version suffix clutter in generated output filenames.

## Standard Export

Use:

```r
save_medical_figure(
  plot = p,
  filename = "fig01_grouped_bar",
  output_dir = "output/figures",
  width = 6,
  height = 4.2
)
```

This writes PNG, TIFF, SVG, and PDF when dependencies are available.

## PNG

Use `ggsave()` for PNG previews:
example code:
```r
ggplot2::ggsave(
  filename = file.path(output_dir, "figure.png"),
  plot = p,
  width = 6,
  height = 4.2,
  units = "in",
  dpi = 160,
  bg = "white"
)
```

## TIFF

Use `ggsave()` for TIFF submission files:
example code:
```r
ggplot2::ggsave(
  filename = file.path(output_dir, "figure.tiff"),
  plot = p,
  width = 6,
  height = 4.2,
  units = "in",
  dpi = 700,
  bg = "white",
)
```

## PDF And Chinese Fonts

For English-only figures, use `cairo_pdf` through `ggsave()`:
example code:
```r
ggplot2::ggsave(
  filename = file.path(output_dir, "figure.pdf"),
  plot = p,
  width = 6,
  height = 4.2,
  units = "in",
  device = grDevices::cairo_pdf,
  bg = "white"
)
```

For Chinese labels, use a CJK-safe device. The helper supports:

```r
save_medical_figure(p, "figure", cjk_pdf = TRUE, cjk_font = "SimSun")
```

On macOS, use `PingFang SC` or another installed CJK font.

## Specialized Objects

Some objects are not ordinary ggplot objects:

- `ComplexHeatmap`: open a graphics device, call `draw(ht)`, close the device.
- `ggsurvplot`: save `object$plot` and `object$table` separately or combine them with `cowplot`.
- Base graphics diagnostics: draw inside `pdf()`, `png()`, or `tiff()` devices.

## QA Checklist

- Script runs from a clean R session.
- Source data path is relative or clearly documented.
- Output files exist and are non-empty.
- PNG/TIFF have white background unless image content requires otherwise.
- Text is readable at final size.
- No labels overlap after export.
- Color encodings match legends and remain interpretable in grayscale.
- Statistical annotations match the model/test actually used.

