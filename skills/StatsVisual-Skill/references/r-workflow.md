# R Workflow

## Project Layout

Create or use one explicit per-request project directory. Do not use the skill repository root or the current working directory as the output root. Create this structure under `<project_dir>`:

```text
<project_dir>/
  data/
  R/
  figures/
```

Write the plot script in `<project_dir>/R/plot_<chart_type>.R`. Keep figure files in `<project_dir>/figures/`. Summarize the data profile and figure explanation directly in the assistant reply.

Do not enter the script-writing or export workflow on the first data-handling turn. First-turn work is limited to project setup, data copy, data inspection, and chart recommendation. Start this R workflow only after the user has replied with a concrete chart choice from the recommendation.

## Script Shape

Use this order:

1. Define `project_dir` explicitly and create output directories under it.
2. Source `scripts/setup_r_library.R`, call `rmg_prepare_library()`/`rmg_ensure_packages()`, then load required packages.
3. Read data with explicit encoding and column checks.
4. Clean factor levels, dates, missing values, and units.
5. Build the plot object.
6. Export PDF, SVG, 700 dpi TIFF, and web image.

Use `assets/plot_template.R` as the default starting point for a new figure script. When the task matches a common implementation, copy and adapt one of these starters into `<project_dir>/R/`:

- `assets/templates/multipanel/multipanel_helpers.R` for reusable patchwork/cowplot layout helpers.
- `assets/templates/multipanel/multipanel_figure.R` for planned multi-panel script scaffolds.

Before adapting a template, read `references/chart-index.md`, `references/design-rules.md`, the selected style reference, and the selected chart family's detailed reference so the copied script reflects the right variant, layers, packages, style, and QA notes.
For multi-panel figures, also read `references/multipanel-figures.md` before coding the layout, because panel order, relative size, and shared legends should follow the evidence hierarchy.

When adapting the template, require command-line arguments for `project_dir`, `data_file`, and `figure_name`; do not default to writing in the caller's current directory.

When calling `scripts/export_publication_figures.R`, pass the final `project_dir` argument so the exporter refuses paths outside the project directory.

## Export Defaults

- PDF: vector, default width `7`, height `5`, units inches.
- SVG: editable vector output for layout and journal revision workflows.
- TIFF: 700 dpi or higher, LZW compression when the device supports it.
- Web image: PNG by default, target under 1 MB; reduce pixel dimensions before sacrificing readability.
- Use `ragg` for high-quality raster output. If `ragg` is missing, install it automatically before export. Do not fall back to lower-quality devices unless the user explicitly asks for a no-install workflow.

## Dependency Pattern

Always check local libraries before attempting CRAN/Bioconductor access. Generated scripts should not write a fresh ad hoc package installer unless the helper script is unavailable. The default pattern is:

```r
skill_dir <- Sys.getenv("R_MEDICAL_GRAPHICS_SKILL", unset = "skills/StatsVisual-Skill")
source(file.path(skill_dir, "scripts", "setup_r_library.R"), local = TRUE)
rmg_ensure_packages(c("ggplot2", "ragg"), project_dir = project_dir, skill_dir = skill_dir)
```

`rmg_ensure_packages()` first adds visible repository, project, configured, and user libraries to `.libPaths()`. Only if `requireNamespace()` still reports packages missing should it attempt installation. This prevents false "missing ggplot2" reports when `.r-medical-graphics-library/` already contains the packages.

For Bioconductor packages, call `scripts/install_required_packages.R BIOC::<package>` or install `BiocManager` first and then use `BiocManager::install()`.

Recommended package groups:

- Core: `ggplot2`, `dplyr`, `tidyr`, `readr`, `readxl`, `tibble`, `purrr`, `scales`
- Common data cleaning: `forcats`, `stringr`, `lubridate`, `broom`
- Composition: `patchwork`, `cowplot`
- Labels and annotation: `ggrepel`, `ggpubr`
- Distribution and association: `ggridges`, `ggbeeswarm`, `ggdist`, `ggpointdensity`, `GGally`, `ggExtra`
- Palettes: `RColorBrewer`, `viridis`, `viridisLite`, `ggsci`
- Survival: `survival`, `survminer`, `ggsurvfit`
- Heatmaps and matrices: `pheatmap`, `corrplot`, `ComplexHeatmap`, `circlize`
- Forest/regression summaries: `forestplot`, `broom`
- Ternary: `ggtern`
- Export: `ragg`, `svglite`, `magick`

Template package notes:

- Distribution comparisons may need `ggbeeswarm`, `ggdist`, or `lvplot` when moving beyond the default jittered boxplot.
- Dense scatter plots may need `ggpointdensity`, `hexbin`, or `GGally`.
- Model diagnostics use `broom` and `patchwork`; coefficient or forest variants may also need `forestplot`.
- Multi-panel figures use `patchwork`; mixed image/table/legend assemblies may also need `cowplot`, `grid`, or `gridExtra`.

If package installation fails because of network, repository, compiler, or file permission problems, stop and report the exact failure. Do not substitute a lower-quality or non-R plotting route without user approval.

If Windows reports `740` or "requested operation requires elevation", treat it as a library path or process elevation problem, not a CRAN mirror problem. First use the repository-local `.r-medical-graphics-library/`, then fall back to `<project_dir>/R-library`. Do not request administrator elevation unless the user explicitly wants system-wide installation.

## Restricted Network Environments

In Codex or CI environments, CRAN/Bioconductor access may be blocked until the assistant requests network approval. If `install.packages()` or `BiocManager::install()` fails with DNS, timeout, SSL, proxy, repository, or permission errors:

1. Retry the same install command with the environment's approved network/escalation mechanism.
2. Keep the intended package set unchanged.
3. If approval is denied or the install still fails, stop and report the exact error.
4. Do not generate base R, lower-resolution, or non-R output as a substitute for the requested publication figure.

## Robustness

- Validate that required columns exist before plotting.
- Convert date columns explicitly with `as.Date()` or `lubridate` when available.
- Preserve raw data; create cleaned copies.
- Set seeds for sampling or jitter when reproducibility matters.
- Write short comments only for non-obvious statistical or export decisions.