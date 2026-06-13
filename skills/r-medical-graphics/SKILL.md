---
name: r-medical-graphics
description: Create publication-ready medical and biostatistical graphics with R. Use when Codex needs to inspect tabular data, produce a data-profile-first chart recommendation, ask which chart and visual style to use, support general book-derived style, Nature-style figures, Lancet-style clinical figures, or NEJM-style clinical trial figures, then only after the user confirms a chart choice write and run R plotting code, export vector PDF, editable SVG, 700 dpi or higher TIFF, and a web image under 1 MB, or apply medical research visualization conventions for ggplot2, survival curves, heatmaps, regression diagnostics, distribution graphics, and multi-panel figures.
---

# R Medical Graphics

## Core Workflow

Use this skill to turn user data and research intent into reproducible R code and publication-ready figures.

## Hard Chart-Routing Override

When data profiling finds a categorical numeric variable with `>=20` categories, or grouped categorical numeric summaries where the total category count across groups is `>=20`, and the normal vertical layout would become too tall, prioritize a polar plot or rose chart and do not recommend a vertical-first chart as the primary single figure. This includes biomarker, gene, pathway, feature, variable-importance, SHAP, model-contribution, adverse-event, regional, cause-specific, or subgroup categories. Recommend a polar plot or rose chart first:

- Use a polar bar plot for non-negative numeric summaries when the message is compact ranking, pattern, subgroup overview, or precise quantitative comparison.
- Use a grouped polar bar plot when there are several groups and the grouped categories together reach 20.
- Use a polar dot plot, annular polar scatter, or signed polar plot for point distributions, positive/negative values, SHAP distributions, model contributions, or cases where radius, color, and size need to encode separate variables.
- Use a rose chart first for non-negative counts, rates, proportions, burden magnitudes, cause-specific totals, regional totals, or absolute SHAP summaries when the goal is a ranked/editorial overview.
- For both polar plots and rose charts, reserve a clear circular blank center, keep the angle of every label one-to-one with its category.
- For rose charts, place outside labels close to each bar tip; do not put all labels on a single outer concentric circle when bar lengths differ seriously, because that separates labels from their marks.

## Non-Negotiable First-Turn Gate

When a user first provides, attaches, names, or points to a dataset, stop after data profiling and chart recommendation. This is true no matter what extra wording is in the same message, including requests like "plot my data", "draw it", "visualize it", "帮我画图", "给我的数据画图", "直接画", or "自动选择".

Allowed before the first recommendation reply:
- create the per-request project folder;
- copy the source data into that project folder when needed;
- inspect/profile the data;
- write a project-local `output/data_profile.md` or recommendation log.

Forbidden before the user replies with a chart choice:
- do not write or copy an R plotting script;
- do not adapt templates;
- do not install plotting packages;
- do not build plot objects;
- do not export PDF/SVG/TIFF/PNG files;
- do not validate generated figures;
- do not choose a single or multi-panel figure on the user's behalf.

Only a follow-up user message after the recommendation can authorize plotting. Valid authorization must select a concrete option, for example "按推荐单图绘制", "选择组图", "用方案 B", "画 forest plot", or an equivalent explicit chart choice. If the same first message includes both data and an apparent plotting instruction, treat the plotting instruction as the user's goal for after the recommendation, not as permission to bypass the gate.

1. Create or use one explicit per-request project directory. Never write task artifacts to the skill repository root or the caller's current directory by default. Use `scripts/create_plot_project.R <project_dir>`, then keep all data copies, R scripts, outputs, and figures inside that directory.
2. First inspect the data and produce a data-profile-based recommendation before any plotting code, figure export, package-heavy plotting work, or template copying. Prefer `scripts/inspect_data_for_charts.R <data_file> <project_dir>/output/data_profile.md` for CSV, TSV, XLSX, and RDS files, but treat that file as an internal run log.
3. In the first user-facing reply after data inspection, summarize the data profile directly in the conversation. Include rows, columns, key fields, variable roles, missingness highlights, matched chart families, and any data-quality limits that affect chart choice.
4. Before writing plotting code or exporting figures, recommend charts from the data profile. Always provide one recommended single figure and up to two single-figure alternatives. Always ask whether the user wants the recommended single figure, an alternative single figure, or the optional multi-panel figure when available. Also ask which style to use: `general`/通用风格 by default, `nature`/Nature 风格, `lancet`/Lancet 风格, or `nejm`/NEJM 风格. If the data can support complementary evidence, also provide an optional multi-panel figure. If a categorical variable paired with count, rate, proportion, mean, SHAP value, model contribution, or another numeric summary has `>=20` categories, or if grouped categorical summaries have a total category count across groups of `>=20`, and a conventional vertical categorical chart would become too tall or label-heavy, proactively prioritize a polar plot or rose chart in the recommendation. For signed values with positive and negative direction, such as per-biomarker SHAP point distributions, make a signed polar plot the first recommendation and map sign around a clear zero ring or diverging radial/color encoding. Use polar bar plots for compact non-negative category summaries, grouped polar bars for 2 or 3 readable groups, polar dot/annular scatter for dense point or multi-encoding displays, and rose charts for non-negative ranked magnitudes, absolute SHAP summaries, counts, proportions, cause-specific burden, or composition overviews. Make the circular option the recommended single figure when the message is compact pattern, ranking, directionality, or composition overview rather than exact threshold comparison; offer Cleveland dot plot, horizontal/faceted bar, beeswarm, or split dot plot as precision-oriented alternatives. Use `references/chart-router.md`, `references/chart-index.md`, `references/design-rules.md`, `references/styles/style-router.md`, the selected style reference, the relevant detailed chart reference, `references/multipanel-figures.md` when relevant, and the data profile.
5. Format the recommendation so the user can choose without opening files: summarize the data profile, then state `Recommended single figure`, `Alternatives`, `Optional multi-panel figure` or `Multi-panel not recommended`, and `Style options`. A multi-panel recommendation must include the core conclusion, A/B/C panel roles, evidence-chain logic, suitable use case, key limitation, and expected outputs.
6. Wait for the user's chart choice after the recommendation response. Do not start plotting in the same turn that first receives or locates the data, even if the user adds a general request such as "plot this data", "draw a figure", "make charts", "visualize it", "help me plot", "帮我画图", "给我的数据画图", or "生成图片". These phrases only express the overall task, not permission to bypass the recommendation stage. If the user names an exact chart type in the original request, still inspect the data first, confirm whether that chart is appropriate, mention any serious mismatch, recommend the best single-figure and optional multi-panel choices, then ask for confirmation before coding. Only a follow-up user message after the recommendation stage can authorize plotting.
7. Treat automatic selection as disabled during the first data-handling turn. A first-turn instruction like "use this folder/project and plot my data" still requires data profiling, chart recommendation, and a choice question. The user can authorize plotting only after seeing the recommendation, for example by replying "按推荐单图绘制", "选择组图", "用方案 B", or an equivalent explicit chart choice.
8. If the user chooses or requests a multi-panel figure, write a short figure contract before coding. Include core conclusion, primary evidence, supporting evidence, reviewer risk, panel map, shared encodings, output size, and export formats. Do not write the R script until this contract is explicit in the conversation or saved in `<project_dir>/output/figure_contract.md`.
9. Write a complete R script rather than disconnected snippets after the user chooses. Use `assets/plot_template.R` as the default shape, or copy the closest starter from `assets/templates/` for distribution comparison, scatter/association, model diagnostics, or multi-panel figures. Pass the selected style to the starter or call `rmg_theme(style)` and `rmg_palette(n, style)` directly; if the user chose a chart but not a style, use `general`. For multi-panel figures, source `assets/templates/multipanel_helpers.R` or copy only the needed helpers; do not reuse synthetic demo panels as final analysis. Find the skill directory, source `scripts/setup_r_library.R`, load the repository/project R library, check packages, read data, validate columns, build plot, export figures, save `sessionInfo()`.
10. Export every final figure in four forms inside `<project_dir>/figures/` unless the user asks otherwise:
   - Vector: `<name>.pdf`
   - Editable: `<name>.svg`
   - Print: `<name>_700dpi.tiff` at 700 dpi or higher
   - Web: `<name>_web.png` or `<name>_web.jpg`, target under 1 MB
11. Before any CRAN/Bioconductor access, verify installed packages from the active environment by sourcing `scripts/setup_r_library.R` and calling `rmg_prepare_library(project_dir, skill_dir)`. This must happen before deciding a package is missing. Install missing R packages only after that local-library check, using the repository-local `.r-medical-graphics-library/` by default and `<project_dir>/R-library` or a writable user library as fallback. Use `scripts/install_required_packages.R` or call `rmg_ensure_packages()` from generated scripts. In restricted Codex environments, CRAN/Bioconductor access may require an escalated network approval; if installation fails with network, repository, DNS, proxy, SSL, or permission errors, request the needed approval and retry the same installation command. If Windows reports `740` or "requested operation requires elevation", first switch to the repository-local or project-local library; do not misreport this as a CRAN access problem. Do not silently downgrade figure quality or switch away from the intended plotting package because a library is missing.
12. Run the script when feasible. Check that files exist, are non-empty, SVG is present, and that the web image is under 1 MB. Use `scripts/validate_r_plot.R <project_dir>/figures` for basic file/export checks. Then run `scripts/validate_figure_readability.R <plot_rds> <project_dir>/figures <figure_name> <width_in> <height_in> <project_dir>` for final-size readability checks. Read `references/readability-qa.md` before delivery or when any panel, subgroup, label, legend, or axis scale may be hard to read. If readability QA reports `FAIL`, revise the plotting code and re-export instead of delivering the figure. When image viewing is available, inspect the final web PNG or TIFF preview directly and check that the plotted data are large enough, text is readable, labels/legends do not overlap, panels are balanced, and shared axes do not visually collapse any subgroup.
13. Write `<project_dir>/output/figure_rationale.md` after generating a final figure. Include selected figure, book basis, data mapping, style choices, thresholds/statistical annotations, limitations, and output files. For multi-panel figures, include the figure contract and explain what distinct evidence each panel contributes.
14. Report output paths under the project directory and any unresolved design decisions. If package installation still fails after the appropriate approval/retry path, stop and report the exact installation failure instead of producing a lower-quality fallback.

## Reference Loading

Load only the references needed for the task:

- Use `references/chart-router.md` for the optimized workflow: inspect data, recommend one single figure, offer a constrained optional multi-panel figure only when the profile supports complementary evidence, ask for style, and wait for user choice.
- Use `references/chart-index.md` to map a selected chart family to the detailed chart reference.
- Use the relevant detailed chart reference after the chart family is chosen: `bar-chart.md`, `line-chart.md`, `pie-chart.md`, `histogram.md`, `cleveland-dot-plot.md`, `box-plot.md`, `scatter-plot.md`, `heatmap.md`, `ternary-plot.md`, `q-q-plot.md`, `probability-distribution-plot.md`, `smoothing-curve.md`, `linear-regression.md`, `nonlinear-regression.md`, `regression-diagnostics.md`, `survival-curve.md`, `forest-plot.md`, or `special-charts.md`.
- Use `references/special-charts.md` for advanced special figures: polar plot, signed polar plot, annular polar scatter, radar, stream/river, rose, fourfold, spiral histogram, Manhattan, sunflower density, bubble, LOWESS smooth, density ternary, and model-diagnostic bubble charts.
- Use `references/multipanel-figures.md` when the requested output is a multi-panel figure, composite figure, clinical evidence chain, image-plus-quantification figure, schematic-led figure, shared-legend layout, or any A/B/C panel figure. A multi-panel figure must be an evidence chain with a figure contract, not a simple collage.
- Use `references/design-rules.md` as the style entrypoint. Load `references/styles/general.md` for the default book-derived general style, `references/styles/nature.md` for Nature-style figures, `references/styles/lancet.md` for Lancet-style clinical figures, or `references/styles/nejm.md` for example-derived NEJM clinical-trial figures.
- For `lancet` forest plots, `references/styles/lancet.md` overrides generic `forest-plot.md` layout defaults: the forest axis must be embedded as a table column, not rendered as a separate side-by-side panel, and must not inherit generic light category bands or extra table separator rules unless the user explicitly requested them.
- Use `references/styles/style-router.md` during the first recommendation turn so chart and style are requested together.
- Use `references/output-rules.md` for file naming, output folders, export formats, CJK PDF guidance, and output bundle rules.
- Use `references/r-workflow.md` for package choices, project layout, R script structure, local-library behavior, and export behavior.
- Use `references/windows-setup.md` when Windows package installation fails with elevation, blocked library paths, or CRAN mirror access problems.
- Use `references/publication-qa.md` before final delivery or when debugging figure quality.
- Use `references/readability-qa.md` before final delivery, when validating subgroups/facets with shared axes, or when scripted QA reports `WARN` or `FAIL`.

## Default R Choices

Use `ggplot2` for most plots. Prefer tidy data tools for preprocessing, `patchwork` for ggplot composition, `cowplot` when extracting legends or mixing table/plot grobs, `ggrepel` and `ggpubr` for labels/annotation, `forcats` for factor ordering, `stringr` for string cleanup, `survival` plus `survminer` or `ggsurvfit` for survival graphics, `ComplexHeatmap` for serious heatmaps, `pheatmap` for simple heatmaps, and `ggtern` for ternary plots.

Treat these packages as installable requirements, not optional suggestions. If a selected chart needs a package that is not installed, install it automatically from CRAN or Bioconductor as appropriate, then continue. Avoid base-R substitutes unless the user explicitly requests a no-install workflow.

Use conservative publication defaults: white background, readable axis labels, explicit units, color-blind-aware palettes, direct statistical annotation only when computed or provided, and no decorative effects that obscure data.

## Data And Privacy

Do not copy private source manuscripts, raw book chapters, WeChat cache files, unreviewed real CSV files, or large PDFs into a public skill. Use manuscript-derived knowledge only as concise, rewritten guidance. For examples, use synthetic data from `assets/example_data/` or generate small artificial data inside scripts.

## Useful Scripts

- `scripts/create_plot_project.R <project_dir>` creates a required per-request project directory with `data/`, `R/`, `output/`, and `figures/`.
- `scripts/bootstrap_windows_dependencies.ps1` performs one-time Windows package setup in the repository-local `.r-medical-graphics-library/` by default when Codex cannot install packages inside a restricted session.
- `scripts/check_dependencies.R` verifies that required packages are visible to the active R session.
- `scripts/setup_r_library.R` is the shared R library bootstrap. Source this before package checks in every generated plotting/export script.
- `scripts/install_required_packages.R <pkg1> [pkg2 ...]` installs missing CRAN packages; use `BIOC::<pkg>` for Bioconductor packages.
- `scripts/inspect_data_for_charts.R <data_file> <project_dir>/output/data_profile.md` profiles data and recommends candidate chart families. Summarize its result in the conversation; do not present `data_profile.md` as the main user-facing answer.
- `scripts/export_publication_figures.R <plot_rds> <figures_dir> <name> [width] [height] [dpi] [project_dir]` exports PDF, SVG, TIFF, and web PNG from a saved ggplot object; pass `project_dir` to enforce project-local output.
- `scripts/validate_r_plot.R <script_or_figures_dir>` runs an R script or validates generated figures.
- `scripts/validate_figure_readability.R <plot_rds> <figures_dir> <figure_name> <width_in> <height_in> [project_dir]` checks final-size readability from the ggplot object and rendered preview, writes `output/figure_qa.md`, and fails on serious readability problems.

## Useful Templates

Copy these into `<project_dir>/R/` and adapt column names, labels, statistics, and figure-specific annotations:

- `assets/templates/distribution_compare.R` for boxplot, jittered boxplot, and grouped distribution comparisons.
- `assets/templates/scatter_association.R` for scatter plots with linear, LOESS, or GAM-style smoothing choices.
- `assets/templates/model_diagnostics.R` for linear-model diagnostic panels.
- `assets/templates/multipanel_helpers.R` for reusable patchwork/cowplot layout helpers.
- `assets/templates/multipanel_figure.R` for an evidence-chain multi-panel script scaffold that sources the helpers and expects task-specific panels.

Treat templates as starting points, not fixed outputs. Read `references/chart-index.md` and the relevant detailed chart reference before adapting them for variants such as violin, raincloud, density scatter, coefficient plots, or longitudinal charts. Read `references/design-rules.md` and the selected style reference before finalizing visual choices. Read `references/multipanel-figures.md` before adapting any A/B/C or composite figure.

## Output Standard

For each completed figure, prefer this artifact set:

```text
R/plot_<chart_type>.R
figures/<name>.pdf
figures/<name>.svg
figures/<name>_700dpi.tiff
figures/<name>_web.png
output/data_profile.md
output/figure_rationale.md
output/figure_qa.md
output/session_info.txt
```

These paths are relative to the per-request project directory, not the skill repository root.

`output/data_profile.md` is an internal reproducibility artifact. The recommendation-stage data profile should be written directly in the assistant's reply so the user can choose a chart without opening an extra file.

If the user specifies journal dimensions, fonts, transparent backgrounds, SVG, grayscale, CMYK, or a different DPI, honor that request over the defaults and mention the changed export settings.
