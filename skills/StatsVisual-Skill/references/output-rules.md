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
  dpi = 300,
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

## Figure Explanation

After figures are exported and validated, write `output/figure_explanation.md` with the following content. 该文件记录所生成图形的统计和可视化原理，用于可复现性和同行评审。

### 内容模板

```markdown
# 图形说明

## 图形标识
- 图形名称 
- 图表类型
- 风格（general / nature / lancet / nejm / jama / bmj）

## 统计摘要
- 变量角色（结局 / 预测变量 / 分组 / 分层）
- 样本量（总 N，各组 N）
- 效应估计值（HR / OR / beta / MD + 95% CI）
- P 值或显著性阈值
- 使用的模型或检验（Cox / log-rank / 线性回归 / 等）

## 视觉编码
- 各轴代表的含义（如单位、是否做了变换）
- 颜色 / 形状 / 线型编码的内容
- 图例解读

## 解读说明
- 图表核心结论
- 关键比较或趋势
- 注意事项 / 局限性
```

说明内容必须写入对话回复并保存到 `output/figure_explanation.md`。