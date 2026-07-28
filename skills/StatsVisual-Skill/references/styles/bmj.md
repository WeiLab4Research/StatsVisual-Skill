# BMJ Style

Use this style when the user asks for `bmj`, BMJ, The BMJ, British Medical Journal, pragmatic clinical research, public-health figures, health-services research figures, or a reader-friendly medical journal style.

## Visual Rules

- Use a white background, clear axes, visible ticks, and minimal grid lines.
- Prefer plain, reader-friendly evidence displays over dense editorial styling.
- Keep titles and subtitles concise. The figure itself should communicate the result without becoming a poster.
- Use uppercase bold panel labels `A`, `B`, `C` for multi-panel manuscript figures.
- Use direct labels when they reduce legend lookup, especially for two or three time-series or survival groups.
- Prefer readable labels, explicit denominators, and plain-language annotation over visual compression.
- Use restrained colours and enough contrast for accessibility. Avoid red/green-only encodings and decorative colour ramps.
- Avoid boxed panel backgrounds, shadows, 3D graphics, and heavy table grids.
- Axis titles should be bold relative to tick labels.

## Typography and Numeric Text

- Use Arial or another clean sans-serif font for figure-internal labels, axes, legends, table columns, and annotations unless the user specifies another journal requirement.
- Use ordinary decimal points.
- Use en dashes in confidence-interval ranges.
- Format P values compactly when they are displayed, but avoid making P values the only visual message.
- Prefer absolute risks, denominators, rates, and confidence intervals when they are available; BMJ-style clinical figures should be interpretable by readers outside the narrow methods audience.
- Keep annotation text short and close to the data it explains.

## Palette

Use the BMJ palette from `ggsci::pal_bmj()` through `rmg_palette(n, "bmj")`.

Recommended role mapping:

```text
Primary result or exposure: first BMJ palette colour
Comparator: second BMJ palette colour
Additional groups: subsequent BMJ palette colours in stable order
Context/reference/control: gray or black
Harm or warning: warm colour only when direction is explicit
```

For fills, use moderate alpha with dark outlines. For lines and points, use saturated palette colours and avoid mixing colour with many line types unless the encoding is necessary for print or accessibility.

## Multi-Panel Rules

- A BMJ-style multi-panel figure should tell a practical clinical or public-health story.
- Put the clinically interpretable result first, then add subgroup, time, or sensitivity context.
- Use shared legends and stable encodings across panels.
- Attach dependent risk tables, legends, colour bars, and explanatory notes to their parent panel.
- Avoid cramming many secondary analyses into one main figure; choose fewer panels with clearer labels.
- Use plain-language panel titles when they help readers understand endpoints, denominators, or populations.

## BMJ Forest Plot Rules

- Use a forest plot only when each row has an effect estimate and uncertainty interval, or when these are computed from a declared model.
- Prefer a reader-friendly integrated table-and-estimate layout with aligned rows, a clear null-effect reference line, and readable CI labels.
- Choose columns from the analysis: subgroup/level, denominator or sample size, absolute risk or event count when available, effect estimate with CI, P value, and P for interaction are optional fields.
- Align table text, CI lines, markers, null-effect reference line, estimate text, and P-value text on one shared row coordinate system.
- Keep forest-plot column headers the same font size as the body category labels; use bold weight for headers if needed.
- Use plain labels, explicit denominators, restrained colours, and a white table body. Use subtle row spacing only when it improves tracking in dense displays.
- Avoid P-value-only emphasis; the estimate direction, CI width, denominator, and clinical meaning should remain easy to read.
- Reject BMJ forest plots with unclear denominators, missing CI definitions, detached table/forest alignment, heavy boxed grids, unreadable dense text, or P values that visually dominate the effect estimates.
- For example，the plot should be arranged as follows:
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
- Use `rmg_theme("bmj", base_size = 10.5)` for ordinary BMJ-style manuscript panels.
- Use `rmg_palette(n, "bmj")` for discrete groups.
- Use `rmg_font_family("bmj")` for English-only annotation layers such as `geom_text()`, `geom_label()`, and `ggrepel`; for Chinese/CJK labels, pass an explicit CJK-capable font.
- Use `rmg_format_ci()` and `rmg_format_p()` for visible CI and P-value text.
- Prefer `svglite` for SVG, `cairo_pdf` for PDF, and `ragg` for TIFF/PNG.
- Keep SVG/PDF text editable wherever feasible.

## QA

- Check that a non-specialist clinical reader can identify the population, outcome, denominator, and comparison.
- Check that absolute risks, sample sizes, rates, and CIs are present when they are central to the message.
- Check that forest plots clearly show denominators or sample sizes when available and keep estimates, CIs, and P values aligned on shared rows.
- Check that panel labels are uppercase, bold, and consistently placed.
- Check that legends and direct labels do not compete with the data.
- Check that colour contrast remains accessible and interpretable in grayscale.
- Check that SVG/PDF text remains editable wherever feasible.
