# Lancet Style

Use this style when the user asks for `lancet`, The Lancet, 柳叶刀, Lancet-family clinical presentation, clinical trial/profile figures, editable journal artwork, or a clinical epidemiology figure with high legibility and table-plus-estimate discipline.

This guidance is distilled from Lancet example figures and official author/artwork guidance provided during style calibration. Keep the implementation concise and R/ggplot2-focused. Do not copy official PDFs, source images, or private examples into generated project folders or public skill references.

## Visual Rules

- Use a white background, strong black or near-black axes, visible ticks, readable labels, and minimal decoration.
- Prefer solid contrasting coloured lines. Avoid multiple dotted or dashed line styles; use dashed lines only for a reference line or a clearly meaningful comparator.
- Default forest plots, trial profiles, study profiles, and CONSORT-like diagrams to black-and-white unless colour carries explicit scientific meaning.
- Use uppercase bold panel labels `A`, `B`, `C`, placed consistently outside the plotting region when possible.
- Keep serial panels consistent in scale and tick marks when they compare the same measure.
- Use top or in-panel legends for line, scatter, and bar figures. Bottom legends are acceptable for very wide stacked bars.
- Use direct numeric labels, hazard-ratio text blocks, confidence-interval text, and number-at-risk tables when they reduce lookup burden.
- Use pastel fills with dark outlines for bars, boxes, and areas. Use stronger clinical colours for lines and points.
- Prefer 2D graphics. Do not use 3D graphs for ordinary statistical data.
- Axis titles should be bold relative to tick labels.
- Use midline decimal points in Lancet numeric text, including axis labels, direct labels, CI text, P values, and table-like figure text. Use `rmg_format_number()`, `rmg_format_ci()`, `rmg_format_p()`, and `rmg_label_number("lancet")` instead of raw `sprintf()` or `scales::label_number()` for visible numbers.
- Use Arial/Helvetica-like sans-serif typography for figure-internal labels, axes, legends, forest-plot columns, and table-like annotations unless the user explicitly requests another font. Do not use Times New Roman as the default in-figure Lancet artwork font.
- Treat the official 10 pt Times New Roman guidance as manuscript submission guidance for main figure headings, legends, and supplementary material, not as the default for all text inside generated figure artwork.

## Palette

Use stable semantic group colours when the data map naturally to clinical or HDI-like categories:

```text
Low #2C5AA0
Medium #D94632
High #2F6F3E
Very high #58A6C9
NA #B9A5C8
```

Recommended order for general discrete groups:

```text
#2C5AA0, #D94632, #2F6F3E, #58A6C9, #B9A5C8, #E8B69F, #C9DDB2, #C7BDD8, #D2A8A3, #4B8785, #E8A942, #9D9D9D, #F0D94E
```

For filled bars, boxes, and areas, prefer the lighter colours in the sequence and use dark outlines. For lines and points, prefer the stronger blue, red, green, and cyan colours.

## Multi-Panel Rules

- A multi-panel Lancet figure must read as a clinical evidence display, not as a collage.
- Attach dependent elements to their parent panel: risk tables, event-count tables, HR text columns, absolute-risk-difference columns, legends, and colour bars should not receive separate panel labels unless they are scientific panels.
- Align table text, event counts, forest estimates, HR text, and absolute-risk-difference text on shared rows where possible.
- Use shared axes and consistent ticks for serial panels with the same measurement.
- Use uppercase panel labels. Keep labels large enough to remain readable at final journal size.

## Lancet Kaplan-Meier Curve Rules

- Place a number-at-risk table directly below every KM curve.
- Align each number-at-risk value to the center of the corresponding x-axis tick/time point.
- Use black risk-table text by default unless colour has a stated encoding purpose.

## Lancet Forest Plot Rules

- Use a forest plot only when each row has an effect estimate and uncertainty interval, or when they can be computed from a declared model.
- For Lancet-style forest plots, the forest axis must be embedded as a table column, not rendered as a detached side-by-side plot, unless the user explicitly requests a separated layout.
- Choose columns from the analysis: subgroup/level labels, event or sample-size columns, study weights, HR/OR/RR/risk difference/mean difference/SMD with CI, P value, and P for interaction are optional fields, not required template columns.
- Arrange the table so that the effect-estimate/CI section contains the forest axis and the numeric interval value. The forest axis should sit to the left, and the numeric effect estimate with CI should sit immediately to its right.
- The forest-axis ticks and axis labels must stay within the forest-axis column only. They should not extend horizontally across subgroup labels, event/sample-size columns, P-value columns, or other table-header categories.
- Place P value or P for interaction columns at the far right when included.
- Build table text, CI lines, markers, reference line, estimate text, and P-value text on one shared row coordinate system.
- Keep the table body pure white by default. Do not use alternating row bands, shaded subgroup backgrounds, boxed grids, decorative separator rules, or background grid lines.
- Use square markers as the default point-estimate symbol in Lancet-style forest plots
- Keep forest-plot column headers the same font size as the body category labels; use bold weight for headers if needed.
- Column headers must be present and clearly aligned with their columns. The horizontal rule below the column headers must not be omitted.
- Use one table-structure horizontal rule by default: the rule below the column headers. Short underlines are acceptable for grouped headers such as treatment/comparator subcolumns.
- Express subgroup hierarchy with bold labels, indentation, vertical whitespace, and row alignment rather than shading.
- Use a black-and-white style by default: black CI lines, black reference line, and black or white square markers with black outlines. Use colour only when it has explicit scientific meaning.
- Keep the forest axis visually minimal: show the reference line and necessary tick labels only. Do not add panel background lines, dense grid lines, grey plotting backgrounds, or full-table grid lines.
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
- Use `rmg_theme("lancet", base_size = 10)` for ordinary manuscript panels; it defaults to Arial for the actual figure artwork.
- Use `rmg_palette(n, "lancet")` for discrete groups.
- Use `rmg_font_family("lancet")` for English-only Lancet annotation layers such as `geom_text()`, `geom_label()`, and `ggrepel`; this returns Arial for compact Lancet-like in-figure text. Use `rmg_font_family("lancet", role = "submission")` only for manuscript heading/legend or supplementary text requirements. For Chinese/CJK labels, pass an explicit CJK-capable font instead.
- For dense forest plots and table-like panels, finished in-figure text around 7-8 pt is acceptable when readability QA passes; keep bold headers compact and numeric text regular.
- Prefer `svglite` for SVG, `cairo_pdf` for PDF, and `ragg` for TIFF/PNG.
- Keep SVG/PDF text editable wherever feasible. Do not deliberately outline or rasterize text.
- Use final journal dimensions before export instead of scaling after export.

## Official Submission Rules

- Prefer original editable artwork files, especially editable vector outputs.
- Accepted vector outputs include `.eps`, `.ps`, `.pdf`, `.svg`, and `.ai`; this skill exports PDF and SVG by default.
- Text in vector files should remain selectable/editable text, not outlined objects, especially in forest plots with many labels.
- PNG, JPEG, TIFF, and BMP are not vector formats; resaving them as PDF or EPS does not make them editable.
- Bitmap or photographic images must be at least 300 dpi and at least 107 mm wide. The skill keeps its stricter 700 dpi TIFF export.
- Figure headings and legends in manuscript submission material must remain readable at final size. Official guidance mentions 10 pt Times New Roman for main figure headings and 10 pt single-spaced legends; do not apply this as a blanket rule to all in-figure artwork labels.
- If annotated photographic figures are required, keep annotation layers editable where possible or provide separate annotated and clean versions.

## QA

- Check that key elements are legible and not too small at final size.
- Check that Lancet in-figure text uses Arial/Helvetica-like sans-serif typography by default, while any Times New Roman use is limited to explicit manuscript/submission text needs.
- Check that serial panels use consistent scales and ticks when comparing the same measure.
- Reject Lancet forest plots where the forest axis is outside the table as a separate side-by-side panel. The forest axis must be embedded as a table column unless the user explicitly requested separation.
- Reject Lancet forest plots with alternating grey/white row bands, shaded subgroup backgrounds, or extra table separator rules. Each panel should have a white body and only the column-header horizontal rule unless the user explicitly requested more structure.
- Check that forest plots, survival curves, trial profiles, and table-like figure elements keep editable text in SVG/PDF where feasible.
- Check that line types are not overloaded; prefer solid colour contrast unless a dashed comparator/reference has explicit meaning.
- Check that colours remain interpretable and that colour in forest/trial-profile displays has stated scientific meaning.
- Check that bitmap or photographic outputs meet or exceed 300 dpi and 107 mm width; final print TIFF should remain 700 dpi or higher unless the user requests otherwise.
