# Style Calibration Workflow

Use this workflow to turn a journal's examples and guidelines into a reusable R style.

## 1. Ground In Existing Architecture

- Read the target skill's `SKILL.md`, style router, design rules, existing style references, and theme registry.
- Study existing mature styles such as `nature` and `lancet` to match file structure and implementation style.
- Identify no-go files before planning, especially generic chart-family references that the user wants untouched.

## 2. Study Evidence Before Deciding

- Read official local guidelines first when available.
- If the user requests web lookup, use official journal or publisher sources first and report access failures clearly.
- Inspect example figures one by one. Record repeated visual patterns rather than overfitting to a single chart.
- Separate chart-specific mechanics from journal-wide style rules.

## 3. Extract The Style Profile

Build a concise style profile with these dimensions:

- Use cases and aliases.
- Typography: figure-internal font, submission/document font, text sizes, bolding, panel labels.
- Number formatting: decimal mark, thousands separators, P values, CIs, HR/OR/RR text, inequality thresholds.
- Backgrounds and rules: white or shaded body, grid visibility, table rules, panel dividers, axis lines, ticks.
- Palette: default discrete order, semantic colours, grayscale rules, fill/outline contrast.
- Legends and direct labels: allowed positions, when to prefer inline labels.
- Multi-panel logic: panel labels, shared scales, dependent tables, legends, and figure plans.
- Chart-specific overrides: forest plots, survival curves, trial profiles, table-like displays, heatmaps, and other repeated patterns.
- Official submission rules: vector formats, editability, DPI, dimensions, font requirements, and prohibited practices.
- QA reject conditions: concrete failures that should not pass validation.

## 4. Resolve Conflicts

- If published figures and author guidelines differ, treat published figures as production-style evidence and official guidelines as submission constraints.
- If generic chart guidance conflicts with a journal style, document the journal-specific override in the style reference and skill entrypoint.
- If evidence is inconsistent, prefer the pattern repeated across the most journal-specific and most recent examples.
- Do not infer a hard rule from one figure unless the user marks it as a must-match reference.

## 5. Plan Before Implementation

The plan must state:

- Style id, aliases, and public interface changes.
- Source basis: example folder, guideline files, and any web sources.
- Files to edit and files explicitly not to edit.
- R helper additions or changes.
- Required smoke plot and validation steps.
- Assumptions for unresolved typography, palette, or statistical-format questions.

## 6. Implement After Approval

- Add routing and recommendation text first.
- Add the style reference with the same structure as existing styles.
- Extend the theme registry and templates conservatively.
- Reuse existing helpers and patterns before adding new abstractions.
- Run structural validation, helper checks, smoke plots, export validation, readability QA, SVG text checks, and no-go-file checks.
