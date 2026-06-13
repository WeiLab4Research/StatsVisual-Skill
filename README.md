# R-plot-skill

![R Medical Graphics](assets/brand/r-medical-graphics-logo.svg)

**Language:** English | [简体中文](README.zh-CN.md)

R-plot-skill provides Codex skills for publication-ready medical and biostatistical graphics in R. It helps an AI assistant inspect data first, recommend appropriate figure types, generate reproducible plotting code, and export journal-ready artwork.

## Included Skills

- `r-medical-graphics`: creates data-profile-first medical statistics figures with R.
- `r-journal-style-calibrator`: extends `r-medical-graphics` with journal-specific visual styles based on example figures and author guidance.

## What It Does

- Profiles CSV, TSV, XLSX, and RDS datasets before plotting.
- Recommends a primary single figure, up to two alternatives, and an optional multi-panel figure when complementary analyses are useful.
- Uses a first-turn gate: when data are first provided, the assistant profiles and recommends before writing plotting code.
- Supports `general`, `nature`, `lancet`, and `nejm` figure styles.
- Prioritizes polar plots or rose charts for dense categorical numeric summaries with 20 or more categories when a vertical layout would be too tall or label-heavy.
- Exports PDF, editable SVG, high-resolution TIFF, and a compact web preview.
- Records reproducibility artifacts such as the plotting script, data profile, figure rationale, readability QA, and R session information.

## Repository Layout

```text
assets/brand/
  r-medical-graphics-logo.svg
  r-medical-graphics-mark.svg
skills/
  r-medical-graphics/
    SKILL.md
    agents/openai.yaml
    assets/
    references/
    scripts/
  r-journal-style-calibrator/
    SKILL.md
    agents/openai.yaml
    references/
```

The repository ships with concise rewritten guidance and synthetic example data. Keep study data, source documents, generated figures, and runtime outputs in separate working folders.

## Installation

Clone the repository and copy the skill folders into your Codex skills directory.

```powershell
git clone https://github.com/HaotianJiang056/R-plot-skill.git
Copy-Item R-plot-skill/skills/r-medical-graphics "$env:USERPROFILE/.codex/skills/" -Recurse -Force
Copy-Item R-plot-skill/skills/r-journal-style-calibrator "$env:USERPROFILE/.codex/skills/" -Recurse -Force
```

If `CODEX_HOME` is set, copy the folders into `$env:CODEX_HOME/skills/`.

## Windows R Setup

From the repository root, install the recommended R packages:

```powershell
powershell -ExecutionPolicy Bypass -File skills/r-medical-graphics/scripts/bootstrap_windows_dependencies.ps1
```

Verify the active R environment:

```powershell
Rscript skills/r-medical-graphics/scripts/check_dependencies.R
```

If the default CRAN mirror is unavailable, pass a mirror explicitly:

```powershell
powershell -ExecutionPolicy Bypass -File skills/r-medical-graphics/scripts/bootstrap_windows_dependencies.ps1 -CranRepo "https://mirrors.tuna.tsinghua.edu.cn/CRAN/"
```

Optional Bioconductor heatmap packages can be checked with:

```powershell
Rscript skills/r-medical-graphics/scripts/check_dependencies.R --include-optional
```

## Quick Smoke Test

From the repository root:

```powershell
Rscript skills/r-medical-graphics/scripts/create_plot_project.R demo
Copy-Item skills/r-medical-graphics/assets/example_data/example_continuous_by_group.csv demo/data/
Copy-Item skills/r-medical-graphics/assets/plot_template.R demo/R/plot_boxplot.R
$env:R_MEDICAL_GRAPHICS_SKILL = "skills/r-medical-graphics"
Rscript demo/R/plot_boxplot.R demo demo/data/example_continuous_by_group.csv example_boxplot
Rscript skills/r-medical-graphics/scripts/validate_r_plot.R demo/figures
```

## Example Prompts

```text
Use $r-medical-graphics. I have a CSV and do not know which chart is appropriate. Please inspect it and recommend options first.
```

```text
Use $r-medical-graphics to draw a publication-ready Kaplan-Meier curve with risk table and log-rank P value.
```

```text
Use $r-journal-style-calibrator to add a JAMA-style visual profile to r-medical-graphics from example figures and official guidelines.
```

Even for direct drawing requests, the first response should inspect the data, confirm whether the requested chart is suitable, recommend the best single figure and any optional multi-panel figure, then ask for confirmation before generating R code.

## License

See [LICENSE](LICENSE).
