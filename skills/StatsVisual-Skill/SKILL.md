---
name: StatsVisual-Skill
description: Create publication-ready medical and biostatistical graphics with R. Use when Codex needs to inspect tabular data, profile it, recommend charts and visual styles, and only after the user confirms a chart choice write and run R plotting code to export vector PDF, editable SVG, 700+ dpi TIFF, and a web image under 1 MB. Supports general/Nature/Lancet/NEJM/JAMA/BMJ styles for ggplot2, survival curves, heatmaps, regression diagnostics, distribution graphics, and multi-panel figures.
---

# Core Workflow

Follow this five-step flow in order. Never skip ahead.

1. **Inspect and profile the data.** Read the data file directly to analyze its structure, columns, types, missingness, and distributions. Use `scripts/data_profile.R <data_file>` (prints a Markdown profile to stdout) or profile inline. Summarize the data profile in the conversation: rows, columns, key fields, variable roles, missingness highlights, and any data-quality limits that affect chart choice.
2. **Recommend charts (and wait).** Recommend one primary single figure plus up to two single-figure alternatives, and an optional multi-panel figure when the data supports complementary analyses. Ask the user to choose, and ask which style to use. Follow `## Recommendation Reply Format`.
3. **Wait for the user's chart choice.** Do not write plotting code in the same turn that first receives the data. Only a follow-up user message can authorize plotting. See `## First-Turn Gate`.
4. **Write and run the R script.** Write one complete script (not snippets) from `assets/plot_template.R` or the closest starter in `assets/templates/`. Locate the skill directory, source `scripts/setup_r_library.R`, prepare the local R library, check packages, read data, validate columns, build the plot, and export figures. For multi-panel figures, write a short figure plan first.
5. **Export, verify, and explain.** Export every final figure in four forms, verify the files exist and are non-empty, then present the figure explanation in the conversation using `## Figure Explanation`.

# First-Turn Gate

When a user first provides, attaches, names, or points to a dataset, stop after data profiling and chart recommendation. This is true no matter what extra wording is in the same message, including "plot my data", "draw it", "visualize it", "帮我画图", "给我的数据画图", "直接画", or "自动选择".

**Allowed before the first recommendation reply:**
- create the per-request project folder;
- copy the source data into that project folder when needed;
- inspect/profile the data;
- write a project-local data profile or recommendation log.

**Forbidden before the user replies with a chart choice:**
- do not write or copy an R plotting script;
- do not adapt templates;
- do not install plotting packages;
- do not build plot objects;
- do not export PDF/SVG/TIFF/PNG files;
- do not validate generated figures;
- do not choose a single or multi-panel figure on the user's behalf.

**What counts as authorization:** only a follow-up user message after the recommendation can authorize plotting. Valid authorization must select a concrete option, for example "按推荐单图绘制", "选择组图", "用方案 B", "画 forest plot", or an equivalent explicit chart choice. If the same first message includes both data and an apparent plotting instruction, treat the plotting instruction as the user's goal for after the recommendation, not as permission to bypass the gate. If the user names an exact chart type in the original request, still inspect the data first, confirm whether that chart is appropriate, mention any serious mismatch, recommend the best single-figure and optional multi-panel choices, then ask for confirmation before coding. Treat automatic selection as disabled during the first data-handling turn.

# Recommendation Reply Format

Use this structure for the first recommendation reply after profiling data. Keep entries concise and omit a second alternative when it would be weak or repetitive. Keep professional medical/statistical English terms in English when that is clearer or conventional, such as `hazard ratio`, `odds ratio`, `risk ratio`, `confidence interval`, `Kaplan-Meier`, `forest plot`, `ROC curve`, `calibration curve`, `Cleveland dot plot`, `polar plot`, `rose chart`, `SHAP`, `P value`, `95% CI`, `ggplot2`, and journal/style names. Write all non-technical explanations, reasons, limitations, prompts, and transitions in Chinese.

Reference `## Common Routes` in `references/chart-index.md` for the recommendation logic.

```markdown
数据画像摘要
- 行数/列数：
- 关键字段：
- 变量角色：
- 缺失值和数据质量提示：

推荐的单图
- 图形：
- 推荐理由：

备选方案
1. 图形：
   推荐理由：
2. 图形：
   推荐理由：

可选多面板图 / 不建议多面板图
- 建议：
- 面板角色：
- 推荐理由：
- 局限性：

风格选项
- 可选风格：`general` `nature` `lancet` `nejm` `jama` `bmj`

请确认
- 选择“推荐的单图”、备选方案 1 或 2、或“可选多面板图”。
- 同时选择风格；如果只选择图形，我将默认使用 `general` 通用风格。
```

# Special Chart Rules

## Many-Category Circular Chart Rule

When data profiling finds a categorical numeric variable with `>25` categories, prioritize a rose chart or polar plot only when the main goal is to show frequency, proportion, composition, absolute contribution, burden magnitude, or overview ranking.

Do not prioritize a rose chart or polar plot when the main goal is significance-value or correlation-coefficient precision, threshold judgment, P value, CI, significance marking, or adjusted-versus-unadjusted differences, even when the category count is `>25`.

- Use a polar bar plot for non-negative numeric summaries when the message is compact pattern, subgroup overview, composition, burden, or overview ranking.
- Use a grouped polar bar plot when there are several readable groups and the grouped categories together exceed 25 for an overview message.
- Use a polar dot plot or annular polar scatter for dense multi-encoding overview displays where radius, color, and size need to encode separate variables.
- Use a rose chart first for non-negative counts, rates, proportions, burden magnitudes, cause-specific totals, regional totals, or absolute contributions when the goal is a ranked/editorial overview.
- For both polar plots and rose charts, reserve a clear circular blank center, keep the angle of every label one-to-one with its category.
- For rose charts, place outside labels close to each bar tip; do not put all labels on a single outer concentric circle when bar lengths differ seriously, because that separates labels from their marks.

## Calibration Curve Shape Rule

Calibration curve figures must use a square plotting area. Use equal x and y limits, keep the ideal calibration line at 45 degrees with a fixed aspect ratio such as `coord_equal()`, and export the figure with equal width and height unless the calibration panel is part of a planned multi-panel figure.

# Reference Loading

Load only the references needed for the task:

- Use `references/chart-index.md` to route from data structure and research intent to a chart family (`## Common Routes`), then map the selected chart family to its detailed chart reference (`## Chart Family → Reference`).
- Use the relevant detailed chart reference after the chart family is chosen: `bar-chart.md`, `line-chart.md`, `pie-chart.md`, `histogram.md`, `cleveland-dot-plot.md`, `box-plot.md`, `scatter-plot.md`, `heatmap.md`, `ternary-plot.md`, `q-q-plot.md`, `probability-distribution-plot.md`, `smoothing-curve.md`, `linear-regression.md`, `nonlinear-regression.md`, `regression-diagnostics.md`, `survival-curve.md`, `forest-plot.md`, or `special-charts.md`.
- Use `references/special-charts.md` for advanced special figures: polar plot, signed polar plot, annular polar scatter, radar, stream/river, rose, fourfold, spiral histogram, Manhattan, sunflower density, bubble, LOWESS smooth, density ternary, and model-diagnostic bubble charts.
- Use `references/multipanel-figures.md` when the requested output is a multi-panel figure, composite clinical/statistical figure, image plus measurement figure, workflow-led figure, shared-legend layout, or any A/B/C panel figure. A multi-panel figure must be a coherent manuscript figure with a figure plan, not a simple collage.
- Use `references/design-rules.md` as the style entrypoint. Load `references/styles/general.md` for the default book-derived general style, `references/styles/nature.md` for Nature-style figures, `references/styles/lancet.md` for Lancet-style clinical figures, `references/styles/nejm.md` for example-derived NEJM clinical-trial figures, `references/styles/jama.md` for JAMA-style clinical research figures, or `references/styles/bmj.md` for BMJ-style pragmatic clinical figures.
- For `lancet` forest plots, `references/styles/lancet.md` overrides generic `forest-plot.md` layout defaults: the forest axis must be embedded as a table column, not rendered as a separate side-by-side panel, and must not inherit generic light category bands or extra table separator rules unless the user explicitly requested them.
- Use `references/styles/style-router.md` during the first recommendation turn so chart and style are requested together.
- Use `references/r-workflow.md` for package choices, project layout, R script structure, local-library behavior, and export behavior.
- Use `references/windows-setup.md` when Windows package installation fails with elevation, blocked library paths, or CRAN mirror access problems.
- Use `references/readability-qa.md` before final delivery or when debugging figure quality: it defines the delivery gate (required checks and delivery-blocking failures) plus readability thresholds, shared-axis validation, and the QA loop.

# Default R Choices

Use `ggplot2` for most plots. Prefer tidy data tools for preprocessing, `patchwork` for ggplot composition, `cowplot` when extracting legends or mixing table/plot grobs, `ggrepel` and `ggpubr` for labels/annotation, `forcats` for factor ordering, `stringr` for string cleanup, `survival` plus `survminer` or `ggsurvfit` for survival graphics, `ComplexHeatmap` for serious heatmaps, `pheatmap` for simple heatmaps, and `ggtern` for ternary plots.

Treat these packages as installable requirements, not optional suggestions. If a selected chart needs a package that is not installed, install it automatically from CRAN or Bioconductor as appropriate, then continue. Avoid base-R substitutes unless the user explicitly requests a no-install workflow.

Use conservative publication defaults: white background, readable axis labels, explicit units, color-blind-aware palettes, direct statistical annotation only when computed or provided, and no decorative effects that obscure data.

## Project layout and exports

- Create or use one explicit per-request project directory. Never write task artifacts to the skill repository root or the caller's current directory by default. Use `scripts/create_plot_project.R <project_dir>`, then keep all data copies, R scripts, outputs, and figures inside that directory.
- Export every final figure in four forms inside `<project_dir>/figures/` unless the user asks otherwise:
  - Vector: `<name>.pdf`
  - Editable: `<name>.svg`
  - Print: `<name>_700dpi.tiff` at 700 dpi or higher
  - Web: `<name>_web.png` or `<name>_web.jpg`, target under 1 MB
- Before any CRAN/Bioconductor access, verify installed packages from the active environment by sourcing `scripts/setup_r_library.R` and calling `rmg_prepare_library(project_dir, skill_dir)`. This must happen before deciding a package is missing. Install missing R packages only after that local-library check, using the repository-local `.r-medical-graphics-library/` by default and `<project_dir>/R-library` or a writable user library as fallback. Use `scripts/install_required_packages.R` or call `rmg_ensure_packages()` from generated scripts. In restricted Codex environments, CRAN/Bioconductor access may require an escalated network approval; if installation fails with network, repository, DNS, proxy, SSL, or permission errors, request the needed approval and retry the same installation command. If Windows reports `740` or "requested operation requires elevation", first switch to the repository-local or project-local library; do not misreport this as a CRAN access problem. Do not silently downgrade figure quality or switch away from the intended plotting package because a library is missing.
- Run the script when feasible. After export, verify that PDF, SVG, TIFF, and web image files exist, are non-empty, and the web image is under 1 MB. Review the plotting code against `references/readability-qa.md` before delivery (including the delivery checklist): verify font sizes, panel scales, label lengths, legend entries, color contrast, and axis transforms are appropriate for the final output size. When image viewing is available, inspect the final web PNG or TIFF preview directly and check that the plotted data are large enough, text is readable, labels/legends do not overlap, panels are balanced, and shared axes do not visually collapse any subgroup.
- Report output paths under the project directory and any unresolved design decisions. If package installation still fails after the appropriate approval/retry path, stop and report the exact installation failure instead of producing a lower-quality fallback.

# Useful Scripts

- `scripts/create_plot_project.R <project_dir>` creates a required per-request project directory with `data/`, `R/`, and `figures/`.
- `scripts/bootstrap_windows_dependencies.ps1` performs one-time Windows package setup in the repository-local `.r-medical-graphics-library/` by default when Codex cannot install packages inside a restricted session.
- `scripts/check_dependencies.R` verifies that required packages are visible to the active R session.
- `scripts/setup_r_library.R` is the shared R library bootstrap. Source this before package checks in every generated plotting/export script.
- `scripts/install_required_packages.R <pkg1> [pkg2 ...]` installs missing CRAN packages; use `BIOC::<pkg>` for Bioconductor packages.
- `scripts/export_publication_figures.R` provides the `export_publication_figures()` function, which exports PDF, SVG, TIFF, and web PNG from a ggplot object. Source this file and call the function directly; pass `project_dir` to enforce project-local output.
- `scripts/data_profile.R <data_file>` profiles a CSV/TSV/RDS/Excel file and prints a Markdown data profile to stdout (no files are written). Use it to inspect structure, column roles, types, missingness, numeric summaries, categorical distributions, wide-format columns, and bivariate relationships before recommending charts.

# Useful Templates

Copy these into `<project_dir>/R/` and adapt column names, labels, statistics, and figure-specific annotations:

- `assets/templates/bar_plot/` for basic, error-bar, stacked, stratified, waterfall, and polar bar plots.
- `assets/templates/box_plot/` for box, violin, notched, letter-value, stratified, beeswarm, pirate, pagoda, raincloud, and grouped raincloud plots.
- `assets/templates/cleveland_dot_plot/` for Cleveland's dot, stratified dot, lollipop, interaction lollipop, dumbbell, epidemic trend, and Manhattan plots.
- `assets/templates/probability_distribution/` for 23 probability distributions (Normal, t, F, Chi-square, Beta, Gamma, Poisson, Binomial, etc.).
- `assets/templates/forest_plot/` for subgroup forest plots with table-aligned effect estimates and interaction columns.
- `assets/templates/heatmap/` for basic, clustered, contour, filled contour, Sankey, Venn, UpSet, and calendar heatmaps.
- `assets/templates/histogram/` for basic, variable-bin, gradient, grouped, stacked, symmetric, pyramid, ridgeline, epidemic ridgeline, and spiral histograms.
- `assets/templates/line_chart/` for time series, point-line, errorbar-line, step, smooth, area, stacked area, stream, scree, and radar plots.
- `assets/templates/linear_regression/` for linear regression, deviations, bivariate ellipse, response surface, and performance radar plots.
- `assets/templates/multipanel_plot/` for reusable patchwork/cowplot layout helpers and multi-panel script scaffolds.
- `assets/templates/nonlinear_regression/` for polynomial, convex-concave, sigmoid, and quantile regression plots.
- `assets/templates/pie_plot/` for pie, exploding, exploded-slice, doughnut, nested, rose, and fourfold plots.
- `assets/templates/qq_plot/` for theoretical QQ, P-P, Chi-square quantile, symmetry, and ladder-of-powers plots.
- `assets/templates/regression_diagnostics/` for residuals-vs-fitted, leverage, Cook's distance, influence index, and half-normal leverage plots.
- `assets/templates/scatter_plot/` for scatter, smooth-scatter, marginal-distribution, scatterplot matrix, smooth, sunflower, bubble, and volcano plots.
- `assets/templates/smoothing_curve/` for LOWESS smooth and LOWESS regression plots.
- `assets/templates/survival_curve/` for Kaplan-Meier, truncated, median-reference, confidence-band, cumulative-hazard, risk-table, comparison, integrated, Schoenfeld, Cox deviance, and adjusted survival plots.
- `assets/templates/ternary_plot/` for ternary plots.

Treat templates as starting points, not fixed outputs. Read `references/chart-index.md` and the relevant detailed chart reference before adapting them for variants such as violin, raincloud, density scatter, coefficient plots, or longitudinal charts. Read `references/design-rules.md` and the selected style reference before finalizing visual choices. Read `references/multipanel-figures.md` before adapting any A/B/C or composite figure.

# Output Standard

For each completed figure, prefer this artifact set:

```text
R/plot_<chart_type>.R
figures/<name>.pdf
figures/<name>.svg
figures/<name>_700dpi.tiff
figures/<name>_web.png
```

These paths are relative to the per-request project directory, not the skill repository root.

# Figure Explanation

After figures are exported and validated, present the figure explanation directly in the conversation with the following content. 

## 内容模板

```markdown

# 图形解释

## 图形：[图形类型]｜[图形名称]｜[风格名称]

## 数据与方法：
- N = [样本量]；[数据分层/分组说明]
- 采用 [详细统计方法]

## 关键结果：
- [主要发现1]
- [主要发现2]

## 结论：[总结核心统计学发现]

## 说明：[图形阅读提示]

```

说明内容必须写入对话回复。
