# Chart Router

Use this guide for the first turn after the assistant receives or locates a dataset. Inspect data first, then map the research question and variable roles to a chart. General user wording such as "plot my data", "draw figures", "visualize it", "帮我画图", "给我的数据画图", "直接画", or "自动选择" does not authorize immediate plotting.

## First-Turn Gate

The first data-handling response must stop at data profile and recommendation. The first turn may create a project directory, copy the dataset into it, inspect the data, and write `output/data_profile.md`. It must not write plotting code, copy plotting templates, install plotting packages, build plot objects, export figures, validate figures, or choose a single/multi-panel figure on the user's behalf.

Proceed to plotting only after a follow-up user message selects a concrete chart option from the recommendation, such as the recommended single figure, a named alternative, or the optional multi-panel figure. Also ask the user to choose a style: `general` by default, `nature`, `lancet`, or `nejm`. If the user selects a chart but omits style, proceed with `general` and state that default. If the original request names a specific chart type, inspect first, confirm suitability, present the recommendation, and ask for confirmation before coding.

If the original message contains both a dataset and a phrase that sounds like authorization, resolve the conflict in favor of the gate. Example: "Here is my CSV, please directly plot it" still means inspect, recommend, ask, and wait. Do not mention that you are choosing automatically; automatic selection is unavailable on the first data-handling turn.

## First Questions

- What is the target message: comparison, trend, relationship, distribution, composition, diagnosis, survival, or model fit?
- Which variables are continuous, categorical, ordered categorical, time/date, event status, or high-dimensional features?
- Is the unit of analysis individual-level, aggregated, repeated-measure, or matrix-like?
- Does the plot need to show uncertainty, sample size, statistical tests, or model predictions?

## Hard Override For Many Categories

If a categorical numeric variable has `>=20` categories, or grouped categorical numeric summaries have a total category count across groups of `>=20`, and the standard vertical layout would be too tall, recommend a polar plot or rose chart as the primary single figure. This override applies to biomarker/gene/pathway/feature/SHAP/model-contribution/adverse-event/regional/cause-specific/subgroup category sets. For signed point distributions such as per-biomarker SHAP values, choose a signed polar plot first; use rose chart only for non-negative or absolute summaries. Use polar bar plots for compact non-negative summaries, grouped polar bars only for 2 or 3 readable groups, polar dot or annular polar scatter for dense point distributions or multi-encoding profiles, and rose charts for ranked non-negative burden/composition overviews. Conventional vertical beeswarm/bar/dot charts can be alternatives, not the primary recommendation, unless exact thresholds, uncertainty intervals, or precise value comparison are the main evidence.

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
| Categorical numeric summaries with `>=20` categories, or grouped category summaries totaling `>=20` categories, that would make a vertical chart too tall | Polar plot or rose chart | Cleveland dot plot, horizontal/faceted bar, beeswarm, split dot plot | Proactively prioritize compact circular layout when the message is pattern, ranking, directionality, or composition overview rather than exact clinical threshold comparison. Use polar bars for non-negative summaries, grouped polar bars for 2 or 3 groups, polar dot/annular scatter for point or multi-encoding data, signed polar plots for positive/negative summaries such as per-biomarker SHAP distributions, and rose charts for non-negative ranked burden/composition. |
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
5. `Style options` with `general`, `nature`, `lancet`, and `nejm`.
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
Expected outputs: PDF, SVG, 700 dpi TIFF, web PNG, rationale, session info.

Style options:
- 通用风格 general（默认）：来源于《统计图形艺术》的医学统计绘图规则。
- Nature 风格 nature：适合 Nature-family / 高影响力期刊图，强调证据层级、低饱和统一色系、可编辑 SVG 和紧凑多面板布局。
- Lancet 风格 lancet：适合 The Lancet / 临床流行病学图，强调强可读性、可编辑矢量图、实线对比编码、临床表格与效应量对齐。
- NEJM 风格 nejm：适合 NEJM 临床试验/肿瘤/生存曲线与表格式森林图，强调白底、粗黑坐标轴、直接标注、风险表和浅灰表格行带。

请选择：图表方案 + 风格。
如果只选择图表，我将默认使用通用风格。
```

If multiple choices are plausible, offer at most three and choose a recommended default for the user to approve. Always include the available style options. Then wait for the user's selection. On the first data-handling turn, automatic chart selection is disabled even when the user says to plot or visualize the data.

When profiling finds a categorical count/rate/proportion/mean/SHAP/model-contribution variable with `>=20` categories, or grouped categorical summaries with total categories across groups `>=20`, and a conventional vertical categorical chart would become too tall, make a polar plot or rose chart the first recommendation unless exact value comparison, clinical thresholds, or confidence intervals are the main evidence. For signed positive/negative data such as per-biomarker SHAP point distributions, prefer a signed polar plot with a clear zero ring and diverging color/direction encoding; reserve rose charts for non-negative magnitudes, absolute summaries, counts, proportions, or burden/composition overviews. Load `references/special-charts.md` for the circular-chart rules, and name a Cleveland dot plot, beeswarm, or faceted/horizontal bar chart as the readability or precision fallback.
