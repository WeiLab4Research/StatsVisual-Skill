# Line Chart

## Use For

Use line charts for ordered x-values: time, dose, sequence, or another continuous/ordinal variable. Lines imply continuity or ordered connection.

## Variants

- Point-line chart for measured time points.
- Time-series line chart.
- Grouped longitudinal line chart.
- Mean trend with confidence band.
- Area chart for cumulative totals.
- Stacked area chart for additive components.
- Step chart for event/cumulative processes.
- Radar/spider plot only for compact multivariate profiles; use cautiously.

## Core Mapping Logic

### Line Plot with Point

![Line Plot with Point](../assets/gallery/line/point_line.png)

**Applicable Data**

- One-dimensional continuous trend data
- Usually `x = time/dose/proportion/continuous value`, `y = continuous metric`
- Can bring `group` to represent different models, queues, processing groups, and subgroups

**Mapping Logic**

- `x` maps to the continuous horizontal axis
- `y` is mapped to the vertical axis value
- `color = group`
- First `geom_point()` then `geom_line()` or both in parallel
- If multiple groups are parallel, the line and point colors are unified, and the legend is controlled by `color`
- The X-axis must be a continuous variable, and pure categorical variables must not be mistaken for a polyline horizontal axis.

**Additional Requirements**

- It is recommended to limit the Y-axis range so that the line occupies about 2/3 of the height of the canvas to enhance readability.
- Place both the title and legend at the top and center them.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

### Scree Plot

![Scree Plot](../assets/gallery/line/scree.png)

**Applicable Data**

- Principal component analysis, factor analysis, and eigenvalue decomposition results
- The original input is usually a multi-variable wide table; the mapping data is each principal component and its variance, eigenvalues ​​or variance contribution rate

**Mapping Logic**

- `x = principal component index or name (PC1, PC2, ...)`
- `y = eigenvalue / explained variance`
- `group = 1` to ensure that wires can be wired on discrete X
- Usually `geom_line()` + `geom_point()`

**Additional Requirements**

- If the user provides the original variable matrix, `prcomp(..., scale = TRUE/FALSE)` or other PCA methods should be executed first
- Point shapes are recommended to be hollow or white with black edges to highlight the nodes.
- The component naming order must be correct, and there must be no string sorting error with `PC10` before `PC2`.
- Place both the title and legend at the top and center them.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

### Line Plot with Errorbar

![Line Plot with Errorbar](../assets/gallery/line/errorbar_line.png)

**Applicable Data**

- Means/estimates and their uncertainties at each point in time or at successive locations

**Mapping Logic**

- Main line: `x = continuous variable`, `y = mean/estimate/effect size/count`
- Error bars: `ymin = y - se`, `ymax = y + se`, or use `lcl/ucl` directly
- `color = main group`
- If multiple estimation methods are superimposed on the same node, slight lateral misalignment (such as `x + 0.15`, `x + 0.30`) or `position_dodge()` should be used
- Different estimation methods are more suitable to be distinguished by different point shapes, and the main grouping is still distinguished by color.
- If a reference line is needed, it is usually `geom_hline(yintercept = 0)`, which means "no change relative to the baseline"

**Additional Requirements**

- If the legend contains both colors and point shapes, it is preferred to use the shared legend or manually extract the legend.
- When lines represent observations only and other methods only show points and error bars, keep the mapping consistent in the code and avoid legend ambiguity
- Place both the title and legend at the top and center them.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

### Time Series Plot

![Time Series Plot](../assets/gallery/line/time_series.png)

**Applicable Data**

- Time-ordered observations of a single variable or a small number of multiple variables
- Time granularity can be day, week, month, quarter, year
- Can include multiple versions such as original sequence, logarithmic transformation sequence, difference sequence, seasonal difference sequence, etc.

**Mapping Logic**

- `x = date`
- `y = numeric variable`
- Commonly used `geom_line()`
- The date axis uses `scale_x_date()`, combined with `date_labels`, `date_breaks`
- When displaying multiple panels, it is common to combine different processed sequences into one image, and then use `patchwork` or `cowplot` to splice them together.
- For differential sequences, `ts` or model output needs to be converted back to the data frame first

**Additional Requirements**

- When the task is "time series feature diagnosis" rather than "single picture display", priority should be given to multiple panels: original, log, first-order difference, seasonal difference
- The starting time length of the sequence after differentiation will become shorter, so attention should be paid to date alignment.
- If the numerical minimum is close to 0 and the fluctuation amplitude changes with the mean, a log transformation is often necessary
- Multi-panel plots must be labeled with capital letters A / B / C / D
- Place both the title and legend at the top and center them.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

### Smooth Line Plot

![Smooth Line Plot](../assets/gallery/line/smooth_line.png)

**Applicable Data**

- Original observation points + a smoothing or model fitting result (to avoid the influence of certain outliers on the trend)
- Suitable for time trend fitting, periodic pattern display, smoothing estimation, and ARIMA result visualization

**Mapping Logic**

- Raw data is usually represented by `geom_point()` or thin lines
- The fitting results are represented by `geom_line()`
- `x = time`
- `y = observed value` and `fitted value`

**Additional Requirements**

- A unified coordinate scale must be used when comparing multiple panels to avoid misjudgments due to different scales.
- If comparing two fitting methods, it is recommended to have two panels or an upper and lower layout instead of one graph filled with too many fitting lines.
- Place both the title and legend at the top and center them.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

### Area Graph

![Area Graph](../assets/gallery/line/area.png)

**Applicable Data**

- One-dimensional continuous trend data
- Usually `x = time/dose/proportion/continuous value`, `y = continuous metric`
- Can bring `group` to represent different groups

**Mapping Logic**

- `x = continuous time/continuous variable`
- `y = value`
- `fill = series name`
- Use `geom_area()`

**Additional Requirements**

- Do not misuse stacked area charts if the series are not part-whole relationships.
- Percent variables suggest `scale_y_continuous(labels = label_percent(...))` or explicitly displayed as 0–100
- The X-axis label can be rotated when the dates are dense
- When multiple sequences are not strictly additive, transparent overlay can be used instead of stacking.
- When multi-sequence translucent overlay, alpha should be controlled to avoid occlusion
- Draw groups with small values ​​at the back to avoid large areas blocking small areas.
- Soft color scheme
- Place both the title and legend at the top and center them.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.
- code reference:source script `\StatsVisual-Skill\assets\templates\Area Graph.R`

### Stacked Area Graph

![Stacked Area Graph](../assets/gallery/line/stacked_area.png)

**Applicable Data**

- Multiple groups have additivity at each independent variable node
- Each group has a clear overall meaning after being added together.
- Commonly seen in regional composition, subtype composition, cumulative case division composition, income structure, etc.

**Mapping Logic**

- `x = time`
- `y = each component`
- If the input is a long table, `geom_area(aes(fill = group), position = "stack")` is commonly used
- If the input is a wide table, you can also convert it to length first and then draw it; it is not recommended to maintain the manual addition writing method for a long time unless the stacking order needs to be strictly controlled.
- `fill = component group`
- Key events can be marked with `geom_vline()`

**Additional Requirements**

- At a certain point in time, the values ​​of the stacked area chart should be additive and should have practical meaning after addition.
- Must ensure that the stacking order is consistent with the legend order to avoid confusion in interpretation
- This chart is preferred when the user's goal is "overall composition change" rather than "independent trend comparison between groups"
- It is not recommended to have too many groups, otherwise it will be difficult to identify the ground floor area.
- Draw groups with small values ​​at the back to avoid large areas blocking small areas.
- Soft color scheme
- Place both the title and legend at the top and center them.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.
- code reference:source script `\StatsVisual-Skill\assets\templates\Stacked Area Graph.R`

### Stream Graph

![Stream Graph](../assets/gallery/line/stream.png)

**Applicable Data**

- Relative fluctuation display of multiple sets of sequences
- The number of groups is usually larger
- Emphasis on overall dynamics and the rise and fall of groups over time rather than precise readings

**Mapping Logic**

- `x = time`
- `y = value`
- `group = category`
- `fill = category`
- Use `geom_stream()`
- Often use a central baseline to show relative fluctuations, visually forming a "river"

**Additional Requirements**

- Suitable for scenes with high-density time points and many groups
- Avoid using rainbow colors and excessively harsh color bands; control chromatic gradation and distinguishability
- If the Y-axis uses centered positive and negative display, the label needs to be formatted as an absolute value display.
- Place the title at the top and center it.
- When there are many groups, the legend should be placed to the right and centered vertically.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.
- code reference:source script `\StatsVisual-Skill\assets\templates\Stream Graph.R`

### Stepper Line Chart

![Stepper Line Chart](../assets/gallery/line/step.png)

**Applicable Data**

- Event-driven, cumulative counting, state changes, piecewise constant process
- Each change occurs at a discrete point in time, and the original value between points remains until the next update.

**Mapping Logic**

- `x = continuous variable`
- `y = cumulative value/status value`
- Use `geom_step()`
- For multiple sequences, use `color = metric name`

**Additional Requirements**

- Focus on “when the change occurred” and “magnitude of change”
- The X-axis must be a truly continuous time axis
- The number of multiple sequences should not be too large, otherwise it will be difficult to identify the steps after they overlap.
- Place both the title and legend at the top and center them.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

### Radar Plot

![Radar Plot](../assets/gallery/line/radar.png)

**Applicable Data**

- Comparison of proportions, standardized scores, or indicators of the same scale among multiple groups on multiple dimensions
- The dimensions of each dimension should be the same, usually on a 0–1 scale or in the same range.

**Mapping Logic**

- Each dimension is mapped to a radial axis
- Each group forms a closed polyline
- `group = group`
- Suitable for overall profile comparison of regions, countries, cohorts, and models on multiple indicators

**Additional Requirements**

- It is only suitable for comprehensive comparison of a small number of dimensions and a small number of groups, and is not suitable for high-dimensional and wide tables.
- Each dimension must be comparable, and original variables with different dimensions must not be directly placed into the radar chart.
- Too many groups will lead to occlusion and should be strictly controlled
- More suitable for displaying composition ratios, standardized risk spectra, and capability portraits rather than time trends
- If the label is very long, larger margins should be reserved for the label
- Place the title at the top and center it.
- When there are many groups, the legend should be placed to the right and centered vertically.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.
- code reference:source script `\StatsVisual-Skill\assets\templates\rader_chart.R`

## Code Reference
- Original development note: source script `0200-lineplot-finished.rmd` is not included in the public skill.

## QA

- Do not connect unordered categorical levels.
- Use consistent time units and natural breaks.
- Keep the number of lines readable; facet or directly label if many groups.
- For stacked area, verify values are additive and the sum has meaning.
- For repeated individuals, decide whether to show individual trajectories, group summaries, or both.