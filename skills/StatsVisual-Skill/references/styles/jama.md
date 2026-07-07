# JAMA Style

Use this style when the user asks for `jama`, JAMA, JAMA Network, Journal of the American Medical Association, clinical research figures, rigorous statistical display, or a restrained editorial medical-journal style.

This guidance combines public JAMA Network author instructions, common JAMA clinical figure conventions, and the local `ggsci` JAMA palette. Treat official author instructions as submission constraints and this file as R/ggplot2 production guidance. Do not copy official pages, PDFs, or source figures into generated project folders.

## Visual Rules

- Use a white background, strong black or near-black axes, visible ticks, and no decorative grid.
- Keep figures quiet and statistical. Avoid large display titles inside the plot unless the user needs a self-contained conference figure.
- Use uppercase bold panel labels `A`, `B`, `C`, placed consistently outside or at the upper-left edge of each panel.
- Prefer clear axis titles with units, denominators, exact interval definitions, and model definitions.
- Use restrained colour. Colour should separate clinically meaningful groups, highlight primary estimates, or support accessibility; do not use colour as decoration.
- Use top or right legends for grouped charts; prefer direct labels when there are only two or three groups and labels do not collide.
- Keep table-like panels aligned by row. Use whitespace and one header rule rather than boxed grid tables.
- Prefer 2D statistical graphics. Do not use 3D bars, shadows, glossy effects, or infographic decoration for manuscript figures.
- Axis titles should be bold relative to tick labels.

## Typography and Numeric Text

- Use Arial or another clean sans-serif font for figure-internal labels, axes, legends, table columns, and annotations unless the user specifies a journal-supplied font requirement.
- Use ordinary decimal points.
- Use en dashes in confidence-interval ranges.
- Format P values compactly and consistently, for example `P<0.001` or `P=0.005`. Avoid excess trailing zeros.
- Show confidence intervals, denominators, model adjustment, and statistical test names in labels, legends, or the figure rationale when they affect interpretation.
- Keep dense table-like figure text readable at final size; reduce columns before allowing unreadably small text.

## Palette

Use the JAMA palette from `ggsci::pal_jama()` through `rmg_palette(n, "jama")`.

Recommended role mapping:

```text
Primary clinical group: first JAMA palette colour
Secondary comparator: second JAMA palette colour
Additional groups: subsequent JAMA palette colours in stable order
Reference/control/context: gray or black
Risk/harm/highlight: use a red or warm colour only when direction is explicit
```

For filled bars, boxes, and areas, use moderate alpha and dark outlines. For lines and points, use saturated palette colours with consistent line widths. Check grayscale legibility when colour encodes a primary comparison.

## Multi-Panel Rules

- A JAMA-style multi-panel figure should read as a tightly edited statistical argument, not a collage.
- Start with the primary clinical result, then add supporting distribution, subgroup, or sensitivity panels.
- Keep shared axes, scales, units, denominators, and encodings consistent across panels.
- Attach dependent elements such as risk tables, legends, colour bars, and model summary text to their parent panel; do not give them separate panel labels unless they are scientific panels.
- Use uppercase panel labels and concise panel titles.
- Avoid overloading a figure with too many subgroup panels; move exploratory panels to supplement-style outputs when needed.

## Chart-Specific Overrides

- Survival and cumulative-incidence figures should include number-at-risk context when it materially affects interpretation.
- For KM curves, place number at risk below the plot, center risk counts under the matching x-axis ticks, right-align and bold `Number at risk` plus group names, and use black risk-table text by default.
- Bar charts should show denominators or uncertainty intervals when displaying rates, proportions, or model summaries.
- Scatter and regression figures should state smoothing/model method and avoid unlabelled trend lines.

## JAMA Forest Plot Rules

- Use a forest plot only when each row has an effect estimate and uncertainty interval, or when these are computed from a declared model.
- Prefer an integrated table-and-estimate display when counts, estimates, CIs, P values, or interaction P values are shown together.
- Choose columns from the analysis: subgroup/level, event count or denominator, effect estimate with CI, P value, and P for interaction are optional fields, not fixed template columns.
- Align table text, CI lines, markers, null-effect reference line, estimate text, and P-value text on one shared row coordinate system.
- Use a white table body, aligned text columns, restrained black or palette-colour CI marks, and a clear null-effect reference line.
- Keep forest-plot column headers the same font size as the body category labels; use bold weight for headers if needed.
- Use whitespace, indentation, and at most subtle row spacing or very light bands for dense subgroup displays. Avoid boxed grids and heavy table-wide rules.
- Reject JAMA forest plots with unclear effect-measure labels, missing CI definitions, detached table/forest alignment, unreadable dense text, or visually overemphasized P values.
- For example,the plot should be arranged as follows:
| **Subgroup / level** | **Treatment** | **Comparator** | **HR (95% CI)** | **HR (95% CI)** | **P interaction** |
|---|---:|---:|:---:|---:|---:|
| **Age** |  |  |  |  | 0·48 |
| &nbsp;&nbsp;<65 years | 86/742 | 112/736 | ───■──── | 0·76 (0·58–0·99) |  |
| &nbsp;&nbsp;≥65 years | 74/658 | 89/662 | ─────■── | 0·84 (0·62–1·13) |  |
| **Sex** |  |  |  |  | 0·71 |
| &nbsp;&nbsp;Male | 96/812 | 121/806 | ───■──── | 0·79 (0·61–1·02) |  |
| &nbsp;&nbsp;Female | 64/588 | 80/592 | ─────■── | 0·81 (0·58–1·12) |  |
|  |  |  | └──0·5──1·0──2·0──┘ |  |  |

## R Implementation

- Source `assets/styles/theme_registry.R` through `assets/theme_medical_graphics.R`.
- Use `rmg_theme("jama", base_size = 10)` for ordinary JAMA-style manuscript panels.
- Use `rmg_palette(n, "jama")` for discrete groups.
- Use `rmg_font_family("jama")` for English-only annotation layers such as `geom_text()`, `geom_label()`, and `ggrepel`; for Chinese/CJK labels, pass an explicit CJK-capable font.
- Use `rmg_format_ci()` and `rmg_format_p()` for visible CI and P-value text.
- Prefer `svglite` for SVG, `cairo_pdf` for PDF, and `ragg` for TIFF/PNG.
- Keep SVG/PDF text editable wherever feasible.

## Official Submission Rules

- Follow current JAMA Network author instructions when the target is final submission; check them again before submission because publisher requirements can change.
- Submit figures as separate figure files when required by the journal workflow.
- Prefer editable vector output for line art and statistical graphics; keep text selectable/editable where feasible.
- Ensure raster artwork meets the journal's current resolution and file-format requirements. This skill's default 700 dpi TIFF is intentionally conservative for print raster export.
- Do not convert low-resolution raster images to PDF/SVG and treat them as vector artwork.
- Keep figure titles, legends, abbreviations, units, and statistical definitions consistent with the manuscript.

## QA

- Check that every plotted estimate has clear scale, unit, and uncertainty definition when applicable.
- Check that P values, CIs, denominators, model adjustment, and subgroup definitions are visible or documented in the rationale.
- Check that forest plots use one shared row coordinate system and clearly label the effect measure, CI definition, and null-effect value.
- Check that panel labels are uppercase, bold, and consistently placed.
- Check that dense tables remain readable and are not reduced below final-size readability.
- Check that colour remains interpretable in grayscale and that controls/reference groups are not visually overemphasized.
- Check that SVG/PDF text remains editable wherever feasible.
