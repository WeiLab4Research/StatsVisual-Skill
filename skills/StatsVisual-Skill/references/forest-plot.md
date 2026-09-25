# Forest Plot

Use a forest plot to present effect estimates and confidence intervals, including hazard ratios (HRs), odds ratios (ORs), risk ratios (RRs), risk differences (RDs), mean differences, standardized mean differences, and regression coefficients. Statistical results, table columns, and graphical marks must share one row coordinate system.

## Statistical and Data Requirements

- **Effect measure:** State the effect measure explicitly in the header and axis title. The null value is 1 for ratio measures and 0 for difference measures.
- **Model:** Match the model to the outcome. Common choices include Cox regression for time-to-event outcomes and logistic, log-binomial, or Poisson regression for binary outcomes. Overall and subgroup estimates must use the same estimand. Report adjustment variables, stratification factors, and reference levels.
- **Confidence interval:** Report two-sided 95% CIs unless another level is prespecified. Use consistent decimal precision. Ratio estimates and their limits must be positive, and the axis transformation must suit the effect measure.
- **Interaction test:** Derive `P for interaction` from a formal treatment-by-subgroup interaction term using a Wald or likelihood-ratio test. Do not infer interaction from differences between subgroup-specific P values. Display one interaction P value per subgroup variable.
- **Reference and direction:** Define the treatment group, comparator, reference levels, and effect direction. `Favours/Better` labels must agree with the coded contrast.
- **Missing data:** State whether missing values are excluded, imputed, or displayed as `Not reported/Unknown`. A displayed missing category must not enter the interaction test unless it was modeled explicitly.
- **Event coding:** Define event, censoring, and non-event codes. For survival outcomes, also define the time origin. Event counts, denominators, and percentages must use the same analysis population as the model.

## General Plotting Rules

1. **Shared rows:** Align subgroup names, levels, counts, estimates, CIs, and P values on one row coordinate system. Do not assemble visually aligned but independent table and forest panels.
2. **Columns:** Include only columns supported by the analysis, such as subgroup, treatment and comparator counts, forest axis, numeric estimate, and interaction P value.
3. **Hierarchy and alignment:** Use bold subgroup labels and indented, left-aligned levels. Align numeric columns consistently. Center each header over its column and define the span of multilevel headers precisely.
4. **Typography:** Use Arial 10 pt by default. Headers and body labels use the same point size; headers are bold. Use italics only when required by the selected journal style.
5. **Axis:** Ratio measures usually use a logarithmic axis; difference measures use a linear axis. A journal-specific linear ratio axis is acceptable when declared explicitly. The range must retain the null value and cover the principal estimates.
6. **Truncation:** Draw an arrow when a CI extends beyond the axis. Do not force an out-of-range point estimate onto the boundary.
7. **Marker size:** Marker area may reflect inverse-variance weight. Use a constant size when reliable weights are unavailable. The overall estimate may be moderately emphasized.
8. **Margins and clipping:** Balance the left and right outer margins. Keep the rightmost statistical column clear of the edge, and ensure that ticks and direction labels are not clipped.
9. **Titles and direction labels:** Center the effect-measure title over the relevant forest or numeric column. Place direction labels close to the axis and ensure that they match the treatment contrast.
10. **Number formatting:** Use one numeric convention for estimates, CIs, P values, and ticks. Report very small P values as thresholds, such as `<0.001`.

## Journal Style Matrix

| Element | Lancet | NEJM | JAMA | BMJ |
|---|---|---|---|---|
| Body background | Plain white; no row shading | Shallow alternating light-gray bands | Plain white | Plain white |
| Rules and borders | One header rule only; no row rules or outer border | No heavy header rule; use only a subtle local divider when needed | Fine gray row rules in the left table; main header rule ends after the numeric HR/OR column | One header divider; a light rounded border around the forest region only; no whole-figure border |
| Markers and CIs | Black squares with thin black CIs | Black squares with thin black CIs | Teal squares with gray CIs | Blue diamonds with blue CIs; the overall marker may be larger |
| Null reference line | Thin solid line | Dark-gray dashed line | Gray dotted line | Thin gray solid line |
| Count columns | `events/patients` under a two-level header | Patient totals with italic `no. of patients` | `events/total patients (%)` | `events/total patients (%)` |
| P-value placement | Far right, aligned with the subgroup-variable row | Usually omitted; if required, place at the far right | Far right and close to the forest; vertically centered across the subgroup levels | Close to the numeric effect column; aligned with the first level of each subgroup |
| Header structure | Compact two-level header; effect title centered | Treatment headers above an italic patient-count descriptor; effect title centered | Two-level bold header; main rule stops after the numeric effect column; P-value header may be bold italic | Two-level bold header; separate centered titles above the forest and numeric effect columns |
| Direction labels | Bottom bidirectional arrows using `Favours ...` | Bottom bidirectional arrows with bold `... Better` labels | `Favors` labels placed immediately on either side of the null line | `... better` labels centered on the left and right axis endpoints |
| Number format | Midline decimal point `·` | Standard decimal point; en dash within CIs | Standard decimal point; leading zero may be omitted for P values | Standard decimal point; CI format such as `0.44 (0.36 to 0.53)` |

## Templates and Gallery Examples

**Required template review:** Before writing or modifying any forest-plot code, read the selected journal's R template in full and inspect its matching gallery image carefully. Do not infer the journal layout from the general rules alone. Preserve the template's column order, header hierarchy, rule extents, forest-axis construction, marker and reference-line treatment, P-value placement, direction labels, and margin logic unless the user's explicit request or the data requires a justified change.

Each journal template has a matching gallery image:

- `assets/templates/forest_plot/lancet_subgroup_forest.R` → `assets/gallery/forest_plot/lancet_subgroup_forest.png`
- `assets/templates/forest_plot/nejm_subgroup_forest.R` → `assets/gallery/forest_plot/nejm_subgroup_forest.png`
- `assets/templates/forest_plot/jama_subgroup_forest.R` → `assets/gallery/forest_plot/jama_subgroup_forest.png`
- `assets/templates/forest_plot/bmj_subgroup_forest.R` → `assets/gallery/forest_plot/bmj_subgroup_forest.png`

Treat each template as a layout starting point. Replace treatment labels, outcomes, models, subgroups, effect measures, axis limits, column titles, and direction labels according to the actual analysis.
