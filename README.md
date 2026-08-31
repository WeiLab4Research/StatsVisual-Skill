# Statistical Visualization Skill

<p align="center">
  <img src="assets/brand/statsvisual.png" alt="StatsVisual-Skill" width="100%">
  <br><br>
  <a href="LICENSE"><img alt="License" src="https://img.shields.io/badge/license-MIT-2ea44f"></a>
  <a href="#installation"><img alt="Install" src="https://img.shields.io/badge/install-CodeBuddy%20%7C%20Codex-111827"></a>
  <a href="#chart-types-overview"><img alt="Chart Types" src="https://img.shields.io/badge/Chart%20Types-16-0ea5e9"></a>
  <a href="README.zh-CN.md"><img alt="Language" src="https://img.shields.io/badge/language-中文%20%7C%20English-1f6feb"></a>
</p>

## Team

| Role | Members |
|------|---------|
| **Developer** | Haotian Jiang · Wenxiao Du · Bangyu Wang |
| **Supervisor & Sponsor** | Prof. Yongyue Wei, Peking University |
| **Tester** | Miao Cui · Qiaochu Wei · Ziwei Xi |

## Motivation

StatsVisual-Skill is a collection of AI skills for medical statistical graphics. It is designed to help AI assistants first inspect the data, then recommend appropriate chart types, generate reproducible code, and export high-quality figures suitable for manuscripts, journal submissions, and academic presentations.Its visualization philosophy is mainly inspired by Statistical Graphics and Art, edited by Professor Yongyue Wei from the Peking University Center for Public Health and Epidemic Preparedness & Response. We aim to integrate the principles of “faithfulness, clarity, and elegance” into medical statistical visualization: remaining faithful to the data itself, clearly communicating scientific findings, and presenting evidence in a restrained, refined, and well-structured visual form, so that each figure combines scientific rigor, readability, and aesthetic quality.

## Chart Types Overview

This skill covers **16 statistical chart families**. All figure examples are from *Statistical Graphics and Art*.

| Chart Type | Preview | Description |
|------------|---------|-------------|
| **1. Bar Chart** | <table cellpadding="0" cellspacing="0" border="0" style="border-collapse:collapse;border-spacing:0;"><tr style="line-height:0;"><td style="padding:0;line-height:0;font-size:0;"><img style="display:block;margin:0;border:0;" src="skills/StatsVisual-Skill/assets/gallery/bar/basic_bar.png" width="90"></td><td style="padding:0;line-height:0;font-size:0;"><img style="display:block;margin:0;border:0;" src="skills/StatsVisual-Skill/assets/gallery/bar/grouped_bar.png" width="90"></td><td style="padding:0;line-height:0;font-size:0;"><img style="display:block;margin:0;border:0;" src="skills/StatsVisual-Skill/assets/gallery/bar/stacked_bar.png" width="90"></td><td style="padding:0;line-height:0;font-size:0;"><img style="display:block;margin:0;border:0;" src="skills/StatsVisual-Skill/assets/gallery/bar/polar_bar.png" width="90"></td></tr></table> | Compare categorical data with rectangular bars; supports grouped, stacked, and polar variants. |
| **2. Line Chart** | <table cellpadding="0" cellspacing="0" border="0" style="border-collapse:collapse;border-spacing:0;"><tr style="line-height:0;"><td style="padding:0;line-height:0;font-size:0;"><img style="display:block;margin:0;border:0;" src="skills/StatsVisual-Skill/assets/gallery/line/time_series.png" width="90"></td><td style="padding:0;line-height:0;font-size:0;"><img style="display:block;margin:0;border:0;" src="skills/StatsVisual-Skill/assets/gallery/line/area.png" width="90"></td><td style="padding:0;line-height:0;font-size:0;"><img style="display:block;margin:0;border:0;" src="skills/StatsVisual-Skill/assets/gallery/line/step.png" width="90"></td><td style="padding:0;line-height:0;font-size:0;"><img style="display:block;margin:0;border:0;" src="skills/StatsVisual-Skill/assets/gallery/line/stream.png" width="90"></td></tr></table> | Display trends and changes over continuous intervals; includes time series, area, step, and stream graphs. |
| **3. Pie Chart** | <table cellpadding="0" cellspacing="0" border="0" style="border-collapse:collapse;border-spacing:0;"><tr style="line-height:0;"><td style="padding:0;line-height:0;font-size:0;"><img style="display:block;margin:0;border:0;" src="skills/StatsVisual-Skill/assets/gallery/pie/pie.png" width="90"></td><td style="padding:0;line-height:0;font-size:0;"><img style="display:block;margin:0;border:0;" src="skills/StatsVisual-Skill/assets/gallery/pie/doughnut.png" width="90"></td><td style="padding:0;line-height:0;font-size:0;"><img style="display:block;margin:0;border:0;" src="skills/StatsVisual-Skill/assets/gallery/pie/rose.png" width="90"></td><td style="padding:0;line-height:0;font-size:0;"><img style="display:block;margin:0;border:0;" src="skills/StatsVisual-Skill/assets/gallery/pie/nested.png" width="90"></td></tr></table> | Show proportions of a whole; supports doughnut, rose, and nested pie variants. |
| **4. Histogram** | <table cellpadding="0" cellspacing="0" border="0" style="border-collapse:collapse;border-spacing:0;"><tr style="line-height:0;"><td style="padding:0;line-height:0;font-size:0;"><img style="display:block;margin:0;border:0;" src="skills/StatsVisual-Skill/assets/gallery/histogram/basic_histogram.png" width="90"></td><td style="padding:0;line-height:0;font-size:0;"><img style="display:block;margin:0;border:0;" src="skills/StatsVisual-Skill/assets/gallery/histogram/ridgeline.png" width="90"></td><td style="padding:0;line-height:0;font-size:0;"><img style="display:block;margin:0;border:0;" src="skills/StatsVisual-Skill/assets/gallery/histogram/spiral.png" width="90"></td><td style="padding:0;line-height:0;font-size:0;"><img style="display:block;margin:0;border:0;" src="skills/StatsVisual-Skill/assets/gallery/histogram/pyramid.png" width="90"></td></tr></table> | Visualize the distribution of continuous variables; includes ridgeline, spiral, and pyramid variants. |
| **5. Dot Plot** | <table cellpadding="0" cellspacing="0" border="0" style="border-collapse:collapse;border-spacing:0;"><tr style="line-height:0;"><td style="padding:0;line-height:0;font-size:0;"><img style="display:block;margin:0;border:0;" src="skills/StatsVisual-Skill/assets/gallery/dot/cleveland.png" width="90"></td><td style="padding:0;line-height:0;font-size:0;"><img style="display:block;margin:0;border:0;" src="skills/StatsVisual-Skill/assets/gallery/dot/lollipop.png" width="90"></td><td style="padding:0;line-height:0;font-size:0;"><img style="display:block;margin:0;border:0;" src="skills/StatsVisual-Skill/assets/gallery/dot/interaction_lollipop.png" width="90"></td><td style="padding:0;line-height:0;font-size:0;"><img style="display:block;margin:0;border:0;" src="skills/StatsVisual-Skill/assets/gallery/dot/manhattan.png" width="90"></td></tr></table> | Present values with dots along a common axis; includes Cleveland dot, lollipop, interaction lollipop, and Manhattan plots. |
| **6. Box Plot** | <table cellpadding="0" cellspacing="0" border="0" style="border-collapse:collapse;border-spacing:0;"><tr style="line-height:0;"><td style="padding:0;line-height:0;font-size:0;"><img style="display:block;margin:0;border:0;" src="skills/StatsVisual-Skill/assets/gallery/box/box.png" width="90"></td><td style="padding:0;line-height:0;font-size:0;"><img style="display:block;margin:0;border:0;" src="skills/StatsVisual-Skill/assets/gallery/box/violin.png" width="90"></td><td style="padding:0;line-height:0;font-size:0;"><img style="display:block;margin:0;border:0;" src="skills/StatsVisual-Skill/assets/gallery/box/beeswarm.png" width="90"></td><td style="padding:0;line-height:0;font-size:0;"><img style="display:block;margin:0;border:0;" src="skills/StatsVisual-Skill/assets/gallery/box/raincloud.png" width="90"></td></tr></table> | Summarize data distribution through quartiles; includes violin, beeswarm, and raincloud variants. |
| **7. Scatter Plot** | <table cellpadding="0" cellspacing="0" border="0" style="border-collapse:collapse;border-spacing:0;"><tr style="line-height:0;"><td style="padding:0;line-height:0;font-size:0;"><img style="display:block;margin:0;border:0;" src="skills/StatsVisual-Skill/assets/gallery/scatter/scatter.png" width="90"></td><td style="padding:0;line-height:0;font-size:0;"><img style="display:block;margin:0;border:0;" src="skills/StatsVisual-Skill/assets/gallery/scatter/bubble.png" width="90"></td><td style="padding:0;line-height:0;font-size:0;"><img style="display:block;margin:0;border:0;" src="skills/StatsVisual-Skill/assets/gallery/scatter/smooth.png" width="90"></td><td style="padding:0;line-height:0;font-size:0;"><img style="display:block;margin:0;border:0;" src="skills/StatsVisual-Skill/assets/gallery/scatter/volcano.png" width="90"></td></tr></table> | Reveal relationships between two continuous variables; supports bubble, smooth scatter, and matrix layouts. |
| **8. Heatmap** | <table cellpadding="0" cellspacing="0" border="0" style="border-collapse:collapse;border-spacing:0;"><tr style="line-height:0;"><td style="padding:0;line-height:0;font-size:0;"><img style="display:block;margin:0;border:0;" src="skills/StatsVisual-Skill/assets/gallery/heatmap/basic_heatmap.png" width="90"></td><td style="padding:0;line-height:0;font-size:0;"><img style="display:block;margin:0;border:0;" src="skills/StatsVisual-Skill/assets/gallery/heatmap/contour_line.png" width="90"></td><td style="padding:0;line-height:0;font-size:0;"><img style="display:block;margin:0;border:0;" src="skills/StatsVisual-Skill/assets/gallery/heatmap/filled_contour.png" width="90"></td><td style="padding:0;line-height:0;font-size:0;"><img style="display:block;margin:0;border:0;" src="skills/StatsVisual-Skill/assets/gallery/heatmap/calendar.png" width="90"></td></tr></table> | Encode values with color intensity in a grid; includes contour lines, filled contours, and calendar layouts. |
| **9. Ternary Plot** | <table cellpadding="0" cellspacing="0" border="0" style="border-collapse:collapse;border-spacing:0;"><tr style="line-height:0;"><td style="padding:0;line-height:0;font-size:0;"><img style="display:block;margin:0;border:0;" src="skills/StatsVisual-Skill/assets/gallery/ternary/basic_ternary.png" width="90"></td><td style="padding:0;line-height:0;font-size:0;"><img style="display:block;margin:0;border:0;" src="skills/StatsVisual-Skill/assets/gallery/ternary/density.png" width="90"></td><td style="padding:0;line-height:0;font-size:0;"><img style="display:block;margin:0;border:0;" src="skills/StatsVisual-Skill/assets/gallery/ternary/interpolation.png" width="90"></td><td style="padding:0;line-height:0;font-size:0;"><img style="display:block;margin:0;border:0;" src="skills/StatsVisual-Skill/assets/gallery/ternary/interval.png" width="90"></td></tr></table> | Display compositional data on a triangular coordinate system; supports density, interpolation, and interval variants. |
| **10. Q-Q Plot** | <table cellpadding="0" cellspacing="0" border="0" style="border-collapse:collapse;border-spacing:0;"><tr style="line-height:0;"><td style="padding:0;line-height:0;font-size:0;"><img style="display:block;margin:0;border:0;" src="skills/StatsVisual-Skill/assets/gallery/qq/qq.png" width="90"></td><td style="padding:0;line-height:0;font-size:0;"><img style="display:block;margin:0;border:0;" src="skills/StatsVisual-Skill/assets/gallery/qq/pp.png" width="90"></td><td style="padding:0;line-height:0;font-size:0;"><img style="display:block;margin:0;border:0;" src="skills/StatsVisual-Skill/assets/gallery/qq/ladder_qq.png" width="90"></td><td style="padding:0;line-height:0;font-size:0;"><img style="display:block;margin:0;border:0;" src="skills/StatsVisual-Skill/assets/gallery/qq/symmetry.png" width="90"></td></tr></table> | Compare two probability distributions through quantiles; includes P-P, ladder Q-Q, and symmetry tests. |
| **11. Probability Distribution** | <table cellpadding="0" cellspacing="0" border="0" style="border-collapse:collapse;border-spacing:0;"><tr style="line-height:0;"><td style="padding:0;line-height:0;font-size:0;"><img style="display:block;margin:0;border:0;" src="skills/StatsVisual-Skill/assets/gallery/distribution/normal.png" width="90"></td><td style="padding:0;line-height:0;font-size:0;"><img style="display:block;margin:0;border:0;" src="skills/StatsVisual-Skill/assets/gallery/distribution/beta.png" width="90"></td><td style="padding:0;line-height:0;font-size:0;"><img style="display:block;margin:0;border:0;" src="skills/StatsVisual-Skill/assets/gallery/distribution/binomial.png" width="90"></td><td style="padding:0;line-height:0;font-size:0;"><img style="display:block;margin:0;border:0;" src="skills/StatsVisual-Skill/assets/gallery/distribution/gamma.png" width="90"></td></tr></table> | Visualize theoretical probability density functions; covers normal, beta, binomial, and gamma distributions. |
| **12. Smoothing Curve** | <table cellpadding="0" cellspacing="0" border="0" style="border-collapse:collapse;border-spacing:0;"><tr style="line-height:0;"><td style="padding:0;line-height:0;font-size:0;"><img style="display:block;margin:0;border:0;" src="skills/StatsVisual-Skill/assets/gallery/smoothing_curve/lowess_smooth.png" width="90"></td><td style="padding:0;line-height:0;font-size:0;"><img style="display:block;margin:0;border:0;" src="skills/StatsVisual-Skill/assets/gallery/smoothing_curve/lowess_regression.png" width="90"></td><td style="padding:0;line-height:0;font-size:0;"><img style="display:block;margin:0;border:0;" src="skills/StatsVisual-Skill/assets/gallery/smoothing_curve/lowess.png" width="90"></td></tr></table> | Fit a smooth trend through noisy data using LOWESS and other nonparametric methods. |
| **13. Linear Regression** | <table cellpadding="0" cellspacing="0" border="0" style="border-collapse:collapse;border-spacing:0;"><tr style="line-height:0;"><td style="padding:0;line-height:0;font-size:0;"><img style="display:block;margin:0;border:0;" src="skills/StatsVisual-Skill/assets/gallery/linear_regression/linear.png" width="90"></td><td style="padding:0;line-height:0;font-size:0;"><img style="display:block;margin:0;border:0;" src="skills/StatsVisual-Skill/assets/gallery/linear_regression/bands.png" width="90"></td><td style="padding:0;line-height:0;font-size:0;"><img style="display:block;margin:0;border:0;" src="skills/StatsVisual-Skill/assets/gallery/linear_regression/ellipse.png" width="90"></td><td style="padding:0;line-height:0;font-size:0;"><img style="display:block;margin:0;border:0;" src="skills/StatsVisual-Skill/assets/gallery/linear_regression/surface.png" width="90"></td></tr></table> | Model linear relationships with confidence bands, ellipses, and response surfaces. |
| **14. Nonlinear Regression** | <table cellpadding="0" cellspacing="0" border="0" style="border-collapse:collapse;border-spacing:0;"><tr style="line-height:0;"><td style="padding:0;line-height:0;font-size:0;"><img style="display:block;margin:0;border:0;" src="skills/StatsVisual-Skill/assets/gallery/nonlinear_regression/polynomial.png" width="90"></td><td style="padding:0;line-height:0;font-size:0;"><img style="display:block;margin:0;border:0;" src="skills/StatsVisual-Skill/assets/gallery/nonlinear_regression/sigmoid.png" width="90"></td><td style="padding:0;line-height:0;font-size:0;"><img style="display:block;margin:0;border:0;" src="skills/StatsVisual-Skill/assets/gallery/nonlinear_regression/convex_concave.png" width="90"></td><td style="padding:0;line-height:0;font-size:0;"><img style="display:block;margin:0;border:0;" src="skills/StatsVisual-Skill/assets/gallery/nonlinear_regression/quantile.png" width="90"></td></tr></table> | Capture curved relationships through polynomial, sigmoid, convex-concave, and quantile models. |
| **15. Regression Diagnostics** | <table cellpadding="0" cellspacing="0" border="0" style="border-collapse:collapse;border-spacing:0;"><tr style="line-height:0;"><td style="padding:0;line-height:0;font-size:0;"><img style="display:block;margin:0;border:0;" src="skills/StatsVisual-Skill/assets/gallery/regression_diagnostics/residual.png" width="90"></td><td style="padding:0;line-height:0;font-size:0;"><img style="display:block;margin:0;border:0;" src="skills/StatsVisual-Skill/assets/gallery/regression_diagnostics/cook.png" width="90"></td><td style="padding:0;line-height:0;font-size:0;"><img style="display:block;margin:0;border:0;" src="skills/StatsVisual-Skill/assets/gallery/regression_diagnostics/leverage.png" width="90"></td><td style="padding:0;line-height:0;font-size:0;"><img style="display:block;margin:0;border:0;" src="skills/StatsVisual-Skill/assets/gallery/regression_diagnostics/influence.png" width="90"></td></tr></table> | Assess model assumptions with residual plots, Cook's distance, leverage, and influence metrics. |
| **16. Survival Curve** | <table cellpadding="0" cellspacing="0" border="0" style="border-collapse:collapse;border-spacing:0;"><tr style="line-height:0;"><td style="padding:0;line-height:0;font-size:0;"><img style="display:block;margin:0;border:0;" src="skills/StatsVisual-Skill/assets/gallery/survival/km.png" width="90"></td><td style="padding:0;line-height:0;font-size:0;"><img style="display:block;margin:0;border:0;" src="skills/StatsVisual-Skill/assets/gallery/survival/comparison.png" width="90"></td><td style="padding:0;line-height:0;font-size:0;"><img style="display:block;margin:0;border:0;" src="skills/StatsVisual-Skill/assets/gallery/survival/adjusted.png" width="90"></td><td style="padding:0;line-height:0;font-size:0;"><img style="display:block;margin:0;border:0;" src="skills/StatsVisual-Skill/assets/gallery/survival/risk_table.png" width="90"></td></tr></table> | Analyze time-to-event data with Kaplan-Meier curves, group comparisons, and adjusted survival estimates. |

## Included Skills

- `StatsVisual-Skill`: creates data-profile-first medical statistics figures and biostatistical graphics with R.
- `r-journal-style-calibrator`: extends `StatsVisual-Skill` with journal-specific visual styles based on example figures and author guidance.

## What It Does

- Profiles CSV, TSV, XLSX, and RDS datasets before plotting.
- Recommends a primary single figure, up to two alternatives, and an optional multi-panel figure when complementary analyses are useful.
- Uses a first-turn gate: when data are first provided, the assistant profiles and recommends before writing plotting code.
- Supports `general`, `nature`, `lancet`, `nejm`, `jama`, and `bmj` figure styles.
- Exports PDF, editable SVG, high-resolution TIFF, and a compact web preview.
- Records reproducibility artifacts such as the plotting script, data profile, figure rationale, readability QA, and R session information.

## Repository Layout

```text
assets/
  brand/
    statistical-graphics-art.jpg
    statsvisual.png
skills/
  StatsVisual-Skill/
    SKILL.md
    agents/
    assets/
      gallery/
      templates/
    references/
    scripts/
  r-journal-style-calibrator/
    SKILL.md
    agents/
    references/
LICENSE
README.md
README.zh-CN.md
```

## Installation

Clone the repository and copy both skill folders into the skills directory for your target client. To update later, enter the cloned repository, run `git pull`, then re-run the corresponding copy commands.

### Codex

```powershell
git clone https://github.com/HaotianJiang056/R-plot-skill.git StatsVisual-Skill
New-Item -ItemType Directory -Force "$env:USERPROFILE\.codex\skills\StatsVisual-Skill" | Out-Null
Copy-Item ".\StatsVisual-Skill\skills\StatsVisual-Skill\*" "$env:USERPROFILE\.codex\skills\StatsVisual-Skill" -Recurse -Force
New-Item -ItemType Directory -Force "$env:USERPROFILE\.codex\skills\r-journal-style-calibrator" | Out-Null
Copy-Item ".\StatsVisual-Skill\skills\r-journal-style-calibrator\*" "$env:USERPROFILE\.codex\skills\r-journal-style-calibrator" -Recurse -Force
```

If `CODEX_HOME` is set, replace `$env:USERPROFILE\.codex` with `$env:CODEX_HOME`.

### CodeBuddy

The CodeBuddy trial provides 500 base credits each month for free use.

```powershell
git clone https://github.com/HaotianJiang056/R-plot-skill.git StatsVisual-Skill
New-Item -ItemType Directory -Force "$env:USERPROFILE\.codebuddy\skills\StatsVisual-Skill" | Out-Null
Copy-Item ".\StatsVisual-Skill\skills\StatsVisual-Skill\*" "$env:USERPROFILE\.codebuddy\skills\StatsVisual-Skill" -Recurse -Force
New-Item -ItemType Directory -Force "$env:USERPROFILE\.codebuddy\skills\r-journal-style-calibrator" | Out-Null
Copy-Item ".\StatsVisual-Skill\skills\r-journal-style-calibrator\*" "$env:USERPROFILE\.codebuddy\skills\r-journal-style-calibrator" -Recurse -Force
```

## Windows R Setup

From the repository root, install the recommended R packages:

```powershell
powershell -ExecutionPolicy Bypass -File skills/StatsVisual-Skill/scripts/bootstrap_windows_dependencies.ps1
```

Verify the active R environment:

```powershell
Rscript skills/StatsVisual-Skill/scripts/check_dependencies.R
```

If the default CRAN mirror is unavailable, pass a mirror explicitly:

```powershell
powershell -ExecutionPolicy Bypass -File skills/StatsVisual-Skill/scripts/bootstrap_windows_dependencies.ps1 -CranRepo "https://mirrors.tuna.tsinghua.edu.cn/CRAN/"
```

Optional Bioconductor heatmap packages can be checked with:

```powershell
Rscript skills/StatsVisual-Skill/scripts/check_dependencies.R --include-optional
```

## Quick Smoke Test

From the repository root:

```powershell
Rscript skills/StatsVisual-Skill/scripts/create_plot_project.R demo
Copy-Item skills/StatsVisual-Skill/assets/example_data/example_continuous_by_group.csv demo/data/
Copy-Item skills/StatsVisual-Skill/assets/plot_template.R demo/R/plot_boxplot.R
$env:R_MEDICAL_GRAPHICS_SKILL = "skills/StatsVisual-Skill"
Rscript demo/R/plot_boxplot.R demo demo/data/example_continuous_by_group.csv example_boxplot
Rscript skills/StatsVisual-Skill/scripts/validate_r_plot.R demo/figures
```

## Example Prompts

```text
Use $StatsVisual-Skill. I have a CSV and do not know which chart is appropriate. Please inspect it and recommend options first.
```

```text
Use $StatsVisual-Skill to draw a publication-ready Kaplan-Meier curve with risk table and log-rank P value.
```

```text
Use $r-journal-style-calibrator to add a JAMA-style visual profile to StatsVisual-Skill from example figures and official guidelines.
```

Even for direct drawing requests, the first response should inspect the data, confirm whether the requested chart is suitable, recommend the best single figure and any optional multi-panel figure, then ask for confirmation before generating R code.

## Community And Use

We welcome everybody to co-build, test, and share improvements to this skill. The skill materials, documentation, examples, and visual assets are protected by copyright. If you plan to cite, reproduce, adapt, redistribute, or use these materials in a public work, please contact the development team in advance.

## Acknowledgements

This project was inspired by [Yuan1z0825/nature-skills](https://github.com/Yuan1z0825/nature-skills),but follows a different focus. It centers on medical statistical visualization principles from four leading medical journals—The Lancet, NEJM, JAMA, and BMJ—and is structured around the framework of Statistical Graphics and Art. It covers a broader range of chart types and helps users choose suitable visualizations based on their data structure and statistical intent.

## Recruitment Notice
The research group is seeking postdoctoral researchers. Applicants with relevant research backgrounds are encouraged to apply. For details, please visit: http://phepr.pku.edu.cn/info/1038/2521.htm

## References

1. Wei Y. *Statistical Graphics and Art*. Beijing: China Science and Technology Press; 2025.

<p align="center">
  <img src="assets/brand/statistical-graphics-art.jpg" alt="Statistical Graphics and Art cover" width="260">
</p>

2. Jambor HK. A checklist for designing and improving the visualization of scientific data. *Nature Cell Biology*. 2025;27(6):879-883.
3. Lin Y, Zhang L, Chen F, Wei Y. Specification of statistical graphics in medical research. *Chinese Journal of Epidemiology*. 2022;43(10):1666-1670.
4. Zhang L, Lin Y, Huang L, Chen F, Wei Y. Essential elements and design principles of statistical graphics in medical research. *Chinese Journal of Epidemiology*. 2023;44(11).

## License

See [LICENSE](LICENSE).