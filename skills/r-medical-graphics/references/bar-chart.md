# Bar Chart

## Use For

Use bar charts for counts, proportions, rates, means, or other pre-computed summaries across discrete categories. They are useful for group comparisons and ordered categories.

Do not use bars for arbitrary raw continuous observations when the distribution matters. Prefer box/violin/raincloud plots for grouped raw data.

## Variants

- Basic bar: one categorical variable plus count or summary.
- Grouped bar: category plus group.
- Stacked bar: composition across categories.
- 100% stacked bar: relative composition.
- Diverging bar: positive/negative values around a meaningful zero.
- Waterfall plot: ordered cumulative or individual changes.
- Lollipop/bar-dot hybrid: cleaner alternative for many categories.

## Core Mapping Logic

### Basic Bar Plot

**Applicable Data**

- Aggregated data
- Each group has a numerical indicator

**Mapping Logic**

- `x`: Group variable, usually a categorical variable or an ordered rank variable
- `y`: Frequency, rate, mean or percentage corresponding to the group
- Generally use `geom_bar(stat = "identity")`

**Additional Requirements**

- If the groups have a hierarchical relationship, the factor order must be explicitly set first
- If rates or percentages are shown, the y-axis must be clearly labeled `%`
- If the value is an occurrence rate, a starting axis of 0 is recommended
- When the frequency is 0 or extremely low, it is recommended to add numerical labels to avoid visual misreading
- Place both the title and legend at the top and center them.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

---

### Stacked Bar Plot

**Applicable Data**

- Individual-level data, or aggregated multi-category component data
- A main grouping variable + a hierarchical component variable
- Used to display the total amount and internal composition differences after adding up each component within the group

**Mapping Logic**

- `x`: Main group variable
- `fill`: composition variable within the group
- `geom_bar(position = "stack")`
- The y-axis represents frequency or total quantity

**Additional Requirements**

- Suitable for simultaneous comparison:
  - Total volume of each main group
  - The composition of different categories within the group
- If the main group category itself has a hierarchical order, the factor order must be set first
- Not suitable for situations with too many categories and too many colors
- If there are too many color levels within a group, consider using a grouped bar chart or other structural chart instead.
- Place both the title and legend at the top and center them.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

---

### Stratified Bar Plot

**Applicable Data**

- Aggregated data
- A main group variable + a subgroup variable + a numeric variable

**Mapping Logic**

- `x`: main group variable, such as age group
- `y`: frequency, rate or mean
- `fill`: Subgroup variables, such as gender, treatment group
- Use `geom_bar(stat = "identity", position = position_dodge(...))`

**Additional Requirements**

- Must ensure that `geom_bar()` and `geom_text()` use the same or compatible `position_dodge()` width, otherwise the labels will be misaligned
- Comparisons between groups focus on "side-by-side" rather than "stack-on"
- If the number of groups is small and the labels are important, it is recommended to add numerical labels at the top of the column.
- If the main group has a natural order, it must be sorted explicitly
- When a certain subgroup is missing some main group levels, the zero values ​​should be filled in first to avoid uneven column positions after dodge
- Place both the title and legend at the top and center them.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

---

### Bar Plot with Error Bars

**Applicable Data**

- Aggregated data
- Each classification combination has a central value and an error value

**Mapping Logic**

- `x`: attribute or main group variable
- `y`: central value, usually the mean
- `fill`: subgroup variable
- `geom_bar(stat = "identity", position = position_dodge())`
- `geom_errorbar(aes(ymin = ..., ymax = ...), position = position_dodge(...))`

**Additional Requirements**

- For data description tasks, standard deviation `SD` is preferred.
- For parameter estimation or effect estimation tasks, use `SE` or `95% CI`
- If the lower bound of the error line is less than 0, you need to decide whether to truncate or adjust the coordinate range based on the actual meaning of the variable.
- Do not default to plotting without specifying the error definition.
- Place both the title and legend at the top and center them.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.
- Make the error bars clear in the figure legend (placed below the graph and centered), such as:
  - `SD`: individual variation
  - `SE`: Sampling error
  - `95% CI`: interval estimate

---

### Waterfall Plot

**Applicable Data**

- individual level data
- Each individual corresponds to a change value, usually a percentage change from baseline.

**Mapping Logic**

- `x`: individual number, usually sorted by change value to generate serial number
- `y`: changing value, such as `% change from baseline`
- `fill`: can be mapped according to positive and negative changes, response status or molecular type
- Usually use `geom_bar(stat = "identity")`

**Additional Requirements**

- It is strongly recommended to sort by `change` first and then generate the drawing order.
- The y-axis usually takes 0 as the reference line, and the upper and lower values ​​can contain both positive and negative values.
- Positive and negative changes should use a contrasting but restrained color palette
- Not suitable for displaying long text labels on the x-axis, usually represented by patient numbers
- If the number of individuals is large, the x-axis scale density needs to be reduced
- Place both the title and legend at the top and center them.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

---

### Polar Bar Plot

**Applicable Data**

- Multi-category rate or frequency data
- Commonly used in symptom spectrum, event spectrum, and circular comparison

**Mapping Logic**

- Cartesian stage:
  - `x`: category number or factor
  - `y`: indicator value
  - `fill`: Group label, such as Delta / Omicron
- Then use `coord_polar()` to convert to polar coordinates
- Label position and angle usually require additional auxiliary data table control

**Additional Requirements**

- Only used when there are many categories and you want to form a circular visual contrast
- Not suitable as the default preferred bar chart because the read cost is higher than that of a normal Cartesian bar chart
- Label angles must be preprocessed to avoid text inversion and overlap.
- Usually you need to turn off the Cartesian axis text and manually add the radius direction ruler annotation
- `theme_minimal()` or lighter themes are often better than regular themes
- Place both the title and legend at the top and center them.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

## Code Reference
- Original development note: source script `0100-barplot-finished.Rmd` is not included in the public skill.


## QA

- Start the y-axis at zero for length-encoded bars.
- Define error bars: SD, SEM, CI, or other interval.
- Sort categories intentionally: clinical order, dose order, effect size, or frequency.
- Avoid stacked bars when exact subgroup comparison is the main task.
- Use direct percentage labels only when they do not clutter the plot.

