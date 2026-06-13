# Lancet Style

Use this style when the user asks for `lancet`, The Lancet, 柳叶刀, Lancet-family clinical presentation, clinical trial/profile figures, editable journal artwork, or a clinical epidemiology figure with high legibility and table-plus-estimate discipline.

This guidance is distilled from Lancet example figures and official author/artwork guidance provided during style calibration. Keep the implementation concise and R/ggplot2-focused. Do not copy official PDFs, source images, or private examples into generated project folders or public skill references.

## Visual Contract

- Use a white background, strong black or near-black axes, visible ticks, readable labels, and minimal decoration.
- Prefer solid contrasting coloured lines. Avoid multiple dotted or dashed line styles; use dashed lines only for a reference line or a clearly meaningful comparator.
- Default forest plots, trial profiles, study profiles, and CONSORT-like diagrams to black-and-white unless colour carries explicit scientific meaning.
- Use uppercase bold panel labels `A`, `B`, `C`, placed consistently outside the plotting region when possible.
- Keep serial panels consistent in scale and tick marks when they compare the same measure.
- Use top or in-panel legends for line, scatter, and bar figures. Bottom legends are acceptable for very wide stacked bars.
- Use direct numeric labels, hazard-ratio text blocks, confidence-interval text, and number-at-risk tables when they reduce lookup burden.
- Use pastel fills with dark outlines for bars, boxes, and areas. Use stronger clinical colours for lines and points.
- Prefer 2D graphics. Do not use 3D graphs for ordinary statistical data.
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

## Lancet Forest Plot Rules

- For Lancet-style forest plots, the forest axis must be embedded as a table column between count/statistic columns and HR/CI, risk-difference, or P-value text columns.
- Do not render the table and forest plot as separate side-by-side panels, separate table grobs plus a forest ggplot, or patchwork/cowplot subplots unless the user explicitly requests a separated layout.
- Use this default column order: descriptor or subgroup columns, event/sample-size/count columns, embedded forest estimate column, HR/CI text column, then P-value or other statistical text columns.
- Build the table text, CI lines, square markers, reference line, HR/CI text, and P-value text on one shared row coordinate system. Do not merely align independent plot objects after rendering.
- Put column names at the top, then draw a horizontal rule below the column header row across the integrated table width before numeric rows begin.
- For grouped headers such as Intervention/Comparator, draw short underline rules beneath the parent headers and above subcolumns such as Events/Total or Events/Patients.
- Do not use boxed table grids. Use white space, aligned columns, bold group labels, and horizontal header rules for structure.
- Lancet forest plots override generic forest-plot light-band defaults: keep the forest/table body pure white. Do not use alternating grey row bands, shaded group backgrounds, panel background fills, or light body bands unless the user explicitly requests them.
- Use only one table-structure horizontal rule per panel by default: the rule directly under the column headers. Do not add extra horizontal rules under panel labels, analysis blocks, matching/subgroup headings, body rows, or table bottoms.
- Scientific line work is still allowed: CI lines, square markers, the forest x-axis baseline and ticks, and a vertical null-effect reference line do not count as table-structure horizontal rules.
- Express subgroup hierarchy with bold subgroup labels, indentation, vertical whitespace, and row alignment rather than shaded bands or extra separator rules.
- Keep effect estimate columns, event-count columns, HR/CI text, P-value text, and absolute-risk-difference text row-aligned.
- The forest estimate column may have its own x-axis, ticks, reference line, and favour labels, but these must remain inside the table column rather than in a separate panel outside the table.
- Default forest plots, trial profiles, and study profiles to black-and-white unless colour has explicit scientific meaning.
- Use square markers, thin CI lines, a clear vertical reference line, and bottom axis labels or favour arrows when they clarify interpretation.
- Write visible numeric labels with Lancet helpers, for example `rmg_format_ci()` for HR text and `rmg_format_p()` for P-value columns.

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
