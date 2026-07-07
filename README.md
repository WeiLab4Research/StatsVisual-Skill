# StatsVisual-Skill

<p align="center">
  <img src="assets/brand/r-medical-graphics-logo.svg" alt="StatsVisual-Skill" width="560">
</p>

**Language:** English | [简体中文](README.zh-CN.md)

StatsVisual-Skill provides Codex skills for publication-ready medical and biostatistical graphics in R. It helps an AI assistant inspect data first, recommend appropriate figure types, generate reproducible plotting code, and export journal-ready artwork. The core plotting skill is still invoked in Codex as `r-medical-graphics`.

## Included Skills

- `r-medical-graphics`: creates data-profile-first medical statistics figures with R.
- `r-journal-style-calibrator`: extends `r-medical-graphics` with journal-specific visual styles based on example figures and author guidance.

## What It Does

- Profiles CSV, TSV, XLSX, and RDS datasets before plotting.
- Recommends a primary single figure, up to two alternatives, and an optional multi-panel figure when complementary analyses are useful.
- Uses a first-turn gate: when data are first provided, the assistant profiles and recommends before writing plotting code.
- Supports `general`, `nature`, `lancet`, `nejm`, `jama`, and `bmj` figure styles.
- Prioritizes polar plots or rose charts for dense categorical numeric summaries with 20 or more categories when a vertical layout would be too tall or label-heavy.
- Exports PDF, editable SVG, high-resolution TIFF, and a compact web preview.
- Records reproducibility artifacts such as the plotting script, data profile, figure rationale, readability QA, and R session information.

## Figure Gallery

The showcase has been rebuilt from the updated `skill测试结果.docx`, preserving all 19 image positions in the same classification order as the Word document. The gallery focuses on three comparisons: four medical journal visual styles, domestic-versus-international model outputs, and skill outputs with or without guidance from *Statistical Graphics and Art*.

### 1. Four Medical Journal Style Differences

This group mainly compares palette choices. In the forest plots, Lancet explicitly uses a black-and-white treatment, while NEJM, JAMA, and BMJ do not impose the same hard requirement. The order follows the Word document.

#### 1. Kaplan-Meier Curves

<table>
  <tr>
    <td width="50%" align="center"><img src="assets/gallery/word-01-km-lancet.png" alt="Lancet KM curve"><br><b>(1) Lancet</b></td>
    <td width="50%" align="center"><img src="assets/gallery/word-02-km-nejm.png" alt="NEJM KM curve"><br><b>(2) NEJM</b></td>
  </tr>
  <tr>
    <td width="50%" align="center"><img src="assets/gallery/word-03-km-jama.png" alt="JAMA KM curve"><br><b>(3) JAMA</b></td>
    <td width="50%" align="center"><img src="assets/gallery/word-04-km-bmj.png" alt="BMJ KM curve"><br><b>(4) BMJ</b></td>
  </tr>
  <tr>
    <td colspan="2" align="center"><img src="assets/gallery/word-05-km-jama-repeat.png" alt="JAMA KM curve repeated in Word"><br><b>(3) JAMA: supplemental image retained from Word</b></td>
  </tr>
</table>

#### 2. Forest Plots

<table>
  <tr>
    <td width="50%" align="center"><img src="assets/gallery/word-06-forest-lancet.png" alt="Lancet forest plot"><br><b>(1) Lancet</b></td>
    <td width="50%" align="center"><img src="assets/gallery/word-07-forest-nejm.png" alt="NEJM forest plot"><br><b>(2) NEJM</b></td>
  </tr>
  <tr>
    <td width="50%" align="center"><img src="assets/gallery/word-08-forest-jama.png" alt="JAMA forest plot"><br><b>(3) JAMA</b></td>
    <td width="50%" align="center"><img src="assets/gallery/word-09-forest-bmj.png" alt="BMJ forest plot"><br><b>(4) BMJ</b></td>
  </tr>
</table>

### 2. Domestic And International Model Outputs

This group uses the exact model labels from Word to compare the domestic LLM `minimax-m3` and the international LLM `chatgpt-5.5` across ROC curves, volcano plots, and rose charts.

#### 1. ROC Curves

<table>
  <tr>
    <td width="50%" align="center"><img src="assets/gallery/word-10-roc-minimax-m3.png" alt="minimax-m3 ROC curves"><br><b>(1) Domestic LLM: minimax-m3</b></td>
    <td width="50%" align="center"><img src="assets/gallery/word-11-roc-chatgpt-55.png" alt="chatgpt-5.5 ROC curves"><br><b>(2) International LLM: chatgpt-5.5</b></td>
  </tr>
</table>

#### 2. Volcano Plots

<table>
  <tr>
    <td width="50%" align="center"><img src="assets/gallery/word-12-volcano-minimax-m3.png" alt="minimax-m3 volcano plots"><br><b>(1) Domestic LLM: minimax-m3</b></td>
    <td width="50%" align="center"><img src="assets/gallery/word-13-volcano-chatgpt-55.png" alt="chatgpt-5.5 volcano plots"><br><b>(2) International LLM: chatgpt-5.5</b></td>
  </tr>
</table>

#### 3. Rose Charts

<table>
  <tr>
    <td width="50%" align="center"><img src="assets/gallery/word-14-rose-minimax-m3.png" alt="minimax-m3 rose chart"><br><b>(1) Domestic LLM: minimax-m3</b></td>
    <td width="50%" align="center"><img src="assets/gallery/word-15-rose-chatgpt-55.png" alt="chatgpt-5.5 rose chart"><br><b>(2) International LLM: chatgpt-5.5</b></td>
  </tr>
</table>

### 3. Skill Outputs With Or Without *Statistical Graphics And Art* Guidance

This group shows how adding the core ideas of *Statistical Graphics and Art* changes grouping, spacing, reference scales, label completeness, and visual hierarchy.

#### 1. Radar Charts

<table>
  <tr>
    <td width="50%" align="center"><img src="assets/gallery/word-16-radar-without-art.png" alt="Radar chart without statistical graphics guidance"><br><b>(1) Without *Statistical Graphics and Art* guidance</b></td>
    <td width="50%" align="center"><img src="assets/gallery/word-17-radar-with-art.png" alt="Radar chart with statistical graphics guidance"><br><b>(2) With *Statistical Graphics and Art* guidance</b></td>
  </tr>
</table>

#### 2. Rose Charts

<table>
  <tr>
    <td width="50%" align="center"><img src="assets/gallery/word-18-rose-without-art.png" alt="Rose chart without statistical graphics guidance"><br><b>(1) Without *Statistical Graphics and Art* guidance</b></td>
    <td width="50%" align="center"><img src="assets/gallery/word-19-rose-with-art.png" alt="Rose chart with statistical graphics guidance"><br><b>(2) With *Statistical Graphics and Art* guidance</b></td>
  </tr>
</table>
## Repository Layout

```text
assets/
  brand/
    r-medical-graphics-logo.svg
    r-medical-graphics-mark.svg
  gallery/
    word-01-km-lancet.png ... word-19-rose-with-art.png
skills/
  StatsVisual-Skill/
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
git clone https://github.com/HaotianJiang056/R-plot-skill.git StatsVisual-Skill
Copy-Item StatsVisual-Skill/skills/StatsVisual-Skill "$env:USERPROFILE/.codex/skills/r-medical-graphics" -Recurse -Force
Copy-Item StatsVisual-Skill/skills/r-journal-style-calibrator "$env:USERPROFILE/.codex/skills/" -Recurse -Force
```

If `CODEX_HOME` is set, copy the folders into `$env:CODEX_HOME/skills/`.

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
Use $r-medical-graphics. I have a CSV and do not know which chart is appropriate. Please inspect it and recommend options first.
```

```text
Use $r-medical-graphics to draw a publication-ready Kaplan-Meier curve with risk table and log-rank P value.
```

```text
Use $r-journal-style-calibrator to add a JAMA-style visual profile to r-medical-graphics from example figures and official guidelines.
```

Even for direct drawing requests, the first response should inspect the data, confirm whether the requested chart is suitable, recommend the best single figure and any optional multi-panel figure, then ask for confirmation before generating R code.

## 课题组诚招博士后研究员

## Acknowledgements

This project was inspired by [Yuan1z0825/nature-skills](https://github.com/Yuan1z0825/nature-skills).

## License

See [LICENSE](LICENSE).