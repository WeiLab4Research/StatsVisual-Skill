# Smoothing Curve

## Use For

Use smoothing curves to reveal nonlinear trend in noisy ordered or scatter data. Show raw data context unless the request is only for a fitted smooth.

## Variants

- LOWESS/LOESS.
- Moving average.
- Spline smooth.
- GAM smooth.
- Smoothed time trend.

## Core Mapping Logic

### LOWESS Smooth Plot

**Applicable Data**

- Data on a single continuous variable as a function of time or another continuous independent variable.

**Mapping Logic**

- `x`: Continuous time variable, such as minutes or hours.
- `y`: Continuously monitor indicators such as body temperature and heart rate.
- The original observation is represented by `geom_point()`.
- The original trend line can be represented by a thin `geom_line()`.
- LOWESS fitted values ​​are generated with `lowess(x, y, f = frac)$y` and plotted with `geom_line()`.
- If only a single LOWESS curve is shown, the legend can be omitted.

**Additional Requirements**

- Suitable for exploring nonlinear trends in scatter or time series data rather than formal parametric model inference.
- The horizontal axis must be a truly ordered continuous variable, and pure categorical variables cannot be mistaken for the LOWESS horizontal axis.
- The original points and original polylines should be weakened and the smooth lines should be used as the visual main body.
- If the time spans a complete cycle, try to retain the complete cycle range to avoid misjudgment of the rhythm caused by intercepting only part of the cycle.
- Place both the title and legend at the top and center them.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.
- code reference:source script `\StatsVisual-Skill\assets\templates\LOWESS Smooth Plot.R`

### LOWESS Smooth with Multiple frac Values

**Applicable Data**

- Single continuous time series data.
- The research focus is to compare the changes of LOWESS curve under different `frac` / window widths.

**Mapping Logic**

- The base point layer and original line layer are the same as the single LOWESS graph.
- Loop through multiple `frac` values ​​for the same set of data, such as `seq(0, 1, by = 0.01)`.
- Each `frac` corresponds to a fitting curve and is organized into a table:
  - `time`
  - `value`
  - `frac`
  - `lowess`
- `color = frac` or manual gradient color spectrum mapped to varying degrees of smoothness.
- Superimpose different `frac` curves with multiple `geom_line()`.

**Additional Requirements**

- The core of this graph is to show how changes in `frac` affect smoothing, so multiple `frac` results must be retained.
- The larger the `frac` is, the smoother the curve is and the closer it is to a straight line; the smaller the `frac` is, the easier it is to overfit.
- When there are many curves, the transparency should be reduced or the color weakened to prevent the picture from being too crowded.
- Place both the title and legend at the top and center them.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

### LOWESS Regression Plot

**Applicable Data**

- A nonlinear relationship between a continuous independent variable and a continuous dependent variable.
- Can be used for method consistency exploration, exposure-effect relationships, or rhythm pattern fitting.

**Mapping Logic**

- `x`: Continuous independent variables, such as time, exposure level, and detection value.
- `y`: Continuous response variables, such as heart rate, blood lead concentration, etc.
- The original observation points can be retained as scatter points.
- The LOWESS / LOESS regression line is drawn with `geom_line()`.
- If uncertainty expression is required, the `predict(..., se = TRUE)` generation interval can be further calculated.

**Additional Requirements**

- If the research question is the consistency of the two methods, you can retain both the scatter points and the LOWESS curve to avoid leaving only a smooth line.
- LOWESS is not a strict parametric regression model, and you should avoid expressing its results as a fixed functional relationship in your skills.
- Place both the title and legend at the top and center them.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.
- code reference:source script `\StatsVisual-Skill\assets\templates\LOWESS Regression Plot.R`

### Grouped LOWESS Regression with Confidence Band

**Applicable Data**

- Multiple sets of repeated measurement data, with multiple individual trajectories within each set.
- A typical example is the comparison of 24h heart rate rhythm between the case group and the control group.

**Mapping Logic**

- First, organize the multi-column individual data in the form of a wide table into a long table:

- Perform a separate `loess.as()` or `loess()` fit for each group.
- Predicted:
  - `fit`
  - `se`
  - `ci_low`
  - `ci_up`
- Layer structure:
  - `geom_line(data = raw, aes(group = subject), alpha = ...)` represents the original trajectory of the individual;
  - `geom_line(aes(time, fit, color = group))` represents the group average LOWESS curve;
  - `geom_point(aes(time, fit, color = group))` represents the fitting node;
  - `geom_ribbon(aes(ymin = ci_low, ymax = ci_up, fill = group), alpha = ...)` represents the 95% confidence interval band.

**Additional Requirements**

- This graph is not a simple superposition of multiple groups of smooth lines, but a composite expression of "individual trajectory within the group + group level LOWESS conditional mean + interval band".
- The original individual trajectory must be weakened, otherwise it will suppress the group average trend line.
- The color and interval fill color must be consistent between groups.
- The confidence interval band needs to be stated as the 95% confidence interval of the conditional mean, not the range of individual values.
- If the time axis uses character hours, it must be converted to an ordered factor or numerical value before smoothing.
- Place both the title and legend at the top and center them.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

## Code Reference
- Original development note: source script `1100-smooth-finished.rmd` is not included in the public skill.

## QA

- Report smoother type and key tuning parameter (`span`, degrees of freedom, basis).
- Avoid over-smoothing or under-smoothing; check sensitivity.
- Do not imply a mechanistic model from an exploratory smooth.

