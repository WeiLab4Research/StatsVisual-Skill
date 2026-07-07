# Forest Plot with Dashed Null-Effect Reference Line and Light Category Bands

## Purpose

Create a publication-ready forest plot where:

- The **X-axis includes a dashed reference line** marking the null-effect value.
- The **Y-axis items are grouped by category**.
- The background behind Y-axis items uses **alternating light category bands** to visually separate groups.
- The category bands are intentionally subtle, for example `#F6F7F9`, so they support grouping without competing with points, confidence intervals, labels, or the null-effect line.

This skill is intended for forest plots such as odds ratios, hazard ratios, risk ratios, beta coefficients, mean differences, or other effect estimates with confidence intervals.

---

## Visual Rules

### 1. X-axis dashed reference line

Use a vertical dashed line to mark the null-effect value.

Typical null-effect values:

| Effect type | Null-effect value |
|---|---:|
| Odds ratio | 1 |
| Risk ratio | 1 |
| Hazard ratio | 1 |
| Mean difference | 0 |
| Regression coefficient / beta | 0 |

The reference line should be visible but not dominant.

Recommended style:

```r
geom_vline(
  xintercept = null_value,
  linetype = "dashed",
  linewidth = 0.45,
  color = "grey45"
)
```

### 2. Y-axis light category bands

Group Y-axis rows by a category variable, then draw one horizontal background band per group.

The bands should:

- Cover the full X plotting range.
- Align behind all rows belonging to the same group.
- Alternate between a very light fill and transparent/no fill.
- Use subtle colors such as `#F6F7F9`.
- Sit behind the confidence intervals and points.

Recommended approach:

```r
geom_rect(
  data = band_data,
  aes(xmin = -Inf, xmax = Inf, ymin = ymin, ymax = ymax, fill = band_fill),
  inherit.aes = FALSE,
  alpha = 1
)
```

Use `scale_fill_identity()` so the exact band colors are respected.

---

## R Function Template

```r
plot_forest_light_category_bands <- function(
  data,
  group_col = "group",
  label_col = "label",
  estimate_col = "estimate",
  lower_col = "lower",
  upper_col = "upper",
  null_value = 1,
  x_label = "Effect estimate",
  point_size = 2.4,
  ci_linewidth = 0.55,
  band_color = "#F6F7F9",
  empty_band_color = "transparent",
  reference_line_color = "grey45",
  reference_line_width = 0.45,
  reference_line_type = "dashed"
) {
  required_packages <- c("ggplot2", "dplyr", "rlang")
  missing_packages <- required_packages[!vapply(required_packages, requireNamespace, logical(1), quietly = TRUE)]
  if (length(missing_packages) > 0) {
    stop(
      "Please install the following packages before using this function: ",
      paste(missing_packages, collapse = ", "),
      call. = FALSE
    )
  }
```

## Template Starter

- Use `assets/templates/subgroup_forest.R` as the starter template for subgroup forest plots with table-aligned effect estimates, confidence intervals, sample-size columns, and optional interaction P values. Copy it into `<project_dir>/R/` and adapt the subgroup, level, estimate, CI, sample-size, and interaction columns before running.
## Implementation Principle

The category bands are a structural aid, not the main visual feature. The viewer should first notice the estimates, confidence intervals, and null-effect reference line. The light Y-axis bands should only help the viewer understand which rows belong to the same group.
