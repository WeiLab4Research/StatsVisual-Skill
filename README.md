# R-plot-skill / R 医学统计绘图 Skill

This repository contains two Codex skills for R-based medical and biostatistical figure work:

本仓库包含两个面向 R 医学统计绘图工作的 Codex skills：

- `r-medical-graphics`: inspect data, recommend suitable chart types, generate reproducible R plotting code, and export publication-ready figures.
- `r-journal-style-calibrator`: add or refine journal-specific visual styles for `r-medical-graphics` from example figures and official author/artwork guidance.

## Core Capabilities / 核心能力

`r-medical-graphics` is built around a data-profile-first workflow.

`r-medical-graphics` 的核心流程是先理解数据，再决定图形。

- Profile CSV, TSV, XLSX, and RDS datasets before plotting.
- Stop on the first data-handling turn after profiling and recommendation; plotting starts only after the user chooses a concrete chart option.
- Recommend one primary single figure, up to two alternatives, and an evidence-chain multi-panel figure only when the data support it.
- Support `general`, `nature`, `lancet`, and `nejm` styles.
- Prioritize polar plots or rose charts for dense categorical numeric summaries with `>=20` categories when a vertical chart would be too tall or label-heavy.
- Export the default publication bundle: vector PDF, editable SVG, 700 dpi or higher TIFF, and a web PNG/JPG under 1 MB.
- Save reproducibility artifacts such as the R script, data profile, figure rationale, readability QA, and `sessionInfo()`.

- 在绘图前分析 CSV、TSV、XLSX 和 RDS 数据结构。
- 首轮遇到数据时只做数据画像和图形推荐；只有用户明确选择某个图形方案后才开始写 R 代码和导出图片。
- 默认推荐一个最佳单图、最多两个备选单图；只有数据能支持互补证据链时才推荐组图。
- 支持 `general`、`nature`、`lancet` 和 `nejm` 风格。
- 当分类数值摘要达到 `>=20` 个类别且竖向图过高或标签过密时，优先推荐 polar plot 或 rose chart。
- 默认导出 PDF、可编辑 SVG、700 dpi 或更高 TIFF，以及 1 MB 以内的网页 PNG/JPG。
- 保存 R 脚本、数据画像、图形说明、可读性 QA 和 `sessionInfo()` 等复现材料。

## Repository Layout / 仓库结构

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

The skill package intentionally excludes local R libraries, real datasets, private manuscripts, journal guideline PDFs, generated figures, presentation folders, and temporary project outputs.

本发布包刻意不包含本地 R 包库、真实数据、私有书稿、期刊指南 PDF、生成图片、汇报材料和临时绘图项目输出。

## Install In Codex / 安装到 Codex

Clone this repository, then copy the skill folders into your Codex skills directory.

克隆仓库后，把 skill 文件夹复制到 Codex skills 目录。

PowerShell example:

```powershell
git clone https://github.com/<your-account>/R-plot-skill.git
Copy-Item R-plot-skill/skills/r-medical-graphics "$env:USERPROFILE/.codex/skills/" -Recurse -Force
Copy-Item R-plot-skill/skills/r-journal-style-calibrator "$env:USERPROFILE/.codex/skills/" -Recurse -Force
```

If `CODEX_HOME` is set, copy into `$env:CODEX_HOME/skills/` instead.

如果设置了 `CODEX_HOME`，请复制到 `$env:CODEX_HOME/skills/`。

## Windows R Dependencies / Windows R 依赖

From the repository root, run:

在仓库根目录运行：

```powershell
powershell -ExecutionPolicy Bypass -File skills/r-medical-graphics/scripts/bootstrap_windows_dependencies.ps1
```

By default, R packages are installed into `.r-medical-graphics-library/` under the repository root. This folder is ignored by Git and should not be uploaded.

默认会把 R 包安装到仓库根目录下的 `.r-medical-graphics-library/`。该目录已被 `.gitignore` 忽略，不应上传。

Verify installation:

验证安装：

```powershell
Rscript skills/r-medical-graphics/scripts/check_dependencies.R
```

If the default CRAN mirror is blocked, pass another mirror:

如果默认 CRAN 镜像访问受限，可以指定其他镜像：

```powershell
powershell -ExecutionPolicy Bypass -File skills/r-medical-graphics/scripts/bootstrap_windows_dependencies.ps1 -CranRepo "https://mirrors.tuna.tsinghua.edu.cn/CRAN/"
```

Optional Bioconductor heatmap packages can be checked with:

可选 Bioconductor 热图包可用以下命令检查：

```powershell
Rscript skills/r-medical-graphics/scripts/check_dependencies.R --include-optional
```

## Quick Smoke Test / 快速测试

From the repository root:

在仓库根目录运行：

```powershell
Rscript skills/r-medical-graphics/scripts/create_plot_project.R demo
Copy-Item skills/r-medical-graphics/assets/example_data/example_continuous_by_group.csv demo/data/
Copy-Item skills/r-medical-graphics/assets/plot_template.R demo/R/plot_boxplot.R
$env:R_MEDICAL_GRAPHICS_SKILL = "skills/r-medical-graphics"
Rscript demo/R/plot_boxplot.R demo demo/data/example_continuous_by_group.csv example_boxplot
Rscript skills/r-medical-graphics/scripts/validate_r_plot.R demo/figures
```

All generated files remain under `demo/`, which is ignored by Git.

测试生成的所有文件都会保存在 `demo/` 目录内，并被 Git 忽略。

## Example Prompts / 示例请求

```text
Use $r-medical-graphics. I have a CSV and do not know which chart is appropriate. Please inspect it and recommend options first.
```

```text
请使用 $r-medical-graphics。我有一个 CSV，不确定适合画什么图。请先检查数据并推荐图形，等我选择后再绘图。
```

```text
Use $r-medical-graphics to draw a publication-ready Kaplan-Meier curve with risk table and log-rank P value.
```

```text
Use $r-journal-style-calibrator to add a JAMA-style visual profile to r-medical-graphics from example figures and official guidelines.
```

Even for direct drawing requests, the first response should inspect the data, confirm whether the requested chart is suitable, recommend the best single-figure and any optional multi-panel figure, then ask for confirmation before generating R code.

即使用户直接提出绘图请求，第一轮也应先检查数据、确认图形是否合适、推荐最佳单图和可选组图，然后等待用户确认再生成 R 代码。

## Public Data Policy / 数据与发布规则

Do not commit:

不要提交：

- local R package libraries;
- private manuscripts or raw book chapters;
- real clinical or unpublished datasets;
- WeChat cache files or presentation folders;
- official guideline PDFs or source Office files;
- generated figures, project outputs, or smoke-test folders;
- large binary reference files.

Use synthetic examples and concise rewritten references only.

公开仓库中只使用合成示例数据和经过改写、归纳的知识文件。

## Maintainer Checks / 维护者检查

Run these checks before committing or publishing:

提交或发布前运行：

```powershell
$env:PYTHONUTF8 = "1"
python C:/Users/Joey233qwq/.codex/skills/.system/skill-creator/scripts/quick_validate.py skills/r-medical-graphics
python C:/Users/Joey233qwq/.codex/skills/.system/skill-creator/scripts/quick_validate.py skills/r-journal-style-calibrator

Get-ChildItem -Recurse -File skills/r-medical-graphics -Include *.R | ForEach-Object {
  Rscript -e "parse(file='$($_.FullName.Replace('\\','/'))')"
}

git status --short --ignored
```

Also run a stale-reference search against `skills/` and `README.md` for obsolete private directory names, removed scripts, and outdated chart thresholds. These should return no matches; only `.gitignore` should retain private/generated directory names as ignore rules.

同时对 `skills/` 和 `README.md` 搜索旧私有目录名、已删除脚本和过期图形阈值。结果应为空；只有 `.gitignore` 应保留私有/生成目录名作为忽略规则。

## Publish To GitHub / 上传到 GitHub

This machine has `git` installed but not GitHub CLI. Use the GitHub website first:

本机已安装 `git`，但未安装 GitHub CLI。先在 GitHub 网页操作：

1. Create a new empty repository named `R-plot-skill`.
2. Choose **Private** visibility if access should be limited to specific users.
3. Do not initialize it with README, license, or `.gitignore`.
4. Copy the HTTPS repository URL.

Then from this repository root:

然后在本仓库根目录运行：

```powershell
git remote add origin https://github.com/<your-account>/R-plot-skill.git
git push -u origin main
```

To grant access to selected users, open the GitHub repository page and go to `Settings -> Collaborators`.

如需开放给特定用户，在 GitHub 仓库页面进入 `Settings -> Collaborators` 添加账号。

## License / 许可证

See `LICENSE`.

请见 `LICENSE`。
