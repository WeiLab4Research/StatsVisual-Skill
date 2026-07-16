# Regression Model Diagnostics

## Use For

Use diagnostic plots to assess whether a fitted model is stable, appropriate, and not dominated by unusual observations.

## Diagnostic Families

- Residuals vs fitted: linearity and equal variance.
- Normal Q-Q of residuals: residual distribution.
- Scale-location: heteroscedasticity.
- Residuals vs leverage and Cook distance: influential observations.
- DFBETA: term-specific influence.
- VIF/correlation plot: multicollinearity.

## Core Mapping Logic

### Residuals vs Fitted Plot

![Residuals vs Fitted Plot](../assets/gallery/regression_diagnostics/residual.png)

**Applicable Data**

- Fitted linear model object, such as `lmfit <- lm(y ~ x, data = df)`.
- Focus on testing whether the linear assumption is reasonable and whether the residuals fluctuate randomly around 0.

**Mapping Logic**

- `x`: Fitted value `.fitted`
- `y`: Residual `.resid`
- Use `geom_point()` to display the residual scatter.
- Use `stat_smooth(method = "loess")` to draw a local trendline.
- Use `geom_hline(yintercept = 0)` to add a zero reference line.

**Additional Requirements**

- If the LOESS curve shows a systematic deviation, it indicates that the linear model may be insufficient, and variable transformation, adding higher-order terms, or using other models need to be considered.
- When the number of scatter points is large, the point size can be appropriately reduced or the transparency increased.
- Place both the title and legend at the top and center them.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

### Normal Q-Q Plot of Residuals

**Applicable Data**

- Fitted linear model object.
- Focus on testing whether the standardized residuals approximately obey a normal distribution.

**Mapping Logic**

- `aes(sample = .stdresid)` provides the sample quantiles.
- Use `geom_qq()` to plot the residual quantile points.
- Use `geom_abline()` or an equivalent reference line to represent the theoretical normal quantile reference line.
- Horizontal axis: theoretical quantile.
- Vertical axis: standardized residual quantiles.

**Additional Requirements**

- Place both the title and legend at the top and center them.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

### Scale-Location Plot

**Applicable Data**

- Fitted linear model object.
- Focus on testing whether the residual variance changes with the fitted value, that is, the homoskedasticity assumption.

**Mapping Logic**

- `x`: Fitted value `.fitted`
- `y`：`sqrt(abs(.stdresid))`
- Use `geom_point()`.
- Use `stat_smooth(method = "loess")` to draw a trend line.
- Reference lines such as `geom_hline(yintercept = 1)` can be added as a visual aid.

**Additional Requirements**

- Ideally, the LOESS trendline should be approximately horizontal or fluctuate only slightly.
- If there is an obvious rise, fall or funnel shape, it indicates uneven variance.
- Don't confuse this with a normal residual plot; it's specifically used to observe homogeneity of variances.
- Place both the title and legend at the top and center them.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

### Standardized Residual Index Plot

**Applicable Data**

- Fitted linear model object.
- Focus on identifying possible outliers or outliers.

**Mapping Logic**

- `x`: observation serial number, such as `seq_along(.stdresid)`
- `y`: Standardized residual `.stdresid`
- Use `geom_point()` to draw scatter points.
- Use `stat_smooth(method = "loess")` as an auxiliary trend line.
- Add a threshold line using `geom_hline(yintercept = c(-3, 0, 3))` or `c(-2, 0, 2)`.

**Additional Requirements**

- It is generally believed that:
  - `|standardized residual| > 2` requires attention;
  - `> 2.5` requires special attention;
  - `> 3` needs to be inspected carefully.
- The trend line is not the point, the point is the observation point beyond the threshold.
- Place both the title and legend at the top and center them.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

### Leverage Plot

![Leverage Plot](../assets/gallery/regression_diagnostics/leverage.png)

**Applicable Data**

- A fitted linear model object, especially suitable for models with multiple independent variables.
- Focus on identifying high leverage points in the independent variable space.

**Mapping Logic**

- Use `car::leveragePlots(lmfit)` or `car::avPlots(lmfit)`.
- A single panel usually displays the partial regression relationship of an independent variable after controlling for other variables.
- Leverage points typically appear as anomalies in the x direction away from most observations.
- It can also be judged in combination with the `hatvalues(lmfit)` numerical threshold.

**Additional Requirements**

- The commonly used empirical threshold is `(p + 1) / n`, where `p` is the number of independent variables and `n` is the sample size.
- Partial regression plots are suitable for multi-variable models and are not suitable for mechanical simple linear regression with a single independent variable.
- Place both the title and legend at the top and center them.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

### Half-normal Plot of Leverage

**Applicable Data**

- Fitted linear model object.
- The focus is on identifying potential strong influence points through a half-normal plot of leverage values.

**Mapping Logic**

- Use `faraway::halfnorm(h, ylab = "leverage")`.
- Horizontal axis: half-normal quantile.
- Vertical axis: leverage value.
- Points that deviate far from the overall pattern suggest potentially strong influence points.

**Additional Requirements**

- This graph is not an ordinary scatter plot, but a specialized plot for diagnosing the extremes of leverage values.
- Place both the title and legend at the top and center them.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

### Cook's Distance Needle Plot

![Cook's Distance Needle Plot](../assets/gallery/regression_diagnostics/cook.png)

**Applicable Data**

- Fitted linear model object.
- Focus on identifying observations that have a greater impact on model parameter estimates.

**Mapping Logic**

- Use `lindia::gg_cooksd(lmfit)`, or manually organize `.cooksd` and express it with a pin board diagram.
- `x`: observation serial number.
- `y`: Cook distance.

**Additional Requirements**

- The larger the Cook distance is, the stronger the influence of this point on the regression parameter estimation.
- The threshold line should be clearly defined in the graph.
- Place both the title and legend at the top and center them.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

### Influence Index Plot

**Applicable Data**

- Fitted linear model object.
- Multiple diagnostic metrics such as outliers, leverage values, and Cook's distance need to be looked at comprehensively.

**Mapping Logic**

- Use `car::infIndexPlot(lmfit)`.
- Each indicator is expanded according to the observation index to form a lollipop-style comprehensive diagnostic chart.

**Additional Requirements**

- Place both the title and legend at the top and center them.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

### Leverage vs Cook’s Distance Plot

**Applicable Data**

- Fitted linear model object.
- Focus on comprehensively observing the relationship between leverage value and Cook distance to identify points that are abnormal in both dimensions.

**Mapping Logic**

- `x`: Leverage value `.hat`
- `y`: Cook distance `.cooksd`
- Use `geom_point()`.
- Use `stat_smooth(method = "loess")` to draw a trend line.
- Multiple sloping reference lines are available as visual aids to the standardized residual contours.

**Additional Requirements**

- This graph is suitable for identifying observations that have both high leverage and high impact.
- Oblique auxiliary lines must be stated in the figure legend as a visual reference only and not as a direct statistical threshold.
- Place both the title and legend at the top and center them.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

### Leverage-Residual-Cook Bubble Plot

![Leverage-Residual-Cook Bubble Plot](../assets/gallery/regression_diagnostics/joint.png)

**Applicable Data**

- Fitted linear model object.
- It is necessary to fuse the leverage value, standardized residuals and Cook's distance into one graph.

**Mapping Logic**

- `x`: Leverage value `.hat`
- `y`: Standardized residual `.stdresid`
- `size`: Cook distance, such as `exp(.cooksd)` or directly zoom by `.cooksd`
- Use `geom_point(shape = 1)` to draw hollow bubbles.
- Use `geom_hline(yintercept = c(-2, 0, 2))` to add a residual threshold line.
- `scale_size_continuous()` controls the Cook distance bubble size legend.

**Additional Requirements**

- It must be ensured that the `size` map does not exaggerate a few extreme points to the point of completely obscuring other observations.
- It is recommended to use hollow points or low fill transparency to avoid overlapping bubbles.
- Place both the title and legend at the top and center them.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

### Influence Plot

![Influence Plot](../assets/gallery/regression_diagnostics/influence.png)

**Applicable Data**

- Fitted linear model object.
- The goal is to jointly identify outliers, leverage points, and strong influence points using standardized residuals, leverage values, and Cook distance.

**Mapping Logic**

- Use `car::influencePlot(lmfit)`.
- Horizontal axis: hat-values/leverage.
- Vertical axis: Studentized Residuals.
- Bubble size: Cook’s D.
- Automatically mark some abnormal observation numbers.

**Additional Requirements**

- Place both the title and legend at the top and center them.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

## Code Reference
- Original development note: source script `1400-regression-diagnosis-finished.rmd` is not included in the public skill.

## QA

- Do not automatically delete influential points. Verify data accuracy, document decisions, and consider sensitivity analysis.
- Distinguish outliers, high-leverage points, and influential points.
- If assumptions fail, consider transformation, robust regression, nonlinear terms, or alternate model family.