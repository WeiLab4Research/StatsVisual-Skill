# Ternary Plot

## Use For

Use ternary plots for three-part compositions where the components are non-negative and sum to a constant, such as 1 or 100%.

## Core Mapping Logic

### Basic Ternary Plot

**Applicable Data**

- Three component variables, and the sum of the three for each observation is 1 or 100.
- Commonly used for metabolite ratio, elemental composition, nutrient ratio, three-category component distribution, etc.

**Mapping Logic**

- Use `ggtern(data, aes(x = comp1, y = comp2, z = comp3))`.
- `x`, `y`, and `z` map three component variables respectively.
- Point layers usually use `geom_point()`.
- If grouping exists, `color = group` can be mapped.
- Axis labels pass:
  - `Tlab()`: top axis;
  - `Llab()`: left axis;
  - `Rlab()`: Right axis.
- `theme_showarrows()` can be used to enhance the sense of three-dimensional direction.

**Additional Requirements**

- The most critical premise of the ternary diagram is that the sum of the three variables must be a constant; if the original data is not a proportion, it must be standardized first.
- It is recommended to keep clear three-axis labels and concise legends, and not to be disturbed by too many decorations.
- A light gray triangle mesh is required as the background
- Place the legend on the right and center it vertically.
- Place the title at the top and center it.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

### Confidence Ternary Plot

**Applicable Data**

- The same is data for three components whose sum is a constant.
- The focus of the study is to show the confidence range of the sample in the three-dimensional space, not just the single point position.

**Mapping Logic**

- Use `stat_confidence_tern()` to overlay interval layers.
- `x`, `y`, and `z` still map three component variables.
- `mapping = aes(fill = ..level..)` fills the color horizontally with the interval.
- `geom = "polygon"` plots regions with different confidence levels.
- `breaks` specifies multiple interval levels, such as `0.5`, `0.8`, `0.9`, `0.95`, `0.99`.
- Often superimposed:
  - `geom_mask()` handles triangle boundaries;
  - `geom_point()` displays the original point.

**Additional Requirements**

- The confidence interval plot emphasizes the distribution range of the sample population, not the individual confidence interval of each point.
- Interval layers usually gradient from shallow to deep or from low to high, and the level semantics must be clear.
- Too many confidence layers will cause congestion in the triangle area. It is recommended to control the number of breaks.
- If the original points are superimposed, the point color and fill color must form enough contrast to prevent the points from being engulfed by the interval layer.
- A light gray triangle mesh is required as the background
- Place the legend on the right and center it vertically.
- Place the title at the top and center it.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

### Density Ternary Plot

**Applicable Data**

- Data where the sum of the three components is a constant.
- The sample size is large, and we hope to observe the high-density areas and sparse areas in the ternary space.

**Mapping Logic**

- Use `stat_density_tern()`.
- `x`, `y`, `z` map three component variables.
- `fill = after_stat(level)` maps density levels to fill colors.
- `alpha = after_stat(level)` can synchronously map transparency and enhance density levels.
- `geom = "polygon"` is commonly used to form a continuous density area.
- `geom_point()` can be superimposed to display the original observation point.

**Additional Requirements**

- Density ternary plots emphasize group distribution hot spots rather than individual observation point locations.
- Setting `breaks` too finely will result in too many layers, slow rendering, and difficulty in interpreting; it should be controlled within a reasonable range.
- Density color ramps should be monotonic, ensuring that darker or warmer colors represent higher density.
- If original points are displayed at the same time, the point size must be restrained to avoid blocking the density structure.
- A light gray triangle mesh is required as the background
- Place the legend on the right and center it vertically.
- Place the title at the top and center it.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

### Interpolated Ternary Plot

**Applicable Data**

- Data where the sum of the three components is a constant.
- In addition to the three components, a continuous target variable is included, such as total exposure, total content, or a certain biomarker level.

**Mapping Logic**

- Use `geom_interpolate_tern()`.
- `x`, `y`, and `z` still map three component variables.
- `value` maps the target variable.
- `color = ..level..` or similar is used to represent the interpolated intensity of the target variable.
- Common fitting settings:
  - `base = "identity"`
  - `method = "glm"`
  - `formula = value ~ poly(x, y, degree = k)`
- `geom_point()` can be superimposed to display the original observation position.

**Additional Requirements**

- The interpolated ternary diagram is not a simple density diagram. Its core is "the trend surface of the target variable changing with the three components."
- The fitting formula must match the amount of data; a polynomial degree that is too high may lead to overfitting.
- If the distribution of the target variable is skewed, you should first consider whether transformation or standardization is needed.
- A light gray triangle mesh is required as the background
- Place the legend on the right and center it vertically.
- Place the title at the top and center it.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

## Code Reference
- Original development note: source script `1500-ternary-finished.rmd` is not included in the public skill.

## QA

- Verify components sum to a constant after missing-value handling.
- Normalize only if normalization is scientifically valid.
- Avoid ternary plots for audiences that need exact numeric reading; provide a table or alternative dot plot when needed.

