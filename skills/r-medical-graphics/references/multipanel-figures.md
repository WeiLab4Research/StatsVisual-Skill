# Multi-Panel Medical Figures

Use this reference when one publication figure must combine multiple panels into a clinical or statistical evidence chain. A multi-panel figure is not a collage and not a default `patchwork` grid. It is a designed page: the scientific hierarchy, panel geometry, legends, tables, whitespace, and export format must be specified before plotting.

This is an extended publication workflow built on the manuscript-derived plotting style; it is not a separate RawText chapter. Keep the book-style foundation first: `theme_pubr`/`theme_egraphics`, `ggsci`-style restrained palettes, medical examples, clear axes, concise legends, and explicit statistical interpretation.

For high-stakes manuscript figures, the target style is a restrained research figure: asymmetric when needed, editable, and built around a clear evidence hierarchy rather than equal-sized chart tiles.

## First Define The Figure Specification

Before writing code, define:

- **Core conclusion**: the single message the full figure supports.
- **Primary evidence**: the panel that carries the main result.
- **Supporting evidence**: model adjustment, subgroup analysis, sensitivity analysis, diagnostics, image quantification, or risk context.
- **Reviewer risk**: the most likely challenge a reviewer would raise.
- **Panel map**: `A`, `B`, `C`, etc., with one sentence per scientific panel.
- **Dependent elements**: risk tables, legends, color keys, scale bars, inset plots, or annotation strips that belong to a panel and must not receive their own panel letter.
- **Shared encodings**: group colors, line types, symbols, time units, axis scales, transformations, and denominators.
- **Layout specification**: final width/height, panel coordinates or relative widths/heights, dominant panel, legend axis, gutters, and reserved margins.
- **Output specification**: editable SVG plus PDF, 700 dpi TIFF, web PNG, rationale, session info, and whether panels need independent source files.

Remove a panel if it does not make the conclusion more defensible. Remove a legend, table, or annotation if it repeats information without improving interpretation.

## Recommendation After Data Profiling

Keep the original skill path: inspect data first, recommend a single figure first, then offer a multi-panel option only when the profile supports complementary evidence. Do not recommend a multi-panel figure just because several plot types are possible.

In the recommendation reply, use this structure:

```text
Recommended single figure: <chart>, because <data-profile reason>.
Alternatives: <up to two single figures, or none>.
Optional multi-panel figure: <yes/no>.
Core conclusion: <one sentence>.
Panel map: A <primary evidence>; B <supporting evidence>; C <validation/robustness>, if available.
Dependent elements: <risk table/legend/inset/scale bar belongs to which panel>.
Evidence chain: <why these panels together are stronger than one plot>.
Use when: <manuscript need>.
Limitation: <missing field, weak sample size, unavailable statistic, or interpretation caveat>.
Expected outputs: SVG, PDF, 700 dpi TIFF, web PNG, rationale, session info.
```

If the data are insufficient for a multi-panel figure, say `Multi-panel not recommended` and name the missing pieces, such as no grouping variable, no time/event fields, no uncertainty estimates, no validation cohort, no feature identifiers, or no model results.

## Data Profile Triggers

Use these profile patterns to decide whether to offer a multi-panel option:

- **Continuous outcome plus grouping variable**: offer `A: distribution with raw-data context; B: effect size with CI`; add `C: subgroup or sensitivity` only if a meaningful stratifier exists.
- **Repeated measures, dose, or time trend plus grouping variable**: offer `A: trend or trajectory; B: group-specific effect estimate; C: endpoint distribution or responder summary`.
- **Survival time plus event indicator**: offer `A: Kaplan-Meier or cumulative incidence with embedded risk table; B: Cox forest plot or adjusted estimate; C: subgroup, PH-check, or biomarker distribution only when it adds distinct evidence`.
- **High-dimensional biomarker, omics, or MR-like screening results**: offer `A: overview heatmap/correlation/volcano; B: focused effect estimates for selected features; C: selected-feature distribution, sensitivity, or validation`.
- **Prediction model output**: offer `A: ROC/PR or discrimination metric; B: calibration curve; C: decision curve or subgroup performance`, keeping cohorts clearly labeled.
- **Image-derived measurements**: offer `A: representative image plate; B: quantitative summary; C: adjusted estimate or validation`, and require scale-bar/crop/contrast notes when applicable.

Do not offer a multi-panel figure when all proposed panels would show the same evidence in different styles. Replace redundant panels with effect size, uncertainty, sensitivity, validation, or drop the multi-panel option.

## Evidence Patterns

### Primary Outcome Plus Support

Use for clinical trials, cohort studies, intervention studies, and biomarker outcome papers.

Typical structure:

```text
A: primary outcome distribution, trend, survival curve, or heatmap
B: adjusted effect estimate, coefficient plot, or model fit
C: subgroup analysis, sensitivity result, or safety summary
D: secondary endpoint or robustness check
```

Rules:

- Make the primary panel visually dominant through size, position, or axis detail.
- Supporting panels should be quieter and should not compete with the main result.
- Use the same group colors across all panels.
- Do not use A, B, and C as three visual styles of the same result unless each panel answers a different scientific question.

### Survival Evidence Chain

Use when Kaplan-Meier output alone is not enough.

Typical structure:

```text
A: Kaplan-Meier or cumulative incidence curve
   attached element: number-at-risk table aligned under A, no separate panel letter
B: Cox forest plot or adjusted effect estimate
C: proportional-hazards check, subgroup effect, biomarker distribution, or sensitivity result
```

Rules:

- Treat the risk table as part of Panel A. It must not receive its own panel tag.
- Align the risk table x positions exactly to the survival curve x-axis breaks.
- Keep curve colors, risk-table row labels, and legend labels identical.
- Ensure time units and event coding are consistent.
- State censoring, log-rank test if used, CI bands, and Cox covariates in the rationale.
- If event rates are low, prefer cumulative incidence/event probability over survival probability when it improves visual discrimination.

### Biomarker Or Omics Evidence Chain

Use when a high-dimensional pattern needs focused validation.

Typical structure:

```text
A: heatmap, correlation matrix, or feature pattern
B: volcano/scatter plot highlighting candidate features
C: selected-feature boxplot, violin plot, or effect estimate
D: model-adjusted or validation result
```

Rules:

- Declare heatmap scaling, clustering distance, and annotations.
- Do not make the heatmap the only evidence if individual features drive the conclusion.
- Keep highlighted features consistent across panels.
- Use a separate annotation strip or compact legend axis for feature groups rather than crowding the heatmap body.

### Model Development Or Prediction Study

Use for risk models, classifiers, diagnostics, and prediction tools.

Typical structure:

```text
A: ROC/AUC, PR curve, or discrimination metric
B: calibration curve
C: decision curve, net benefit, or clinical utility
D: subgroup performance or diagnostic residual/check plot
```

Rules:

- Keep train/test/validation cohorts clearly labeled.
- Do not mix internal and external validation panels without explicit labels.
- Use identical metric definitions across panels.
- Put model legends in one shared legend axis when colors represent cohorts or methods across panels.

### Image Plate Plus Quantification

Use for pathology, microscopy, radiology, spatial maps, gels, or blots.

Typical structure:

```text
A: representative image plate
B: quantitative summary of the image-derived measure
C: adjusted estimate, subgroup summary, or validation result
```

Rules:

- Include scale bars when spatial interpretation matters.
- Record crop, contrast adjustment, pseudo-coloring, and quantification linkage in the rationale.
- Pair representative images with quantitative evidence whenever possible.
- Use dark backgrounds only inside image panels, not across the entire figure.

## Publication Layout Specification

Before coding a multi-panel figure, write a layout specification. This is separate from the scientific figure specification.

Required fields:

- **Canvas**: width, height, unit, target journal orientation, and whether supplementary versions are needed.
- **Panel geometry**: explicit coordinates or relative areas for every scientific panel.
- **Dominant panel**: which panel gets the largest visual area and why.
- **Nature page archetype**: for Nature-style figures, declare whether the page is a clinical triptych, image plate plus quantification, schematic-led composite, asymmetric mixed-modality figure, dense categorical panel, or balanced quantitative grid.
- **Dependent elements**: risk tables, legends, scale bars, insets, and annotation strips with their parent panel.
- **Gutters**: horizontal and vertical spacing, kept smaller inside panel groups and larger between evidence stages.
- **Typography**: base font size, axis font size, panel tag size, title size, and whether fonts must remain editable in SVG.
- **Color system**: one semantic palette, named mapping, color-blind check, and grayscale survival check.
- **Export set**: editable SVG, PDF, TIFF, and web PNG from the same final object when possible.

Example:

```text
Canvas: 183 mm x 120 mm.
Geometry: A occupies left 58% width and top 72% height; A-risk table sits below A within the same panel group; B occupies upper right; C occupies lower right.
Dominant panel: A because time-to-event evidence is the primary result.
Dependent elements: risk table belongs to A; one shared legend strip above A/B; no separate tag for the risk table.
Gutters: 5 mm between A and right column, 4 mm between B and C, 2 mm between A curve and risk table.
Typography: 7 pt axis text, 8 pt axis titles, 10 pt panel tags, editable SVG text.
Color system: fixed group palette used for curves, risk table labels, and forest plot exposure terms.
```

## Layout Archetypes

Use archetypes as starting points, then convert them into an explicit layout specification.

### Asymmetric Primary Result

Use when one panel is scientifically dominant.

```text
AAAA | BB
AAAA | BB
aaaa | CC
```

`A` is the primary panel. `aaaa` is a dependent element such as risk table, compact table, or annotation strip and receives no panel tag. `B` and `C` are supporting panels.

Good for survival figures, primary endpoint plus adjusted model, or image plus quantification.

### Quantitative Grid

Use only when panels have genuinely similar visual weight.

```text
A | B
C | D
```

Good for parallel endpoints, diagnostic metrics, repeated biomarkers, or subgroup estimates. Avoid this when one result is clearly primary.

### Clinical Triptych

Use when columns represent parallel cohorts/outcomes and rows represent evidence stages.

```text
Top row:    trends or primary outcomes
Middle row: effect estimates or subgroup effects
Bottom row: response, safety, or summary proportions
```

Keep columns semantically parallel. Legends should be shared by row or by entire figure, not repeated in every panel.

### Schematic-Led Composite

Use when a study design, cohort flow, workflow, mechanism, or model pipeline must be understood first.

```text
AAAA
BCCD
```

Use the top panel to define symbols, groups, and workflow direction. Supporting panels validate the schematic.

For Nature-style pages, let the schematic or workflow occupy roughly 45-60% of the figure height when it is needed to understand the claim. Reuse the schematic's physical, material, cohort, or mechanism colors in the supporting quantitative plots instead of switching to unrelated generic method colors. If zoom callouts are used, repeat one accent convention consistently, such as the same dashed outline family. Add a real-world photograph, representative sample, device view, or experimental snapshot when scale validation is part of the argument. Quantitative support panels should be smaller, cleaner, and less saturated than the schematic so they validate rather than compete.

### Image Plus Quantification

Use when image evidence is dominant.

```text
AAA
BBC
```

Images should be tightly aligned and quantified in adjacent panels. Scale bars are dependent elements, not scientific panels.

For Nature-style image plates, use black only inside the image panel region, not across the whole page. Pair grayscale context with one or two meaningful accent channels, commonly cyan/magenta for fluorescence-like overlays. Keep crops, view boxes, scale bars, gutters, and row/column geometry consistent across repeated image tiles. Use high-contrast white scale bars and channel labels on dark image tiles. Put row labels and channel labels directly on the image plate when possible; avoid detached legends for fixed channels.

### Shared Legend Strip

Use when panels share groups, treatments, methods, cohorts, or time points.

```text
LLLL
AABB
AACC
```

`L` is a legend strip or annotation strip, not a panel. It should use less space than a scientific panel and should not interrupt the evidence chain.

### Dense Categorical Panel

Use rarely in this medical R skill, but consider it for high-dimensional categorical maps, tissue-state composition grids, phase/category maps, or repeated stacked-area/stacked-bar panels where the categories are intrinsic and must be read across the full page.

```text
A | B | C
D | E | F
```

Rules:

- Direct-label regions or stable categories when a detached mega-legend would force excessive lookup.
- Reuse the exact same axis limits, panel geometry, category order, and denominator across the full grid.
- Use hatching, texture, line type, or boundary marks when adjacent fills are close in luminance or must survive grayscale printing.
- Use this archetype only when each panel represents a comparable categorical landscape. If one result is primary, switch to an asymmetric layout instead.

### Nature-Style Asymmetric Mixed-Modality

Use when the figure combines a biologically or clinically central panel with smaller supporting plots, for example a circular genomics panel with validation plots, a representative image with quantification and model estimates, or a study schema with outcome summaries.

```text
AAA | B
AAA | C
D   | E
```

Rules:

- Do not force equal panel sizes. Let the biologically or clinically central panel dominate.
- Place smaller panels around the hero panel to answer narrower support questions.
- Keep a tight reused color mapping across modalities, such as `baseline / follow-up / highlight / neutral`, `wave 1 / wave 2 / wave 3`, or `case / control / reference`.
- Use whitespace and alignment to signal grouping. Do not add decorative frames just to separate modalities.
- Keep axis-heavy plots visually quieter than schematics, image plates, or the central biological panel.

## Nature-Style Modality Rules

Use these rules only when the selected style is `nature` or when the user asks for a Nature-family / high-impact journal main figure. They refine the layout archetypes above; they do not replace the figure specification.

### Clinical Quantitative Figures

- Use a dark baseline or reference series, then restrained warm/cool hues for follow-up, intervention, or subgroup series.
- For clinical triptychs, keep columns semantically parallel. If one column is an outcome domain, adjacent columns should reuse the same row logic rather than introducing unrelated panels.
- Put longitudinal legends outside the data region, usually above the row or in a shared strip.
- In forest plots, use a dashed reference line and pale group bands; group bands must stay visually subordinate to estimates and confidence intervals.
- Compact bottom-row summaries can use binary bars, stacked percentages, responder rates, or safety/event summaries when they add a distinct evidence layer.

### Imaging, Pathology, Microscopy, And Spatial Panels

- Use black backgrounds only for the image tiles or plate region. Keep the overall page background white unless the journal or image type requires otherwise.
- Use grayscale context plus a small number of biologically meaningful highlight channels.
- State crop, contrast, pseudo-color, scale calibration, and quantification linkage in the rationale.
- Keep representative images paired with quantitative evidence whenever possible.

### Mechanism, Material, Device, Or Workflow Pages

- Derive the support-plot palette from the schematic, sample, material, cohort, or mechanism vocabulary.
- Use one repeated callout style for zooms or important transitions.
- Reserve at least one support panel for measured validation when the schematic is conceptual.
- Avoid making the schematic decorative; it must define groups, flow, mechanism, or experimental setup used by the other panels.

### Genomics, Biomarker, And Systems Pages

- Use neutral grey scaffolds plus one or two biologically meaningful highlight families, often a red family and a blue family.
- Keep highlighted genes, features, clusters, or states consistent across heatmaps, scatter plots, distributions, and model panels.
- Use annotation strips or compact legend axes for feature groups rather than crowding the main heatmap body.
- If a heatmap shows the landscape, add a focused effect, association, or validation panel when individual features drive the conclusion.

### What Not To Copy Blindly From Nature Examples

- Do not use a bright multi-hue palette just because one physical-science figure used many fills. That works only when categories are intrinsic, directly labeled, and separable in print.
- Do not place an entire Nature-style figure on a black background. Black is for image plates and selected raster regions, not ordinary statistical charts.
- Do not force a legend into every panel. Prefer direct labels or one shared legend strip when categories are stable across panels.
- Do not make all panels equal size unless they have equal evidential weight.
- Do not let web-preview constraints drive the print layout; design at final journal size and create the web image afterward.

## Assembly Rules

### Preferred Build Strategy

- Build the figure from a layout specification, not from the number of plots.
- Prefer explicit coordinate control for high-stakes multi-panel figures: `cowplot::ggdraw()` with `draw_plot()`, `patchwork` with a custom design and fixed widths/heights, `grid`/`gtable`, or a Python/matplotlib GridSpec workflow when exact axes are needed.
- Use `patchwork::wrap_plots()` only for balanced grids where all panels have equal status.
- Use `cowplot` or `grid` when a survival curve and risk table must be treated as one panel group.
- Use a dedicated legend grob or legend strip instead of collecting legends automatically when placement matters.

### Panel Tags

- Tag only scientific panels: `A`, `B`, `C`, etc.
- Do not tag risk tables, legend strips, color bars, scale bars, method labels, or annotation-only strips.
- Place tags manually at consistent figure coordinates when automatic tags collide with panel content.
- Tags should be bold, slightly larger than axis text, and outside the plotting area when possible.

### Axes And Alignment

- Align axes only when units and transformations match.
- Keep dependent table columns exactly aligned to their parent plot ticks.
- Shorten long y-axis labels before reducing font size below readability.
- Reserve space for facet strips, long forest-plot labels, and rotated x labels in the layout specification.
- Avoid vertical axis titles drifting into neighboring panels; use margins or separate label grobs.

### Legends And Encodings

- Use the same color and line mapping for the same group in every panel.
- Do not allow automatic legends to split the figure through the middle.
- Prefer one shared legend strip above, below, or beside the panel group.
- Omit legends when direct labels are clearer and do not clutter the data area.
- State color meanings in the rationale and keep them stable across reruns.

### Tables, Insets, And Annotation Strips

- A table attached to a plot is part of that plot's panel group.
- Insets must amplify or clarify a local feature, not duplicate the main panel.
- Keep annotation strips low-contrast and aligned to their parent panel.
- If table text is too small at final size, redesign the table rather than shrinking it further.

### Typography And Style

- Use one base font family and a narrow range of font sizes.
- Keep titles short and avoid sentence-length panel titles.
- Prefer direct axis labels over explanatory subtitles inside the figure.
- Use low-saturation fills and strong but not oversized marks.
- Avoid heavy grids, decorative backgrounds, and boxed panels unless required by the data type.

## R Template Guidance

Use `assets/templates/multipanel_helpers.R` and `assets/templates/multipanel_figure.R` only as starting points. Before adapting either template, write the layout specification and decide whether automatic `patchwork` composition is sufficient.

For publication figures:

- Prefer a custom function that assembles named panel groups with explicit relative widths/heights.
- For survival panels, create a parent panel group containing the curve and risk table before adding tags.
- Extract or build legends as independent grobs and place them in a reserved legend strip.
- Save the combined object as an RDS, then export from that same object.
- Keep SVG text editable through `svglite`; do not rasterize text unless unavoidable.

Key helpers in the template:

- `make_medical_multipanel()` for ordinary grids or custom patchwork designs.
- `make_quantitative_grid()` for balanced 2x2 or 3-column grids.
- `make_clinical_triptych()` for parallel clinical evidence rows.
- `make_schematic_led_composite()` for workflow-led figures.
- `make_image_quant_layout()` for image plus quantification figures.
- `make_asymmetric_hero()` for one dominant panel plus support.

If the requested figure is a main manuscript figure, do not use the default balanced grid unless the layout specification explicitly says all panels have equal evidence weight.

## Output And Editable Vector Rules

- Export SVG and verify that text remains editable where the device supports it.
- Export PDF, 700 dpi TIFF, and web PNG from the same final figure object.
- Use final journal dimensions when exporting; do not design at one size and scale later.
- Keep web PNG under 1 MB when feasible, but never let the web preview drive the print layout.
- For complex figures, optionally export separate panel source files in addition to the combined figure.
- Write `output/figure_rationale.md` with the figure specification, layout specification, panel roles, model/statistical definitions, limitations, and output paths.

## QA Checklist

Before delivery, verify:

- The full figure has one clear conclusion.
- Every tagged panel answers a distinct question.
- The dominant panel matches the evidence hierarchy.
- Dependent elements are attached to their parent panels and are not incorrectly tagged.
- Panel tags are present, manually checked, aligned, and referenced in the rationale.
- Legends do not split or compress scientific panels.
- Colors, groups, labels, time units, denominators, and transformations are consistent.
- Risk tables align exactly to survival-curve x-axis ticks when present.
- Error bars and intervals are defined.
- P-values, CIs, and model estimates are computed or supplied.
- Long labels are not clipped, truncated, or forced below readable size.
- Axis titles do not drift into neighboring panels.
- Text remains readable at final export dimensions.
- SVG opens with editable text and no missing fonts when feasible.
- Survival event coding and censoring definitions are checked when applicable.
- PH diagnostics are considered before formal Cox interpretation.
- Heatmap scaling and clustering choices are declared when applicable.
- Image crop/contrast/scale-bar choices are documented when applicable.
- PDF, SVG, 700 dpi TIFF, and readable web PNG are generated and non-empty.
