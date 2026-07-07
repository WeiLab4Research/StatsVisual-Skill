# Q-Q Plot

## Use For

Use Q-Q plots to compare sample quantiles with a theoretical distribution, most often normality. In GWAS and high-throughput testing, use Q-Q plots to assess p-value inflation and tail behavior.

## Core Mapping Logic

### Theoretical QQ Plot

**Applicable Data**

- A single continuous variable sample.
- The goal is to test whether the variable obeys a certain theoretical distribution, mainly the normal distribution.

**Mapping Logic**

- `aes(sample = variable)` maps the sample quantiles to the QQ chart dedicated interface.
- Use `stat_qq()` to plot sample quantile points.
- Use `stat_qq_line()` to add a theoretical reference line.
- The horizontal axis is usually the theoretical quantile, and the vertical axis is the sample quantile.
- When a manuscript uses standard normal comparison, the variables are often standardized by `scale()` first.

**Additional Requirements**

- If the user's goal is "whether it obeys a normal distribution", priority is given to the conventional QQ chart.
- Place both the title and legend at the top and center them.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

### QQ Plot with Density Comparison Panel

**Applicable Data**

- A single continuous variable sample.
- In addition to the QQ plot, you also want to show the density comparison of the sample distribution and the theoretical distribution at the same time.

**Mapping Logic**

- Left: Regular QQ chart, using `stat_qq()` and `stat_qq_line()`.
- Right picture: Theoretical distribution curve + sample density curve, usually `geom_line()` is used to draw the theoretical density, and `geom_density()` is used to draw the sample density.
- The two pictures are spliced ​​horizontally through `cowplot::plot_grid()`.
- Multiple panels need to be labeled `A / B`.

**Additional Requirements**

- Theoretical density and sample density must use the same standardized scale.
- The theoretical curve and the sample density line should use a contrasting but restrained color scheme.
- Place both the title and legend at the top and center them.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

### Two-sample QQ Plot

**Applicable Data**

- Two sets of continuous variable samples.
- The goal is to compare whether the distributions of two sets of data are the same, not to compare to a theoretical distribution.

**Mapping Logic**

- First, calculate the sample quantiles at a common probability level for each of the two groups of samples.
- `x`: Quantile of sample 1.
- `y`: Quantile of sample 2.
- Use `geom_point()` to plot two-sample quantile scatter points.
- `geom_abline()` is often superimposed as a reference line, and the slope can be estimated by the sample quantile ratio or using an equal slope benchmark.
- It is often used with two sets of `geom_density()` to make a distribution comparison chart on the right side, and spliced ​​through `plot_grid()`.

**Additional Requirements**

- If the sample sizes of the two groups are different, the probability grid should be unified before taking the quantiles.
- Sort the two sets of data from small to large, and calculate the quantile under the same cumulative probability (such as 1%, 5%, 10%...99%).
- Plot the scatter points with the sample 1st percentile on the x-axis and the sample 2nd percentile on the y-axis.
- Place both the title and legend at the top and center them.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

### Probability–Probability Plot

**Applicable Data**

- A single continuous variable sample.
- The goal is to compare whether the sample cumulative probability is consistent with the theoretical cumulative probability.
- It can also be extended to compare the cumulative distribution of two groups of samples, but this chapter mainly shows the theoretical distribution of a single sample pair.

**Mapping Logic**

- Use this from `qqplotr`:
  - `stat_pp_line()`
  - `stat_pp_point()`
- `aes(sample = variable)` provides sample data.
- The horizontal axis is usually the theoretical cumulative probability, and the vertical axis is the sample cumulative probability.
- If the points fall roughly near the reference line, the sample approximately obeys the target distribution.

**Additional Requirements**

- Place both the title and legend at the top and center them.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

### Symmetry Plot

**Applicable Data**

- A single continuous variable sample.
- The goal is to determine whether the variable is approximately symmetric about the median.

**Mapping Logic**

- Sort the samples first.
- Calculate the distance from the upper and lower sides of the sample median to the median:
  - `x`: distance below the median;
  - `y`: Distance above the median.
- Use `geom_point()` to draw distance pairs.
- Use `geom_abline(slope = 1)` as the symmetry guide.

**Additional Requirements**

- Place both the title and legend at the top and center them.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

### Chi-square Quantile Plot

**Applicable Data**

- A single continuous variable sample.
- A chi-square distribution that is known or assumed to come from a specific degree of freedom.

**Mapping Logic**

- QQ picture version:
  - `aes(sample = y)`
  - Specify the target distribution via `distribution = function(p) qchisq(p, df = k)` in `stat_qq()`.
- PP diagram version:
  - Observe cumulative probability consistency using `stat_pp_point()` and `stat_pp_line()`.
- `plot_grid()` is commonly used to form a double-panel comparison.

**Additional Requirements**

- Place both the title and legend at the top and center them.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

### Ladder of Powers for Normal Distribution

**Applicable Data**

- A single continuous variable sample.
- The goal is to find an expression closer to a normal distribution after trying different powers or logarithmic transformations.

**Mapping Logic**

- Apply a set of predefined transformations to the original variables, for example:
  - `x^3`
  - `x^2`
  - `x`
  - `sqrt(x)`
  - `log(x)`
  - `1/sqrt(x)`
  - `1/x`
  - `1/x^2`
  - `1/x^3`
- Organize each transformation result into a table.
- Use `geom_qq()` and `geom_qq_line()` to make separate QQ plots for each transformation.
- Use `facet_wrap()` to form a multi-panel comparison.
- You can also call the `gladder()` or `qqladder()` helper function.

**Additional Requirements**

- Multiple panels must maintain a unified style
- Place both the title and legend at the top and center them.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

## Code Reference
- Original development note: source script `0900-QQplot-finished.rmd` is not included in the public skill.

## QA

- Do not use Q-Q plots as the only evidence for model validity.
- Interpret tail deviations and systematic curvature separately.
- For p-value Q-Q plots, remove invalid p-values and report genomic inflation if needed.

