# Histogram

## Use For

Use histograms for one continuous variable to inspect distribution shape, skewness, modality, and potential outliers.

## Variants

- Basic histogram.
- Density-scaled histogram with density curve.
- Faceted/grouped histogram.
- Frequency polygon.
- Population pyramid for age-sex or mirrored group distributions.

## Core Mapping Logic

### Basic Histogram

**Applicable Data**

- Raw observational data for a single continuous variable.
- Commonly used to display numerical distributions such as BMI, height, weight, laboratory indicators, etc.

**Mapping Logic**

- Use `geom_histogram()` to binning raw continuous variables directly.
- `x`: continuous variable.
- `y`: Default frequency; can be changed to frequency or density if necessary.
- Control binning via `bins` or `binwidth`.
- Generally, users do not need to summarize in advance. `geom_histogram()` will automatically count the frequency of each box.

**Additional Requirements**

- Not recommended if the sample size is too small
- The Y-axis should start at 0 to avoid exaggerating differences.
- By default, there are no scales between columns, but it is recommended to use white or light-colored strokes on the boundaries to enhance box distinction.
- Place both the title and legend at the top and center them.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

### Histogram with Different Bin Width

**Applicable Data**

- Same as regular histogram, raw data for a single continuous variable.
- The focus is on comparing the effects of different bin numbers on distribution shapes.

**Mapping Logic**

- The main layer is still `geom_histogram()`.
- Generate multiple versions by changing `bins` or `binwidth`.
- `x` and `y` of each panel have the same semantics, only the binning method is different.
- `cowplot::plot_grid()` or `patchwork` is commonly used to splice multiple images.

**Additional Requirements**

- Multiple panels must unify themes, coordinate titles, and major scales to facilitate comparison.
- The uppercase panel label `A / B / C / ...` must be used.
- By default, there are no scales between columns, but it is recommended to use white or light-colored strokes on the boundaries to enhance box distinction.
- Place both the title and legend at the top and center them.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

### Gradient-colored Histogram

**Applicable Data**

- Raw observational data for a single continuous variable.
- I hope to add gradient levels that change with the numerical value inside the histogram.

**Mapping Logic**

- Still mainly `geom_histogram()`.
- `x`: continuous variable.
- `y`: Frequency, frequency or density.
- `fill`: Usually it is not mapped to the original variable, but a gradient color vector consistent with the number of bins is pre-generated and filled in bin order.
- Kernel density curves can be superimposed to assist in observing the smooth shape of the distribution.

**Additional Requirements**

- The length of the gradient color must be consistent with `bins`, otherwise the color and the number of cabinets will not match.
- The color change should serve the density level, and glaring commercial color matching should not be used.
- By default, there are no scales between columns, but it is recommended to use white or light-colored strokes on the boundaries to enhance box distinction.
- Place both the title and legend at the top and center them.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

### Grouped Histogram

**Applicable Data**

- A continuous variable + a categorical grouping variable.
- Typical examples include the distribution of heights at different school levels and the distribution of laboratory indicators in different subgroups.

**Mapping Logic**

- Use `geom_histogram()`.
- `x`: continuous variable.
- `fill`: Group.
- `y`: It is recommended to use `after_stat(density)` or `..density..` to reduce visual bias caused by different sample sizes between groups.
- `position = "identity"`: Translucent overlay compares the overall shape.
- `position = "dodge"`: Compare the differences between groups in the same bin side by side.
- When comparing multiple subgraphs, you can use `patchwork` to collect a common legend.

**Additional Requirements**

- When sample sizes within groups are inconsistent, density is preferred over raw frequencies.
- The overlay must control `alpha`, otherwise it will block each other.
- The `bins`, `binwidth` and coordinate range of the side-by-side diagram must be consistent.
- The order of the legend should be consistent with the actual order of the groups
- Suitable for comparing distribution positions, dispersion, and differences in skewness rather than comparing individual exact means.
- By default, there are no scales between columns, but it is recommended to use white or light-colored strokes on the boundaries to enhance box distinction.
- Place both the title and legend at the top and center them.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

### Symmetric Histogram

**Applicable Data**

- Compare the distribution of the same continuous variable in two large groups.
- Each large group can be further colored by subgroups.

**Mapping Logic**

- Essentially, the two `geom_histogram()` layers are mirrored up and down.
- One group uses `y = after_stat(density)` and the other group uses `y = -after_stat(density)`.
- `x`: continuous variable.
- `fill`: Can be mapped to a subgroup, such as `school_grade`.
- Use `scale_y_continuous(labels = abs)` to display negative labels as positive labels.

**Additional Requirements**

- It is suitable for direct image comparison of two major groups. It is usually not recommended to exceed two main groups.
- The upper and lower labels and group descriptions should be clear, such as `Girls` / `Boys`.
- 0 Near the horizontal line is the visual center, and the upper and lower ranges must be basically symmetrical.
- If you continue to fill in subgroups, you should control the transparency to avoid excessive overlap.
- The butterfly diagram focuses on comparing distribution profiles and should not be misunderstood as a positive and negative effect diagram.
- By default, there are no scales between columns, but it is recommended to use white or light-colored strokes on the boundaries to enhance box distinction.
- Place both the title and legend at the top and center them.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

### Stacked Histogram

**Applicable Data**

- Data on a continuous-time or ordinal variable that has been summarized into a total with multiple components at each point in time.
- For example, a stacked column distribution chart on a time series is used to display the composition of cases in different states.

**Mapping Logic**

- Use `geom_bar(stat = "identity")` layered overlay instead of `geom_histogram()` auto-binning.
- `x`: time or sequence variable.
- `y`: Values ​​of each component.
- `fill`: composition category.
- Visual stacking can be achieved by drawing the total amount first and then the underlying composition.

**Additional Requirements**

- Input data must be aggregated values, not raw individual data.
- All components must be additive.
- By default, there are no scales between columns, but it is recommended to use white or light-colored strokes on the boundaries to enhance box distinction.
- Place both the title and legend at the top and center them.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

### Population Pyramid

**Applicable Data**

- Age Group × Gender × Population Number or Proportion Data.

**Mapping Logic**

- Essentially a back-to-back bar chart.
- `x`: age group (usually the last `coord_flip()` is displayed as the vertical age axis).
- `y`: The group on one side is positive and the group on one side is negative, such as `ifelse(Sex == "Male", -Pops, Pops)`.
- `fill`: Gender.
- `geom_hline(yintercept = 0)` can be added to emphasize the central axis.
- `scale_y_continuous(labels = abs)` is used to display absolute values.

**Additional Requirements**

- After flipping horizontally and vertically, make sure that the age group reading order is natural.
- Legends are usually placed concisely and do not obscure the subject.
- By default, there are no scales between columns, but it is recommended to use white or light-colored strokes on the boundaries to enhance box distinction.
- Place both the title and legend at the top and center them.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

### Ridgeline Plot

**Applicable Data**

- A continuous variable + a categorical variable.
- Used to display the distribution differences of multiple groups of continuous variables.

**Mapping Logic**

- Use `ggridges::stat_density_ridges()` or `geom_density_ridges()`.
- `x`: continuous variable.
- `y`: grouping variable.
- `fill`: Can be mapped to `after_stat(ecdf)` or other density-related values ​​to enhance peak gradation.

**Additional Requirements**

- Peak and peak plots are essentially sets of density distribution plots rather than histogram bins.
- The number of groups should not be too many, otherwise the spacing between peaks will be insufficient.
- If you use a gradient fill, make sure the color serves the distribution hierarchy rather than just being decorative.
- The legend can usually be removed since the `y` axis is already given a group name.
- By default, there are no scales between columns, but it is recommended to use white or light-colored strokes on the boundaries to enhance box distinction.
- Place the title at the top and center it.
- You can add horizontal or vertical gray background lines
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

### Epidemic Ridgeline Plot

**Applicable Data**

- Multi-region/multi-event time series height data.

**Mapping Logic**

- Use `geom_density_ridges(stat = "identity")` to directly input the daily number of confirmed cases as the height.
- `x`: date.
- `y`: Region label.
- `height`: Daily number of cases.
- `group`: Each region corresponds to an independent curve.
- `fill`: Region.

**Additional Requirements**

- Such plots are not kernel density estimates, but rather "original time height driven" ridgeline expressions, which must be explicitly `stat = "identity"`.
- The date axis must be explicitly formatted to control the density of major and minor ticks.
- If there are many colors, they should be drawn from multiple journal color swatches in a controlled manner rather than randomly stacking colors.
- When splicing multiple pictures, special attention should be paid to the alignment of the left and right margins and the scale area.
- By default, there are no scales between columns, but it is recommended to use white or light-colored strokes on the boundaries to enhance box distinction.
- Place the title at the top and center it.
- You can add horizontal or vertical gray background lines
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

### Spiral Histogram

**Applicable Data**

- Continuous observational data that changes over time and is periodic.
- Typical examples include daily air pollutant concentration, daily outpatient and emergency volume, and daily number of cases.

**Mapping Logic**

- Essentially `geom_linerange()` represents the daily bar height in an Archimedean spiral or polar coordinate framework.
- `x`: Date count or period position.
- `ymin` / `ymax`: The position of the spiral baseline and column top.
- `color`: Can be mapped to continuous pollution values ​​or other continuous indicators.
- Use `coord_polar(theta = "x")` to convert to polar coordinates.
- Trace the outer and inner edges of each year with additional `geom_line()`.

**Additional Requirements**

- Auxiliary variables must be constructed in advance, such as `DateNum`, `Asst`, `Valueht`, and the original date cannot be directly used for drawing.
- The month scale should correspond exactly to the position in the year.
- Continuous color scales should be midpointed around the reference threshold
- By default, there are no scales between columns, but it is recommended to use white or light-colored strokes on the boundaries to enhance box distinction.
- Place the figure title and figure title at the top and in the center
- You can add horizontal or vertical gray background lines
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

## Code Reference
- Original development note: source script `0400-histogram-finished.rmd` is not included in the public skill.

## QA

- Choose bin width deliberately; test whether conclusions change with binning.
- Use density scaling when overlaying density curves.
- Avoid histograms for very small samples; use dot/box/rug alternatives.
- For grouped histograms, facet or use transparency carefully.

