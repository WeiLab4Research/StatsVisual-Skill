# Linear Regression

## Use For

Use linear regression graphics when two variables show an approximately linear relationship or when a fitted linear model needs visual communication.

## Core Mapping Logic

### Linear Regression Plot

**Applicable Data**

- One continuous independent variable and one continuous dependent variable.
- The goal is to show the linear relationship between the two indicators and the conditional mean regression line.

**Mapping Logic**

- `x`: continuous independent variable.
- `y`: continuous dependent variable.
- Use `ggscatter()` or `geom_point()` + `geom_smooth(method = "lm")`.
- The regression line represents the conditional mean estimate.
- `conf.int = TRUE` or `geom_smooth(se = TRUE)` represents the 95% confidence interval band.
- The regression equation can be added with `stat_poly_eq(formula = y ~ x)` and `R²`.
- You can further add marginal boxplots above and to the right using `ggMarginal()`.

**Additional Requirements**

- It is necessary to write the linear regression equation in the appropriate position
- Place both the title and legend at the top and center them.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

### Linear Regression with Confidence and Tolerance Bands

**Applicable Data**

- One continuous independent variable and one continuous dependent variable.
- The goal is not only to show the regression relationship, but also to express simultaneously the 95% confidence interval for the conditional mean and the tolerance/prediction interval for the individual values.

**Mapping Logic**

- Fit `lm(y ~ x)` first.
- Use `predict(lmfit)` to get the regression fitting value `yhat`.
- Use `predict(lmfit, interval = "prediction", level = 0.95)` to get:
  - `fit`
  - `lwr`
  - `upr`
- Layer structure:
  - `geom_point()`: original observation;
  - `geom_smooth(method = "lm", se = TRUE)`: regression line + 95% confidence interval band;
  - `geom_line(aes(y = lwr), linetype = "dashed")`: lower prediction interval band;
  - `geom_line(aes(y = upr), linetype = "dashed")`: Upper prediction interval band.
- Potential outliers can be defined based on points outside the prediction interval and mapped to different colors.

**Additional Requirements**

- A clear distinction must be made between:
  - Confidence interval band: uncertainty about the conditional mean;
  - Tolerance interval/prediction interval band: The range of fluctuations in individual `y` values ​​given `x`.
- It is necessary to write the linear regression equation in the appropriate position
- Place both the title and legend at the top and center them.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

### Bivariate Ellipse Interval

**Applicable Data**

- Two continuous variables and are related.
- The goal is to express a two-dimensional reference range rather than a single linear prediction.

**Mapping Logic**

- `x`: Continuous variable 1, such as weight.
- `y`: Continuous variable 2, such as height.
- `geom_point()`: original observation point.
- `geom_smooth(method = "lm")`: Overall linear trend line.
- `stat_ellipse(geom = "polygon", level = 0.95)`: 95% reference ellipse.
- `stat_poly_eq()`: Add regression equation with `R²`.

**Additional Requirements**

- The reference value ellipse is not an ordinary confidence interval band, but a joint reference range in two-dimensional space.
- Suitable for identifying joint outliers of two related metrics.
- It is necessary to write the linear regression equation in the appropriate position
- Place both the title and legend at the top and center them.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

### Regression with Deviations

**Applicable Data**

- One continuous independent variable and one continuous dependent variable.
- The goal is to visually display the vertical deviation of each observation from the regression line.

**Mapping Logic**

- The base layer is still a linear regression graph:
  - `geom_point()` or `ggscatter()`
  - `geom_smooth(method = "lm")`
- Use `stat_fit_deviations(formula = y ~ x)` to superimpose error bars for each point onto the regression line.
- `x`: continuous independent variable.
- `y`: continuous dependent variable.

**Additional Requirements**

- Error bars should weaken the transparency to avoid overly cluttering the entire image.
- It is necessary to write the linear regression equation in the appropriate position
- Place both the title and legend at the top and center them.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

### Linear Regression Response Surface

**Applicable Data**

- Two continuous independent variables + one continuous dependent variable.
- The goal is to show the fitting results of a planar linear regression model in three-dimensional space.

**Mapping Logic**

- Fitting model: `lm(y ~ x1 + x2)`.
- Generate a regular grid based on independent variable ranges:
  - `axis_x`
  - `axis_y`
- Use `predict.lm(newdata = grid)` to get `z` on the response surface.
- Organize into a matrix using `acast()` or equivalent.
- Use `plot_ly()`:
  - `type = "scatter3d"` displays the original scatter points;
  - `type = "surface"` displays a linear regression response surface.

**Additional Requirements**

- The core of the response surface diagram is to display a two-independent variable linear model, which is not suitable for forcing too many model comparisons.
- The mesh resolution needs to be moderate; too fine will increase the rendering burden, and too thick will make the surface uneven.
- Interactive graphs are more suitable for response surfaces; if you export static graphs, you need to choose a perspective that can see the point cloud and surface clearly at the same time.
- Place both the title and legend at the top and center them.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

### Regression Performance Radar Plot

**Applicable Data**

- Performance evaluation results of multiple regression models.
- The goal is to compare the comprehensive performance of different models on `R²`, adjusted `R²`, AIC, RMSE`、`Sigma` and other indicators.

**Mapping Logic**

- First fit multiple `lm()` models.
- Use `compare_performance(..., metrics = "all", rank = TRUE)` to obtain a model performance table.
- Adjust the scale of some indicators, such as `RMSE/100`, `Sigma/100`, to adapt to the common dimensions of radar charts.
- Use `ggradar()`:
  - Each model acts as a closed polyline;
  - Each performance indicator serves as a radial axis;
  - `group.colours` differentiates between models.

**Additional Requirements**

- The following elements need to be included: center of circle (hollow circle); radiation axis (each axis represents a variable/indicator); concentric circles: numerical scale (value increases from inner → outer)
- Place both the title and legend at the top and center them.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

## Code Reference
- Original development note: source script `1200-linear-regression-finished.Rmd` is not included in the public skill.

## Model Reporting

Include:

- Regression coefficient with 95% CI.
- Model covariates.
- `n` used in model after missingness.
- Whether bands are confidence bands or prediction/reference bands.

## QA

- Check linearity, independence, normality, and equal variance assumptions.
- Inspect residuals and influence before presenting a fitted line as the main result.
- Do not confuse correlation, unadjusted regression, and adjusted regression.

