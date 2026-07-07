# NEJM Style

Use this style when the user asks for `nejm`, NEJM, New England Journal of Medicine, 新英格兰医学杂志, clinical-trial survival figures, oncology time-to-event figures, or table-like subgroup forest plots matching the local NEJM examples.

This guidance is distilled from NEJM-style example figures provided during style calibration. No official NEJM artwork or author guideline is bundled with this public skill, so treat this as an example-derived production style rather than an official submission specification.

## Visual Rules

- Use a white background, strong black or near-black axes, visible ticks, and no decorative grid.
- Use larger, highly readable clinical typography than compact Nature-style panels. Axis titles and panel headings are usually bold.
- Prefer uppercase bold panel labels such as `A`, `B`, and `C`, usually paired with a short bold panel title.
- Prefer direct labels near curve endpoints for two-arm trial curves. Use detached legends only when direct labels would collide or when more than two groups are shown.
- Use in-panel statistical summaries for key clinical results, such as hazard ratio, confidence interval, and P value.
- Keep colour semantic and restrained. Blue is the usual primary or active-treatment colour; orange, green, red, gray, and black are supporting colours.
- Use black-and-white line types for older or monochrome-style references only when colour is not needed for interpretation.
- Axis titles should be bold relative to tick labels.

## Typography and Numeric Text

- Use Arial or a similar sans-serif font for figure-internal labels, axes, legends, risk tables, forest-plot columns, and annotations.
- Use ordinary decimal points. Do not use Lancet-style midline decimal points.
- Use en dashes in confidence-interval ranges.
- Format P values compactly, for example `P<0.001` or `P=0.005`, and avoid excess trailing zeros.
- Keep risk-table and forest-table text readable at final size; dense table-like panels may be smaller than axis text when readability QA passes.

## Palette

Recommended discrete order:

```text
#1F77B4, #D98C27, #91C75B, #C84A35, #7F7F7F, #222222, #F1F1F1
```

Use blue for a primary intervention or highlighted treatment, orange for a second treatment arm in cardiovascular trial curves, green for an additional oncology comparator or duration encoding, red for discontinuation/risk markers, gray for controls or context, black for monochrome estimates and table text, and light gray for row bands.

## Survival and Time-To-Event Figures

- Attach number-at-risk tables directly below the parent curve panel; do not give risk tables separate panel labels.
- Align number-at-risk values to the center of the corresponding x-axis tick/time point.
- Right-align and bold the `Number at risk` label and the risk-table group names.
- Use black risk-table text by default unless colour has a stated encoding purpose.
- Place hazard ratio, confidence interval, and P value inside the plotting region or in a closely attached right-side summary block.
- Use direct curve labels near the right side when possible.
- Show censor marks when they are part of the survival evidence.
- Keep axes strong and simple; avoid background grid lines.
- For small multiples of clinical endpoints, align axis ranges and ticks when the endpoints are comparable.

## Forest Plot Rules

Reference image: `references/styles/examples/nejm-forest-plot.png`. Use it only as a visual reference; do not copy its data, labels, or exact column order blindly.

- Use a forest plot only when each row has an effect estimate and uncertainty interval, or when they can be computed from a declared model.
- Prefer an integrated table-and-forest layout on one shared row coordinate system.
- Choose columns from the analysis: subgroup/level labels, event or sample-size columns, study weights, HR/OR/RR/risk difference/mean difference/SMD with CI, P value, and P for interaction are optional fields.
- Use shallow alternating light-gray row bands for dense subgroup tables when they improve row tracking; keep bands light enough that CI marks and text remain dominant.
- Use theme-blue or black squares/points, thin CI lines, and a clear null-effect reference line.
- A dashed vertical line may mark the overall estimate or another clinically meaningful reference when the figure needs it.
- Keep forest-plot column headers the same font size as the body category labels; use bold weight for headers if needed.
- Use bold column headers and regular-weight body text. Express subgroup hierarchy with group rows, indentation, and row spacing rather than boxed table grids.
- Do not draw a heavy table-wide rule above the column headers or a boxed/table-grid top border. If a separator is needed, use a subtle local divider.
- Add favour labels with directional arrows only when they clarify interpretation.
- Reject NEJM forest plots with unclear effect measure labels, missing CI definitions, row bands that overpower the data, or table/forest components that do not share row alignment.
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

## Multi-Panel Rules

- Clinical multi-panel figures may use thin horizontal or vertical divider lines, especially when each panel contains its own risk table or statistical summary.
- Dependent elements such as risk tables, summary tables, legends, and colour keys do not receive separate panel labels unless they are independent scientific panels.
- Mixed oncology figures may combine survival curves, swimmer or duration-of-response panels, and summary tables when each panel contributes different clinical evidence.
- Keep repeated encodings stable across panels; do not remap the same treatment arm to different colours.

## R Implementation

- Source `assets/styles/theme_registry.R` through `assets/theme_medical_graphics.R`.
- Use `rmg_theme("nejm", base_size = 11)` for ordinary NEJM-style panels.
- Use `rmg_palette(n, "nejm")` for discrete groups.
- Use `rmg_font_family("nejm")` for English-only annotation layers such as `geom_text()`, `geom_label()`, and `ggrepel`; for Chinese/CJK labels, pass an explicit CJK-capable font.
- Use `rmg_format_ci()` and `rmg_format_p()` for visible CI and P-value text.
- Prefer `svglite` for SVG, `cairo_pdf` for PDF, and `ragg` for TIFF/PNG.
- Keep SVG/PDF text editable wherever feasible.

## Official Submission Rules

- No official local NEJM guideline files are currently available.
- Do not invent official font, file-format, dimension, or DPI requirements for NEJM.
- Continue to follow the skill's general export requirements: editable PDF/SVG, high-resolution TIFF, web image under 1 MB, and final dimensions chosen before export.
- If official NEJM guidance is provided later, revise this section to separate official submission constraints from example-derived production style.

## QA

- Check that axes and tick marks are strong enough to read at final size.
- Check that direct curve labels do not collide with data or censor marks.
- Check that risk tables are attached to the correct parent panel and aligned to x-axis time points.
- Check that forest plots use one shared row coordinate system rather than visually aligned independent plot objects when an integrated table is required.
- Check that alternating row bands are shallow and do not overpower CI marks or text.
- Reject NEJM forest plots with a full-width horizontal rule above the column headers or a boxed/table-grid top border.
- Check that panel labels are uppercase, bold, and consistently placed.
- Check that SVG/PDF text remains editable wherever feasible.
