# R-plot-skill

![R Medical Graphics](assets/brand/r-medical-graphics-logo.svg)

**语言：** [English](README.md) | 简体中文

R-plot-skill 提供一组用于 R 医学统计绘图的 Codex skills，帮助 AI 助手先检查数据，再推荐合适图形，生成可复现 R 代码，并导出适合论文、投稿和汇报使用的高质量图形。

## 包含的 Skills

- `r-medical-graphics`：以数据画像为起点，创建医学统计图和生物统计图。
- `r-journal-style-calibrator`：基于期刊例图和作者指南，为 `r-medical-graphics` 扩展期刊风格。

## 核心能力

- 在绘图前分析 CSV、TSV、XLSX 和 RDS 数据。
- 推荐一个首选单图、最多两个备选单图；当互补分析有价值时，推荐可选组图。
- 使用首轮推荐门：第一次收到数据时，只做数据画像和图形推荐，不直接写绘图代码。
- 支持 `general`、`nature`、`lancet` 和 `nejm` 图形风格。
- 当分类数值摘要达到 20 个或更多类别，且竖向布局过高或标签过密时，优先推荐 polar plot 或 rose chart。
- 导出 PDF、可编辑 SVG、高分辨率 TIFF 和网页预览图。
- 保存 R 脚本、数据画像、图形说明、可读性 QA 和 R 会话信息等复现材料。

## 仓库结构

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

本仓库只包含精简改写后的规则和合成示例数据。研究数据、源文档、生成图形和运行输出请保存在单独的工作目录中。

## 安装

克隆仓库，然后把 skill 文件夹复制到 Codex skills 目录。

```powershell
git clone https://github.com/HaotianJiang056/R-plot-skill.git
Copy-Item R-plot-skill/skills/r-medical-graphics "$env:USERPROFILE/.codex/skills/" -Recurse -Force
Copy-Item R-plot-skill/skills/r-journal-style-calibrator "$env:USERPROFILE/.codex/skills/" -Recurse -Force
```

如果设置了 `CODEX_HOME`，请复制到 `$env:CODEX_HOME/skills/`。

## Windows R 环境

在仓库根目录安装推荐的 R 包：

```powershell
powershell -ExecutionPolicy Bypass -File skills/r-medical-graphics/scripts/bootstrap_windows_dependencies.ps1
```

验证当前 R 环境：

```powershell
Rscript skills/r-medical-graphics/scripts/check_dependencies.R
```

如果默认 CRAN 镜像不可用，可以显式指定镜像：

```powershell
powershell -ExecutionPolicy Bypass -File skills/r-medical-graphics/scripts/bootstrap_windows_dependencies.ps1 -CranRepo "https://mirrors.tuna.tsinghua.edu.cn/CRAN/"
```

可选 Bioconductor 热图包可用以下命令检查：

```powershell
Rscript skills/r-medical-graphics/scripts/check_dependencies.R --include-optional
```

## 快速测试

在仓库根目录运行：

```powershell
Rscript skills/r-medical-graphics/scripts/create_plot_project.R demo
Copy-Item skills/r-medical-graphics/assets/example_data/example_continuous_by_group.csv demo/data/
Copy-Item skills/r-medical-graphics/assets/plot_template.R demo/R/plot_boxplot.R
$env:R_MEDICAL_GRAPHICS_SKILL = "skills/r-medical-graphics"
Rscript demo/R/plot_boxplot.R demo demo/data/example_continuous_by_group.csv example_boxplot
Rscript skills/r-medical-graphics/scripts/validate_r_plot.R demo/figures
```

## 示例请求

```text
请使用 $r-medical-graphics。我有一个 CSV，不确定适合画什么图。请先检查数据并推荐方案。
```

```text
请使用 $r-medical-graphics 绘制出版级 Kaplan-Meier 生存曲线，包含风险表和 log-rank P 值。
```

```text
请使用 $r-journal-style-calibrator，根据期刊例图和官方指南，为 r-medical-graphics 新增 JAMA 风格。
```

即使用户直接提出绘图请求，第一次回复也应先检查数据，确认请求图形是否合适，推荐最佳单图和可选组图，然后等待用户确认再生成 R 代码。

## 许可证

请见 [LICENSE](LICENSE)。
