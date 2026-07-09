# Statistical Visualization Skill

<p align="center">
  <img src="assets/brand/r-medical-graphics-logo.svg" alt="StatsVisual-Skill" width="560">
</p>

Team:  
开发人员：江昊天，杜文晓，王邦宇  
指导老师：Prof. Yongyue Wei, Peking University  
内部测试: 崔淼、魏翘楚、奚梓玮

**语言：** [English](README.md) | 简体中文

StatsVisual-Skill 提供一组用于 R 医学统计绘图的skill，帮助 AI 助手先检查数据，再推荐合适图形，生成可复现 R 代码，并导出适合论文、投稿和汇报使用的高质量图形。

## Motivation

本项目的绘图灵感主要来源于北京大学公众健康战略研究中心魏永越老师主编的《统计图形与艺术》。我们希望把“信、达、雅”的理念融入医学统计绘图：忠实于数据本身，清楚表达科学发现，并以克制、精致且有秩序的视觉形式呈现证据。

## 包含的 Skills

- `StatsVisual-Skill`：以数据画像为起点，创建医学统计图和生物统计图。
- `r-journal-style-calibrator`：基于期刊例图和作者指南，为 `StatsVisual-Skill` 扩展期刊风格。

## 核心能力

- 在绘图前分析 CSV、TSV、XLSX 和 RDS 数据。
- 推荐一个首选单图、最多两个备选单图；当互补分析有价值时，推荐可选组图。
- 使用首轮推荐门槛：第一次收到数据时，只做数据画像和图形推荐，不直接写绘图代码。
- 支持 `general`、`nature`、`lancet`、`nejm`、`jama` 和 `bmj` 图形风格。
- 当分类数值摘要达到 20 个或更多类别，且竖向布局过高或标签过密时，优先推荐 polar plot 或 rose chart。
- 导出 PDF、可编辑 SVG、高分辨率 TIFF 和网页预览图。
- 保存 R 脚本、数据画像、图形说明、可读性 QA 和 R 会话信息等复现材料。

## 绘图效果展示

skill的绘图效果围绕三组对比展开：四大医学期刊的图形风格差异、国内与国际模型生成结果差异、有无《统计图形与艺术》理论指导下的制图成果差异。

### 一、四大医学期刊风格差异

这一组主要观察四大医学期刊的绘图风格差异：主要体现在配色方面，如森林图中 Lancet 明确采用黑白配色，而 NEJM、JAMA、BMJ 没有这种硬性要求。

#### 1. KM 曲线

<table>
  <tr bgcolor="#ffffff">
    <td width="50%" align="center" valign="bottom" bgcolor="#ffffff"><img src="assets/gallery/journal-km-lancet.png" alt="Lancet KM curve"></td>
    <td width="50%" align="center" valign="bottom" bgcolor="#ffffff"><img src="assets/gallery/journal-km-nejm.png" alt="NEJM KM curve"></td>
  </tr>
  <tr bgcolor="#ffffff">
    <td align="center" bgcolor="#ffffff"><b>（1）Lancet</b></td>
    <td align="center" bgcolor="#ffffff"><b>（2）NEJM</b></td>
  </tr>
  <tr bgcolor="#ffffff">
    <td width="50%" align="center" valign="bottom" bgcolor="#ffffff"><img src="assets/gallery/journal-km-jama.png" alt="JAMA KM curve"></td>
    <td width="50%" align="center" valign="bottom" bgcolor="#ffffff"><img src="assets/gallery/journal-km-bmj.png" alt="BMJ KM curve"></td>
  </tr>
  <tr bgcolor="#ffffff">
    <td align="center" bgcolor="#ffffff"><b>（3）JAMA</b></td>
    <td align="center" bgcolor="#ffffff"><b>（4）BMJ</b></td>
  </tr>
</table>

#### 2. 森林图

<table>
  <tr bgcolor="#ffffff">
    <td width="50%" align="center" valign="bottom" bgcolor="#ffffff"><img src="assets/gallery/journal-forest-lancet.png" alt="Lancet forest plot"></td>
    <td width="50%" align="center" valign="bottom" bgcolor="#ffffff"><img src="assets/gallery/journal-forest-nejm.png" alt="NEJM forest plot"></td>
  </tr>
  <tr bgcolor="#ffffff">
    <td align="center" bgcolor="#ffffff"><b>（1）Lancet</b></td>
    <td align="center" bgcolor="#ffffff"><b>（2）NEJM</b></td>
  </tr>
  <tr bgcolor="#ffffff">
    <td width="50%" align="center" valign="bottom" bgcolor="#ffffff"><img src="assets/gallery/journal-forest-jama.png" alt="JAMA forest plot"></td>
    <td width="50%" align="center" valign="bottom" bgcolor="#ffffff"><img src="assets/gallery/journal-forest-bmj.png" alt="BMJ forest plot"></td>
  </tr>
  <tr bgcolor="#ffffff">
    <td align="center" bgcolor="#ffffff"><b>（3）JAMA</b></td>
    <td align="center" bgcolor="#ffffff"><b>（4）BMJ</b></td>
  </tr>
</table>

### 二、国内外模型绘制效果差异

这一组比较国内 LLM `minimax-m3` 与国外 LLM `chatgpt-5.5` 的绘制结果，分为 ROC 曲线、火山图和玫瑰图。

#### 1. ROC 曲线

<table>
  <tr bgcolor="#ffffff">
    <td width="50%" align="center" valign="bottom" bgcolor="#ffffff"><img src="assets/gallery/model-roc-minimax-m3.png" alt="minimax-m3 ROC curves"></td>
    <td width="50%" align="center" valign="bottom" bgcolor="#ffffff"><img src="assets/gallery/model-roc-chatgpt-55.png" alt="chatgpt-5.5 ROC curves"></td>
  </tr>
  <tr bgcolor="#ffffff">
    <td align="center" bgcolor="#ffffff"><b>（1）国内 LLM：minimax-m3</b></td>
    <td align="center" bgcolor="#ffffff"><b>（2）国外 LLM：chatgpt-5.5</b></td>
  </tr>
</table>

#### 2. 火山图

<table>
  <tr bgcolor="#ffffff">
    <td width="50%" align="center" valign="bottom" bgcolor="#ffffff"><img src="assets/gallery/model-volcano-minimax-m3.png" alt="minimax-m3 volcano plots"></td>
    <td width="50%" align="center" valign="bottom" bgcolor="#ffffff"><img src="assets/gallery/model-volcano-chatgpt-55.png" alt="chatgpt-5.5 volcano plots"></td>
  </tr>
  <tr bgcolor="#ffffff">
    <td align="center" bgcolor="#ffffff"><b>（1）国内 LLM：minimax-m3</b></td>
    <td align="center" bgcolor="#ffffff"><b>（2）国外 LLM：chatgpt-5.5</b></td>
  </tr>
</table>

#### 3. 玫瑰图

<table>
  <tr bgcolor="#ffffff">
    <td width="50%" align="center" valign="bottom" bgcolor="#ffffff"><img src="assets/gallery/model-rose-minimax-m3.png" alt="minimax-m3 rose chart"></td>
    <td width="50%" align="center" valign="bottom" bgcolor="#ffffff"><img src="assets/gallery/model-rose-chatgpt-55.png" alt="chatgpt-5.5 rose chart"></td>
  </tr>
  <tr bgcolor="#ffffff">
    <td align="center" bgcolor="#ffffff"><b>（1）国内 LLM：minimax-m3</b></td>
    <td align="center" bgcolor="#ffffff"><b>（2）国外 LLM：chatgpt-5.5</b></td>
  </tr>
</table>

### 三、有无《统计图形与艺术》思想支撑的 skill 绘图差异

这一组展示 skill 是否增加《统计图形与艺术》的绘图思想作为支撑后，在分组、留白、刻度参考、标签完整性和图形层级上的差异。

#### 1. 雷达图

<table>
  <tr bgcolor="#ffffff">
    <td width="50%" align="center" valign="bottom" bgcolor="#ffffff"><img src="assets/gallery/art-radar-without-guidance.png" alt="Radar chart without statistical graphics guidance"></td>
    <td width="50%" align="center" valign="bottom" bgcolor="#ffffff"><img src="assets/gallery/art-radar-with-guidance.png" alt="Radar chart with statistical graphics guidance"></td>
  </tr>
  <tr bgcolor="#ffffff">
    <td align="center" bgcolor="#ffffff"><b>（1）无《统计图形与艺术》的绘图思想作为支撑</b></td>
    <td align="center" bgcolor="#ffffff"><b>（2）有《统计图形与艺术》的绘图思想作为支撑</b></td>
  </tr>
</table>

#### 2. 玫瑰图

<table>
  <tr bgcolor="#ffffff">
    <td width="50%" align="center" valign="bottom" bgcolor="#ffffff"><img src="assets/gallery/art-rose-without-guidance.png" alt="Rose chart without statistical graphics guidance"></td>
    <td width="50%" align="center" valign="bottom" bgcolor="#ffffff"><img src="assets/gallery/art-rose-with-guidance.png" alt="Rose chart with statistical graphics guidance"></td>
  </tr>
  <tr bgcolor="#ffffff">
    <td align="center" bgcolor="#ffffff"><b>（1）无《统计图形与艺术》的绘图思想作为支撑</b></td>
    <td align="center" bgcolor="#ffffff"><b>（2）有《统计图形与艺术》的绘图思想作为支撑</b></td>
  </tr>
</table>

## 仓库结构

```text
assets/
  brand/
    r-medical-graphics-logo.svg
    r-medical-graphics-mark.svg
    statistical-graphics-art.jpg
  gallery/
    journal-km-lancet.png ... art-rose-with-guidance.png
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

本仓库只包含精简改写后的规则和合成示例数据。研究数据、源材料、生成图形和运行输出请保存在单独的工作目录中。

## 安装

克隆仓库，然后把两个 skill 文件夹复制到目标客户端的 skills 目录。

### Codex

```powershell
git clone https://github.com/HaotianJiang056/R-plot-skill.git StatsVisual-Skill
Copy-Item ".\StatsVisual-Skill\skills\StatsVisual-Skill\*" "$env:USERPROFILE\.codex\skills\StatsVisual-Skill" -Recurse -Force
Copy-Item ".\StatsVisual-Skill\skills\r-journal-style-calibrator\*" "$env:USERPROFILE\.codex\skills\r-journal-style-calibrator" -Recurse -Force
```

如果设置了 `CODEX_HOME`，请把 `$env:USERPROFILE\.codex` 替换为 `$env:CODEX_HOME`。

### CodeBuddy

CodeBuddy 体验版每月提供 500 credits 基础积分，供大家免费使用。

```powershell
git clone https://github.com/HaotianJiang056/R-plot-skill.git StatsVisual-Skill
Copy-Item ".\StatsVisual-Skill\skills\StatsVisual-Skill\*" "$env:USERPROFILE\.codebuddy\skills\StatsVisual-Skill" -Recurse -Force
Copy-Item ".\StatsVisual-Skill\skills\r-journal-style-calibrator\*" "$env:USERPROFILE\.codebuddy\skills\r-journal-style-calibrator" -Recurse -Force
```

## Windows R 环境

在仓库根目录安装推荐的 R 包：

```powershell
powershell -ExecutionPolicy Bypass -File skills/StatsVisual-Skill/scripts/bootstrap_windows_dependencies.ps1
```

验证当前 R 环境：

```powershell
Rscript skills/StatsVisual-Skill/scripts/check_dependencies.R
```

如果默认 CRAN 镜像不可用，可以显式指定镜像：

```powershell
powershell -ExecutionPolicy Bypass -File skills/StatsVisual-Skill/scripts/bootstrap_windows_dependencies.ps1 -CranRepo "https://mirrors.tuna.tsinghua.edu.cn/CRAN/"
```

可选 Bioconductor 热图包可用以下命令检查：

```powershell
Rscript skills/StatsVisual-Skill/scripts/check_dependencies.R --include-optional
```

## 快速测试

在仓库根目录运行：

```powershell
Rscript skills/StatsVisual-Skill/scripts/create_plot_project.R demo
Copy-Item skills/StatsVisual-Skill/assets/example_data/example_continuous_by_group.csv demo/data/
Copy-Item skills/StatsVisual-Skill/assets/plot_template.R demo/R/plot_boxplot.R
$env:R_MEDICAL_GRAPHICS_SKILL = "skills/StatsVisual-Skill"
Rscript demo/R/plot_boxplot.R demo demo/data/example_continuous_by_group.csv example_boxplot
Rscript skills/StatsVisual-Skill/scripts/validate_r_plot.R demo/figures
```

## 示例请求

```text
请使用 $StatsVisual-Skill。我有一个 CSV，不确定适合画什么图。请先检查数据并推荐方案。
```

```text
请使用 $StatsVisual-Skill 绘制出版级 Kaplan-Meier 生存曲线，包含风险表和 log-rank P 值。
```

```text
请使用 $r-journal-style-calibrator，根据期刊例图和官方指南，为 StatsVisual-Skill 新增 JAMA 风格。
```

即使用户直接提出绘图请求，第一次回复也应先检查数据，确认请求图形是否合适，推荐最佳单图和可选组图，然后等待用户确认再生成 R 代码。

## 共建共享声明

我们鼓励大家共同完善、测试和共享这个 skill，让医学统计图形更加规范、清晰和美观。Skill 材料、说明文档、示例和视觉资产均受版权保护；如需引用、转载、改编、再发布或用于公开作品，请提前与开发团队联系。

## 致谢

本项目灵感亦参考 [Yuan1z0825/nature-skills](https://github.com/Yuan1z0825/nature-skills)，但定位有所不同。本项目主要聚焦四大医学期刊（The Lancet、NEJM、JAMA、BMJ）的医学统计绘图原则，并结合《统计图形与艺术》的知识框架，覆盖更丰富的图形类型。同时，在用户初次绘图时，可根据数据结构与统计意图推荐合适的图形绘制方案。

## 招聘启事
课题组现诚聘博士后研究员，欢迎有相关研究背景者申请。详情请见：http://phepr.pku.edu.cn/info/1038/2521.htm。

## Reference

1. 魏永越. 《统计图形与艺术》. 北京: 中国科学技术出版社; 2025.

<p align="center">
  <img src="assets/brand/statistical-graphics-art.jpg" alt="《统计图形与艺术》封面" width="260">
</p>

2. Jambor HK. A checklist for designing and improving the visualization of scientific data. *Nature Cell Biology*. 2025;27(6):879-883.
3. Lin Y, Zhang L, Chen F, Wei Y. Specification of statistical graphics in medical research. *Chinese Journal of Epidemiology*. 2022;43(10):1666-1670.
4. Zhang L, Lin Y, Huang L, Chen F, Wei Y. Essential elements and design principles of statistical graphics in medical research. *Chinese Journal of Epidemiology*. 2023;44(11).

## 许可证

请见 [LICENSE](LICENSE)。