# Scatter Plot

## Use For

Use scatter plots for two continuous variables to show association, clusters, nonlinearity, heteroscedasticity, and outliers. Scatter plots show covariation, not causality.

## Variants

- Basic scatter.
- Grouped scatter with color/shape.
- Bubble plot with area mapped to a third variable.
- Density/hexbin scatter for overplotting.
- Sunflower plot for repeated identical coordinates.
- Volcano plot for effect size vs p-value/FDR.

## Core Mapping Logic

### Scatter Plot

**Applicable Data**

- Relational data between two continuous variables.
- Commonly used in height and weight, exposure and outcome, dose and response, experimental values ​​and estimated values, etc.

**Mapping Logic**

- `x`: independent variable or explanatory variable.
- `y`: dependent variable or response variable.
- Use `geom_point()` to draw scatter points.
- If there are groups, you can add `color = group` or `shape = group`, but the conventional scatter plots in this chapter are mainly monochrome by default.
- Usually a continuous scale is used and the units are clearly stated.

**Additional Requirements**

- Suitable for observing co-variation trends and outliers between two numerical variables.
- If the sample size is extremely large, it is not appropriate to draw points directly mechanically. Sampling, transparency control, or a smooth scatter plot should be considered.
- Place both the title and legend at the top and center them.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

### Scatterplot Matrix

**Applicable Data**

- Multiple continuous variables require an overview of pairwise relationships.
- Commonly used in the exploration of correlations between physical signs, omics characteristics, and measurement indicators.

**Mapping Logic**

- Use `GGally::ggpairs()` to generate a matrix layout.
- `lower`: Usually the original scatter plot is placed.
- `diag`: usually displays density chart, histogram or histogram.
- `upper`: Usually put correlation coefficients, smooth curves or other relationship summaries.
- Continuous variables participating in the combination can be specified via `columns`.

**Additional Requirements**

- The scatter plot matrix is ​​an extension of the high-dimensional scatter plot. The number of variables should be controlled. Too many variables will seriously reduce readability.
- The display format of the diagonal and upper triangular areas must have clear statistical meaning and cannot be confused and superimposed.
- It is suitable for exploratory display and not suitable for overloading complex conclusions as a single main result diagram.
- Place the title at the top and center it.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

### Scatter Plot with Marginal Distribution

**Applicable Data**

- Two continuous variables, and their joint relationship and respective marginal distributions need to be shown simultaneously.
- Commonly used in correlation display, distribution inspection and outlier identification.

**Mapping Logic**

- The main graph is still a conventional scatter plot, and fitting lines and correlation coefficients can be added.
- Margin layers are added at the edges of the x and y axes via `ggExtra::ggMarginal()`:
  - histogram;
  - density map;
  - Box plot.
- `x` and `y` are still two continuous variables.

**Additional Requirements**

- It is necessary to ensure that the main graph and the marginal graph use the same data subset.
- If correlation coefficients and fitting lines have been added to the graph, the annotation position should avoid the interface area between the point cloud and the marginal graph.
- Place both the title and legend at the top and center them.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

### Scatter Plot with Smooth Curve

**Applicable Data**

- Two continuous variables and the trend needs to be observed through model fitting or non-parametric smoothing.
- Commonly used in growth curves, dose-response, relationship between age and physiological indicators, etc.

**Mapping Logic**

- The bottom layer uses `geom_point()` to display the original observation points.
- The fit layer uses `geom_smooth()` to overlay the trend line.
- `method` can be set to:
  - `loess`: Local weighted regression;
  - `lm`: linear regression;
  - Other scalable models.
- `se = TRUE` displays confidence bands.

**Additional Requirements**

- A distinction must be made between "descriptive smoothing" and "formal regression models".
- When comparing two fitting methods, it is preferable to use multiple panels for side-by-side comparison rather than overlaying too many curves on one graph.
- LOESS is more suitable for nonlinear trends, and LM is more suitable for linear trends; the skill should be automatically judged based on the data structure or pointed out in the description.
- Place both the title and legend at the top and center them.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

### Smooth Scatter Plot

**Applicable Data**

- Extremely high-density bicontinuous variable data, with serious overlapping of conventional scatter plot points.
- Point cloud densities, clusters, or major agglomeration bands need to be observed.

**Mapping Logic**

- `x`: Continuous variable 1.
- `y`: Continuous variable 2.
- Use `ggpointdensity::geom_pointdensity()` to map the local density of points to color.
- `color`: Density value, not raw grouping.

**Additional Requirements**

- Smoothed scatter plots are used to account for point overlap, not as an alternative to trend fitting.
- The color depth must clearly represent the density. Generally, "the darker the color, the denser the points."
- Continuous color scales must choose perceptually uniform, journal-friendly color strips.
- Place both the title and legend at the top and center them.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

### Sunflower Plot

**Applicable Data**

- There is serious data overlap, especially the relationship between categorical variables and discrete numerical variables.
- A typical example is the frequency of the combination of the number of children of the insured person and the region.

**Mapping Logic**

- `sunflowerplot()` using the base graphics system.
- `x`: Discrete or semi-discrete variable, such as the number of children.
- `y`: Categorical variable or coded category.
- Overlapping observations at the same location are represented by the "number of petals" as the number of repetitions.

**Additional Requirements**

- Sunflower plots are suitable for categorical variables or discrete data with many repeated values.
- It must be stated in the legend that "the number of petals represents the number of overlaps".
- If the categorical variable is a character type, you usually need to set the axis labels manually.
- Compared with ordinary scatter plots, sunflower plots emphasize overlapping frequencies and are not suitable for displaying continuous trend fitting.
- Place both the title and legend at the top and center them.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

### Bubble Plot

**Applicable Data**

- Two continuous variables + a third numeric variable + an optional fourth categorical variable.
- Typical ones are GDP, life expectancy, population size and region.

**Mapping Logic**

- `x`: Continuous variable 1, such as GDP.
- `y`: Continuous variable 2, such as life expectancy at birth.
- `size`: The third dimension, such as population.
- `color`: The fourth dimension, such as region.
- Extend the 2D scatterplot with `size` and `color` using `geom_point()`.
- `geom_smooth()` can be overlaid to show overall trends.

**Additional Requirements**

- Point size must reflect area perception rather than radius misleading, so the `scale_size()` range needs to be carefully controlled.
- If the number of bubbles is large, the transparency `alpha` should be appropriately reduced.
- When colors are coded into groups, the legend must be clear; if the legend is too complex, add explanations in your answer and simplify the figure legend.
- Place both the title and legend at the top and center them.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

### Volcano Plot

**Applicable Data**

- Difference analysis results comparing the two groups.
- Commonly found in omics scenarios such as genome, transcriptome, proteome, and metabolome.

**Mapping Logic**

- `x`: The difference multiple value, usually `log2FC` or the difference value normalized by the standard deviation.
- `y`：`-log10(P)`。
- `color`: Can be mapped according to significance status, such as significant up-regulation, significant down-regulation, and non-significant.
- Use `geom_point()` as the principal.
- Often cooperates with:
  - `geom_hline()` represents the significance threshold;
  - `geom_vline()` represents the multiple threshold;
  - `geom_text_repel()` marks key molecules.

**Additional Requirements**

- There should not be too many key tags, usually only the most significant or important small part.
- Color distinction:
Red/orange dots: Significantly upregulated genes that meet thresholds (e.g. |log2FC| > 1 and -log10(P-value) > 1.3).
Blue/green dots: significantly downregulated genes that meet the threshold.
Gray/black dots: genes that do not meet either threshold (change is small or not significant).
- If there are multiple comparison groups, it is preferred to juxtapose multiple panels instead of overlaying multiple volcano charts in the same coordinate system.
- Place both the title and legend at the top and center them.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

## Code Reference
- Original development note: source script `0700-scatterplot-finished.rmd` is not included in the public skill.

## QA

- Do not remove outliers without documented reason.
- Map bubble size to area, not radius, when using bubble plots.
- Use alpha or density methods for overplotting.
- Include raw points when adding trend/model lines.

