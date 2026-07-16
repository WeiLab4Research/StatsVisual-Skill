# Chart Router

Use this guide for the first turn after the assistant receives or locates a dataset. Inspect data first, then map the research question and variable roles to a chart. General user wording such as "plot my data", "draw figures", "visualize it", "帮我画图", "给我的数据画图", "直接画", or "自动选择" does not authorize immediate plotting.

## First-Turn Gate

The first data-handling response must stop at data profile and recommendation. The first turn may create a project directory, copy the dataset into it, inspect the data, and write `output/data_profile.md`. It must not write plotting code, copy plotting templates, install plotting packages, build plot objects, export figures, validate figures, or choose a single/multi-panel figure on the user's behalf.

Proceed to plotting only after a follow-up user message selects a concrete chart option from the recommendation, such as the recommended single figure, a named alternative, or the optional multi-panel figure. Also ask the user to choose a style: `general` by default, `nature`, `lancet`, `nejm`, `jama`, or `bmj`. If the user selects a chart but omits style, proceed with `general` and state that default. If the original request names a specific chart type, inspect first, confirm suitability, present the recommendation, and ask for confirmation before coding.

If the original message contains both a dataset and a phrase that sounds like authorization, resolve the conflict in favor of the gate. Example: "Here is my CSV, please directly plot it" still means inspect, recommend, ask, and wait. Do not mention that you are choosing automatically; automatic selection is unavailable on the first data-handling turn.

## First Questions

- What is the target message: comparison, trend, relationship, distribution, composition, diagnosis, survival, or model fit?
- Which variables are continuous, categorical, ordered categorical, time/date, event status, or high-dimensional features?
- Is the unit of analysis individual-level, aggregated, repeated-measure, or matrix-like?
- Does the plot need to show uncertainty, sample size, statistical tests, or model predictions?

## Many-Category Circular Chart Rule

If a categorical numeric variable has `>25` categories and the main goal is to show frequency, proportion, composition, absolute contribution, burden magnitude, or overview ranking, recommend a polar plot or rose chart as the primary single figure.

If the main goal is significance-value or correlation-coefficient precision, threshold judgment, P value, CI, significance marking, or adjusted-versus-unadjusted differences, do not prioritize a polar plot or rose chart even when the category count is `>25`.

## Common Routes

| Data / intent | Prefer | Good alternatives | Notes |
| --- | --- | --- | --- |
| One continuous variable | Histogram or density plot | Boxplot, violin, QQ plot | Show distribution shape before summary-only graphics. |
| Continuous outcome by 2+ groups | Boxplot plus jitter or violin | Raincloud, dot plot with CI | Use raw points when sample size is not too large. |
| Mean/rate/proportion by groups | Bar chart with CI or count labels | Dot plot, forest-style interval plot | Avoid bars for raw continuous observations. |
| Two continuous variables | Scatter plot | Scatter with regression, density scatter, bubble plot | Add smoothing only when it supports the question. |
| Many pairwise continuous variables | Scatterplot matrix | Correlation heatmap | Use only selected variables for readability. |
| Time or ordered x variable | Line plot | Area, step, calendar, streamgraph | Use points when observations are sparse. |
| Cumulative event over time | Step plot | Survival curve | Be explicit about risk set and censoring. |
| Time-to-event outcome | Kaplan-Meier curve | Cumulative hazard, forest plot for Cox model | Include risk table when useful. |
| Categorical composition | Stacked bar | 100% stacked bar, mosaic-like plot | Label denominators or percentages. |
| Categorical numeric summaries with `>25` categories where the goal is frequency, proportion, composition, absolute contribution, burden, or overview ranking | Polar plot or rose chart | | Use circular layouts for compact overview messages, not for significance-value precision, correlation-coefficient comparison, thresholds, P values, CIs, significance marks, or adjusted-versus-unadjusted differences. |
| Part-to-whole with few categories | Bar chart | Pie/donut only for simple composition | Prefer bars when comparing slices matters. |
| High-dimensional numeric matrix | Heatmap | Clustered heatmap, annotated heatmap | Standardize rows/columns only when scientifically justified. |
| Three components summing to one | Ternary plot | Stacked bar if groups are discrete | Validate that components sum to a constant. |
| Model diagnostics | Residual plot | QQ plot, influence plot, calibration curve | Tie chart to model assumptions. |
| Regression estimates | Forest plot | Coefficient dot-whisker plot | Show effect size, CI, reference group, and scale. |

## Recommendation Style

The first user-facing response after inspecting data must be a recommendation response, not plotting code. Pause for user choice before plotting. Present:

1. A compact data profile: rows, columns, key variable roles, missingness highlights, and matched chart families.
2. One recommended single-figure chart and up to two single-figure alternatives.
3. An `Optional multi-panel figure` note when the data can support complementary analyses such as distribution plus effect estimate, trend plus subgroup summary, survival curve plus risk table/forest plot, heatmap plus validation plot, or model fit plus diagnostics. Include the main message, A/B/C panel roles, support logic, use case, limitation, and expected outputs.
4. A `Multi-panel not recommended` note when the data profile lacks enough complementary evidence; name the missing field or statistic.
5. `Style options` with `general`, `nature`, `lancet`, `nejm`, `jama`, and `bmj`.
6. A direct choice question asking which chart option and style to generate.

```text
I found one categorical group variable and one continuous outcome.

Recommended single figure: Boxplot with jittered points
Why: shows median, spread, outliers, and raw observations.
Output: PDF, SVG, 700 dpi TIFF, web PNG.

Alternative: Violin/raincloud plot
Why: better if distribution shape is the main message.

Alternative: Mean dot-whisker plot
Why: better if the manuscript focuses on estimated mean differences.

Optional multi-panel figure: A two-panel support figure.
Main message: treatment groups differ in both observed distribution and estimated effect size.
Panels: A: boxplot + raw points; B: mean difference with 95% CI.
Support logic: Panel A shows data distribution; Panel B provides the manuscript-ready effect estimate.
Use when: the manuscript needs both distribution and effect-size evidence.
Limitation: this requires a defensible CI/test definition and enough observations per group.
Expected outputs: PDF, SVG, 700 dpi TIFF, web PNG.

Style options:
- 通用风格 general（默认）：来源于《统计图形艺术》的医学统计绘图规则。
- Nature 风格 nature：适合 Nature-family / 高影响力期刊图，强调证据层级、低饱和统一色系、可编辑 SVG 和紧凑多面板布局。
- Lancet 风格 lancet：适合 The Lancet / 临床流行病学图，强调强可读性、可编辑矢量图、实线对比编码、临床表格与效应量对齐。
- NEJM 风格 nejm：适合 NEJM 临床试验/肿瘤/生存曲线与表格式森林图，强调白底、粗黑坐标轴、直接标注、风险表和浅灰表格行带。
- JAMA 风格 jama：适合 JAMA / JAMA Network 临床研究图，强调统计标签清楚、克制期刊色板、表格和效应量对齐、可编辑矢量输出。
- BMJ 风格 bmj：适合 BMJ / The BMJ 实用临床和公共卫生图，强调高可读性、朴素证据展示、保守配色、读者友好的标签和注释。

请选择：图表方案 + 风格。
如果只选择图表，我将默认使用通用风格。
```

If multiple choices are plausible, offer at most three and choose a recommended default for the user to approve. Always include the available style options. Then wait for the user's selection. On the first data-handling turn, automatic chart selection is disabled even when the user says to plot or visualize the data.

When profiling finds a categorical numeric variable with `>25` categories and the message is frequency, proportion, composition, absolute contribution, burden, or overview ranking, make a polar plot or rose chart the first recommendation. If the message is significance-value or correlation-coefficient precision, threshold judgment, P value, CI, significance marking, or adjusted-versus-unadjusted differences, do not prioritize circular charts.