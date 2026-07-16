# Nonlinear Regression

## Use For

Use nonlinear regression graphics when scatter or theory suggests a nonlinear relationship. Choose the model from science and diagnostics, not from visual appeal alone.

## Variants

- Polynomial regression.
- Restricted cubic spline.
- Natural spline.
- GAM.
- Segmented regression.
- Logistic, exponential, saturation, or other mechanistic nonlinear model.
- Quantile regression.

## Core Mapping Logic

### Polynomial Regression Plot

![Polynomial Regression Plot](../assets/gallery/nonlinear_regression/polynomial.png)

**Applicable Data**

- One continuous independent variable and one continuous dependent variable.
- The scatterplot shows a clear nonlinear trend, but it is still desirable to express the conditional mean relationship in polynomial form.

**Mapping Logic**

- `x`: continuous independent variable.
- `y`: continuous dependent variable.
- Raw observations use `geom_point()`.
- The fitting curve is drawn with `stat_smooth(method = "lm", formula = y ~ poly(x, k))`.
- `k` is the polynomial order, which is usually determined through cross-validation first.
- If a credible interval is required, the default band of `stat_smooth()` can be retained; if the manuscript style emphasizes the fitting line more, the band can be appropriately weakened or not displayed.

**Additional Requirements**

- The order should not be specified arbitrarily. Cross-validation, AIC, BIC or other criteria should be used first.
- Scatter points should be retained as a background layer to allow readers to judge whether the fitted curve reasonably fits the original trend.
- Place both the title and legend at the top and center them.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

### Polynomial Degree Selection Plot

**Applicable Data**

- Same as the polynomial regression plot, but the task focuses on comparing the cross-validation errors corresponding to different orders.

**Mapping Logic**

- First loop through different orders of fitting `glm(y ~ poly(x, degree = i))`.
- Use `boot::cv.glm()` to calculate the cross-validation error for each order.
- `x`: Polynomial order.
- `y`：CV error。
- Use `geom_line()` + `geom_point()`.
- Mark the optimal order with extra emphasis, such as `which.min(cv_error)`.

**Additional Requirements**

- This plot is usually combined into a double panel with the final polynomial fit plot and must be labeled `A / B`.
- Place both the title and legend at the top and center them.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

### Convex–Concave Curve Regression Plot

![Convex–Concave Curve Regression Plot](../assets/gallery/nonlinear_regression/convex_concave.png)

**Applicable Data**

- One continuous independent variable and one continuous dependent variable.
- The scatter points show obvious concave, convex, asymptotic, power law, logarithmic or rectangular hyperbolic trends.

**Mapping Logic**

- `x`: Continuous independent variable, such as concentration.
- `y`: Continuous response variable, such as absorbance.
- The original point uses `geom_point()`.
- The fitting layer uses `stat_smooth(method = "nls", method.args = list(formula = ..., start = ...), se = FALSE)`.
- Different function families correspond to different formulas, for example:
  - Exponential growth: `y ~ a * exp(k * x)`
  - Exponential decay: `y ~ a - (b - a) * exp(-x / c)`
  - Asymptotic function: `y ~ a - (a - b) * exp(-c * x)`
  - Power function: `y ~ a * x^b`
  - Logarithmic function: `y ~ a + b * log(x)`
  - Rectangular hyperbola: `y ~ a * x / (b + x)`

**Additional Requirements**

- If there are multiple replicate runs of the data, the original batches can be color-coded, but the fitted lines are usually kept solid color to highlight the overall trend.
- When comparing multiple functions, a unified multi-panel layout should be used.
- Place both the title and legend at the top and center them.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

### Sigmoid Curve Regression Plot

![Sigmoid Curve Regression Plot](../assets/gallery/nonlinear_regression/sigmoid.png)

**Applicable Data**

- One continuous independent variable and one continuous dependent variable.
- The scatter points show obvious S-type, threshold type, plateau type or saturation type relationships.
- Typical examples include concentration-response curve, dose-effect curve, ELISA standard curve, etc.

**Mapping Logic**

- `x`: Continuous independent variable, such as concentration.
- `y`: Continuous response variable, such as OD value.
- The original point uses `geom_point()`.
- The fitting layer uses `stat_smooth(method = "nls", method.args = list(formula = ..., start = ...), se = FALSE)`.
- The main functions involved in this chapter include:
  - Logistic / 3 params：`y ~ d / (1 + exp(-b * (x - e)))`
  - Gompertz / 3 params：`y ~ d * exp(-exp(-b * (x - e)))`
  - Log-logistic / 3 params：`y ~ d / (1 + exp(-b * (log(x) - log(e))))`
  - Weibull / 3 params：`y ~ d * exp(-exp(-b * (log(x) - log(e))))`

**Additional Requirements**

- Place both the title and legend at the top and center them.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

### Quantile Regression Plot

![Quantile Regression Plot](../assets/gallery/nonlinear_regression/quantile.png)

**Applicable Data**

- One continuous independent variable and one continuous dependent variable.
- The focus of the study is not the conditional mean, but the conditional quantiles, such as 10%, 50%, and 90% quantiles.
- Suitable for scenarios with heteroskedasticity, outliers, or inconsistent effects across different quantiles.

**Mapping Logic**

- `x`: Continuous independent variable, such as `X88Sr`.
- `y`: Continuous dependent variable, such as `birthweight`.
- The original point uses `geom_point()`.
- Quantile regression lines are drawn with `geom_quantile(quantiles = seq(...))`.
- Multiple quantile lines are superimposed at the same time. By default, `0.1 ~ 0.9` is commonly used for multiple quantiles.
- Use a unified color and reduce transparency to highlight the overall quantile sector structure.

**Additional Requirements**

- The number of quantile lines should not be too many, otherwise the graph will be too dense; usually 0.1–0.9 with a step size of 0.05 or 0.1 is sufficient.
- Place both the title and legend at the top and center them.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

### Quantile Regression Coefficient Plot

**Applicable Data**

- The coefficient estimates and intervals corresponding to different quantiles have been extracted from the quantile regression model.

**Mapping Logic**

- `x`: Quantile level.
- `y`: Regression coefficient estimate.
- The main line uses `geom_line()`.
- The interval band uses `geom_ribbon(aes(ymin = ..., ymax = ...))`.
- Auxiliary lines:
  - `geom_hline(yintercept = 0)` indicates no effect line;
  - `geom_vline()` can mark key quantiles of interest.

**Additional Requirements**

- This plot is better for visualizing how effects change across quantiles than multiple quantile regression lines.
- A clear distinction must be made between:
  - Horizontal axis: conditional quantile of the outcome variable;
  - Vertical axis: regression coefficient of exposure or independent variable.
- Low saturation fill colors should be used for interval bands and accent colors for main coefficient lines.
- Place both the title and legend at the top and center them.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

### Smoothed Quantile Regression Plot

**Applicable Data**

- Same as a normal quantile regression plot, but the focus is on obtaining a smoother quantile curve.
- It is often used when there are enough sample points and it is suspected that there is a nonlinear quantile trend that linear quantile regression cannot adequately express.

**Mapping Logic**

- `x`: continuous independent variable.
- `y`: continuous dependent variable.
- The original point uses `geom_point()`.
- The quantile fitting layer uses `geom_quantile(method = "rqss", lambda = ...)`.
- `lambda` controls the degree of smoothing.
- Multiple quantile curves can be displayed simultaneously.

**Additional Requirements**

- The selection of `lambda` should be based on the sample size and curve complexity, and should not mechanically apply a fixed value.
- Place both the title and legend at the top and center them.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

## Code Reference
- Original development note: source script `1300-nonlinear-regression-finished.Rmd` is not included in the public skill.

## QA

- Use cross-validation, AIC, domain knowledge, or pre-specified model choice when comparing forms.
- Report transformation and parameter interpretation.
- Guard against overfitting, especially with high-degree polynomials.
- Check convergence and sensitivity to starting values for NLS.