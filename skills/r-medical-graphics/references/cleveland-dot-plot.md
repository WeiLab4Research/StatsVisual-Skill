# Cleveland Dot Plot

## Use For

Use Cleveland dot plots for ranked category-level estimates, rates, means, model coefficients, or importance scores. They are often clearer than bars for many categories.

## Variants

- Basic ranked dot plot.
- Grouped dot plot.
- Dumbbell plot for two-group comparison.
- Lollipop plot for bar-like ranking with lower ink.
- Forest/dot-whisker plot for estimates plus confidence intervals.

## Core Mapping Logic

### Cleveland’s Dot Plot

**Applicable Data**

- Multiple classification objects correspond to a continuous numerical indicator.
- Commonly used to display regression coefficients, means, rates, importance scores, effect sizes, etc.

**Mapping Logic**

- `x`: Continuous numerical variables, such as regression coefficients, mean values, and ratings.
- `y`: Categorical variables, usually reordered by numerical value.
- `color`: Usually a single color; if the salience needs to be emphasized, it can be mapped to salient/non-salient grouping.
- Use `geom_point()` as the core geometry layer.
- It is often used with `reorder()` or preset factor sequence to control the vertical axis.

**Additional Requirements**

- The vertical axis generally represents categorical variables, and the horizontal axis represents continuous variables.
- If the value can be positive or negative, it is often necessary to retain 0 as the reference position.
- The classification order is usually sorted by numerical size to enhance readability.
- To enhance readings, keep the light gray horizontal reference line.
- Place the title at the top and center it.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

### Lollipop Plot

**Applicable Data**

- Same as a regular point plot, but with additional emphasis on the distance "from baseline to value point".
- It is often used to display the direction and size of effects, especially suitable for regression coefficient plots with a zero reference line.

**Mapping Logic**

- `x`: continuous numerical value.
- `y`: Categorical variable.
- Use `geom_segment()` to connect to the data points from the baseline (usually `x = 0`).
- Then use `geom_point()` to draw the end dot.
- Usually superimposed `geom_vline(xintercept = 0)` represents the reference line.

**Additional Requirements**

- The baseline of a lollipop chart should have a clear statistical meaning, often 0, the mean, or a clinical threshold.
- If there are positive and negative directions, make sure the zero line is clearly visible.
- You can use accent colors for prominent points, but it’s not advisable to make the entire image too colorful.
- The classification order is usually sorted by numerical size to enhance readability.
- Place the title at the top and center it.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

### Lollipop Plot with Interaction Effect

**Applicable Data**

- The classification object corresponds to a main numerical indicator, and there are interactions, pairing relationships or linkage relationships between some objects.
- Typical examples include the size of the regression coefficients of multiple elements, while showing which pairs of elements have interactions.

**Mapping Logic**

- The main body is still the lollipop picture:
  - `x`: Categorical variable.
  - `y`: continuous numerical value.
  - `geom_segment()` represents the distance from 0 to a numerical point.
  - `geom_point()` represents the lollipop head.
- Interactive relationship layer:
  - Interaction pairs and control points are given through additional data frames.
  - Use `geom_bezier()` or other curved geometry layers to connect related elements.
- Color can be used to differentiate between positive correlations, negative correlations, and interaction curves.

**Additional Requirements**

- The data of the main indicator layer and the interactive connection layer must be managed separately to avoid confusion in mapping.
- If negative and positive values ​​are represented by different colors, the color semantics must be stated in the legend.
- Interaction curves can only connect a small number of key objects, otherwise they will seriously obscure the main image.
- When there are too many categories on the horizontal axis, the labels usually need to be rotated 45 degrees.
- Place both the title and legend at the top and center them.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

### Dumbbell Plot

**Applicable Data**

- The same subject has two comparable values, such as before and after adjustment, before and after treatment, male and female, experimental group and control group.

**Mapping Logic**

- `x`: Numeric variable.
- `y`: Categorical variable.
- Draw two points on the same `item` and connect them with `geom_line(aes(group = item))` or `geom_segment()`.
- `color`: Two types of numerical sources, such as `Adjusted` and `Unadjusted`.
- Commonly used long table structures: `item`, `variable`, `value`.

**Additional Requirements**

- The dumbbell chart emphasizes "the difference between two points within the same object", so the two points must share the same row.
- If sorting, it is recommended to sort by the group of values ​​​​mainly displayed.
- When two points are very close, to avoid complete occlusion of the points, you can increase the outline or transparency appropriately.
- To enhance readings, keep the light gray horizontal reference line.
- Place both the title and legend at the top and center them.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

### Stratified Dot Plot

**Applicable Data**

- Multiple categorical objects, each object belongs to one of a limited number of groups, and each object has a continuous value.
- A typical example is the car brand's `mpg`, which is stratified by the number of cylinders.

**Mapping Logic**

- `x`: Categorical variables, usually brands, elements, regions, etc.
- `y`: continuous numerical value.
- `group` / `color`: Stratified variables, such as `cyl`, regional grouping, etc.
- It can be generated quickly using `ggpubr::ggdotchart()` or controlled manually using `geom_point()`.
- Often used with `sorting = "descending"` or pre-sorting to improve readability.
- If the category is too long, you can use `coord_flip()` or `rotate = TRUE`.

**Additional Requirements**

- There shouldn’t be too many levels of layering, usually 2–4 groups are the clearest.
- If the meaning within the group is limited and the colors are sufficiently identifiable, additional shape mapping can be reduced.
- It is necessary to ensure that the classification order is consistent with the research question and not just alphabetical order.
- The classification order is usually sorted by numerical size to enhance readability.
- To enhance readings, keep the light gray horizontal reference line.
- Place both the title and legend at the top and center them.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

### Dual-metric Stratified Dot Plot

**Applicable Data**

- There are two different indicators on the same classification object and need to be displayed at the same time.
- Typical examples include the annual average concentrations of `PM2.5` and `PM10` in each province.

**Mapping Logic**

- `x`: Categorical variable.
- `y`: The value of two consecutive indicators.
- The first set of indicators uses a layer of `geom_point()` and a set of color scales.
- The second set of indicators is layered with `geom_point()` and enables the second set of color mapping via `ggnewscale::new_scale_color()`.
- It can be used with `shape` to distinguish the two indicators.
- Often add `geom_hline()` to represent the respective standard line or threshold.

**Additional Requirements**

- The color system or point system of the two indicators must be clearly distinguished, otherwise readers will misinterpret it.
- If using dual color mapping, you must ensure that both sets of legends are preserved and that the titles are accurate.
- The threshold line of the indicator can be drawn on the graph (light gray)
- The classification order is usually sorted by numerical size to enhance readability.
- To enhance readings, keep the light gray horizontal reference line.
- Place both the title and legend at the top and center them.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

#### Manhattan Plot

**Applicable Data**

- GWAS or other omics association analysis results.
- Each record represents a site

**Mapping Logic**

- `x`: Chromosome position or whole-genome position expanded cumulatively by chromosome.
- `y`: Usually `-log10(P)`.
- `color`: Different chromosomes are alternately colored, or significant sites are specially colored.
- The significant threshold is represented by `geom_hline()`, such as `P = 5e-8`.
- Significant site labels can be annotated with `geom_text_repel()`.
- If the extreme salient point is too high, `ggbreak::scale_y_break()` can be used to truncate the vertical axis.

**Additional Requirements**

- `P-value` must first be guaranteed to be a numerical value and greater than 0.
- Significant site labels label only a few key SNPs to avoid crowding the entire map.
- Place the title at the top and center it.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

#### Epidemic Trend Dot Plot

**Applicable Data**

- Dated multi-region event trend data.

**Mapping Logic**

- `x`: date.
- `y`: Region or city label.
- `size`: Daily case count or event intensity.
- `fill`: Region label; it can also be used with background stripes to enhance group readability.
- Use `geom_point()` as the principal.
- The date axis uses `scale_x_date()` to control scale and labels.
- Alternating background bands are often added via `geom_rect()` to facilitate line-by-line reading.

**Additional Requirements**

- This picture emphasizes "when it happens" and "how large it is", and the point size must correspond one-to-one with the numerical value.
- If there are many regions, set a fixed order and consider reversing the order for easier reading.
- The point size scale must be reasonable to avoid large values ​​from obscuring small values.
- The time range and date scale should match the research window and avoid being too dense or too sparse.
- Background stripes are auxiliary designs, and the color must be light enough and cannot cover the main point.
- The classification order is usually sorted by numerical size to enhance readability.
- To enhance readings, the light gray horizontal reference can be retained.
- The title and legend are placed at the top and in the center. If there are many categories, the legend can be arranged vertically and centered on the right side.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

## Code Reference
- Original development note: source script `0500-cleveland-finished.rmd` is not included in the public skill.

## QA

- Sort by value or clinically meaningful order.
- Use a reference line for effect estimates.
- Keep long labels readable with horizontal layout.
- Include CI/uncertainty when showing model estimates.

