# Style Router

Use this router during the first data-handling turn and before writing any plotting code.

## First Recommendation Requirement

The first user-facing recommendation must ask for two choices:

- chart option: recommended single figure, alternative single figure, or optional multi-panel figure;
- style option: `general`, `nature`, `lancet`, or `nejm`.

If the user selects a chart but omits the style, continue with `general` and state that the default style is being used.

## Style Options Copy

Use this wording in the recommendation response:

```text
Style options:
- 通用风格 general（默认）：来源于《统计图形艺术》的医学统计绘图规则。
- Nature 风格 nature：适合 Nature-family / 高影响力期刊图，强调证据层级、低饱和统一色系、可编辑 SVG 和紧凑多面板布局。
- Lancet 风格 lancet：适合 The Lancet / 临床流行病学图，强调强可读性、可编辑矢量图、实线对比编码、临床表格与效应量对齐。
- NEJM 风格 nejm：适合 NEJM 临床试验/肿瘤/生存曲线与表格式森林图，强调白底、粗黑坐标轴、直接标注、风险表和浅灰表格行带。

请选择：图表方案 + 风格。
如果只选择图表，我将默认使用通用风格。
```

## Loading Rules

- Load `styles/general.md` for `general`.
- Load `styles/nature.md` for `nature`.
- Load `styles/lancet.md` for `lancet`.
- Load `styles/nejm.md` for `nejm`.
- Load `design-rules.md` when the selected style is unclear or when adding a new style.
- In generated R scripts, pass the chosen style to `rmg_theme(style)` and `rmg_palette(n, style)`.
