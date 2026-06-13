---
name: r-journal-style-calibrator
description: Plan and implement new journal-specific visual styles for R-plot-0528's r-medical-graphics skill. Use when the user asks to add or calibrate a journal style such as NEJM, JAMA, BMJ, Circulation, Lancet-like, Nature-like, or another publication style; learn style rules from example figures and official guidelines; extend R/ggplot2 theme registries, palettes, typography, number formatting, style routing, and QA; or asks for 期刊风格, 新增某期刊风格, or 从例图学习绘图风格.
---

# R Journal Style Calibrator

Use this skill to add a new journal style to `r-medical-graphics` from evidence: local example figures, official author/artwork guidelines, and the existing style architecture.

## Core Rules

- Treat a journal style as a cross-chart visual system, not as a patch for one figure type.
- Study sources before planning. Inspect example figures one by one and read official guidance before deciding typography, backgrounds, rules, palettes, number formats, and chart-specific overrides.
- Separate published-figure production style from author-submission rules when they differ.
- Make style-specific rules override generic chart references when they conflict.
- Do not modify generic chart-family references such as `forest-plot.md`, `box-plot.md`, `bar-chart.md`, or `survival-curve.md` unless the user explicitly asks for a generic chart-rule change.
- Before implementing a new style, produce a decision-complete plan and wait for explicit user approval unless the current turn already contains an implementation instruction.

## Workflow

1. Load `references/user-input-checklist.md` at the start of a new journal-style request and identify missing inputs.
2. Load `references/style-calibration-workflow.md` before studying examples or guidelines.
3. Inspect the target `r-medical-graphics` structure and existing styles, especially `nature` and `lancet`, before proposing edits.
4. Load `references/r-medical-graphics-integration.md` before writing the implementation plan or editing files.
5. When implementing, keep changes scoped to style routing, style references, theme helpers, templates, recommendation text, and validation artifacts.
6. Validate the skill and generated style with structural checks, R helper checks, smoke plots, export validation, readability QA, and targeted static searches.

## Expected Output

For planning-only turns, return a concise implementation plan covering evidence sources, style profile, integration points, tests, and assumptions.

For implementation turns, update the target `r-medical-graphics` skill, run the planned tests, and report changed files plus validation results. Include unresolved source or guideline gaps instead of guessing silently.

## References

- `references/user-input-checklist.md`: what the user should provide in a new conversation.
- `references/style-calibration-workflow.md`: how to infer a journal style from examples and guidelines.
- `references/r-medical-graphics-integration.md`: exact integration surfaces and no-go files for `r-medical-graphics`.
