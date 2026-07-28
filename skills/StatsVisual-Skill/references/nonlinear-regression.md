# Nonlinear Regression

## 1. Scope and Definition

Nonlinear regression is used when the conditional relationship between an outcome and one or more predictors cannot be represented adequately by a straight line. The nonlinear pattern may be specified through polynomial terms, a biologically interpretable nonlinear function, or a flexible model for conditional quantiles.

Polynomial regression is nonlinear in the predictor but linear in its coefficients. Nonlinear least-squares models are nonlinear in one or more parameters and require an explicit functional form. Quantile regression estimates conditional quantiles rather than the conditional mean.

## 2. Selection Guide

| Analytical purpose | Recommended chart |
|---|---|
| Display a polynomial conditional-mean relationship | Polynomial Regression Plot |
| Select polynomial degree using predictive error | Polynomial Degree Selection Plot |
| Fit exponential, asymptotic, power, logarithmic, or hyperbolic relationships | Convex–Concave Curve Regression Plot |
| Fit logistic, Gompertz, log-logistic, or Weibull-shaped responses | Sigmoid Curve Regression Plot |
| Compare conditional outcome quantiles across a predictor | Quantile Regression Plot |
| Show how one regression coefficient changes across quantiles | Quantile Regression Coefficient Plot |
| Model a nonlinear conditional-quantile relationship | Smoothed Quantile Regression Plot |

## 3. Required Data Structure

- Each observation should contain a continuous outcome and a correctly scaled predictor. Preserve subject or replicate identifiers when observations are repeated or clustered.
- Polynomial models require adequate coverage across the predictor range. Nonlinear least-squares models additionally require a prespecified formula, interpretable parameters, and plausible starting values.
- Logarithmic, power, log-logistic, and Weibull forms require predictor values within the mathematical domain of the selected function, commonly `x > 0`.
- Quantile regression requires individual-level observations. A coefficient plot additionally requires one estimate and interval for each fitted quantile.
- Record transformations, exclusions, missing-data handling, units, and the analysis sample used for each model.

## 4. Common Statistical Principles

- Select the functional form from biomedical knowledge, the data-generating mechanism, and diagnostics rather than visual fit alone.
- Control model complexity with cross-validation, information criteria, or a prespecified rule. High-degree polynomials and highly flexible smooths can fit noise and behave poorly near boundaries.
- Nonlinear least-squares estimates may depend on starting values and can converge to local solutions. Check convergence, parameter plausibility, and sensitivity to alternative starts.
- Retain observed data when assessing fit, and examine residual structure, heteroscedasticity, influential observations, and unsupported extrapolation.
- Repeated measurements from the same experimental unit are correlated. A curve fitted as though all observations were independent may have invalid uncertainty estimates.
- Quantile regression estimates the conditional quantile of the outcome. Differences across quantiles do not automatically imply distinct biological subgroups.

## 5. Common Visual Rules

- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.
- Add value labels only when they improve interpretation without crowding the figure.
- Retain raw observations when they are needed to judge data support, dispersion, and influential points.
- Keep axes, units, parameter labels, group encodings, and interval meanings consistent across model-comparison panels.

## 6. Variants

### Polynomial Regression Plot

![Polynomial Regression Plot](../assets/gallery/nonlinear_regression/polynomial.png)

**Statistical Methods and Features**

- Estimates the conditional mean using powers of the predictor. Although the fitted curve is nonlinear in `x`, the model is linear in its regression coefficients.
- Polynomial degree should be selected before final interpretation. High-order terms may create unstable turning points and poor boundary behavior.
- Individual polynomial coefficients are usually not clinically interpretable; interpretation should focus on the fitted relationship, contrasts, or predicted values.

**Code Features**

- Fit candidate models with `lm()` or `glm()` using `poly(x, degree = k)` and draw the selected curve with `stat_smooth(method = "lm", formula = y ~ poly(x, k))`.
- Use the same polynomial basis for fitting, prediction, and plotting. Retain `geom_point()` and limit predictions to the observed predictor range.

- code reference: source script `\StatsVisual-Skill\assets\templates\nonlinear_regression\Polynomial Regression Plot.R`

### Polynomial Degree Selection Plot

**Statistical Methods and Features**

- Compares out-of-sample prediction error across candidate polynomial degrees.
- The degree with the smallest cross-validation error is a predictive choice, not proof that the true biological relationship has that polynomial order.
- Use reproducible folds and avoid selecting among excessively high degrees when sample size or predictor coverage is limited.

**Code Features**

- Fit each candidate with `glm(y ~ poly(x, degree = i))` and calculate cross-validation error using `boot::cv.glm()`.
- Store degree and error in a separate table, draw them with `geom_line()` and `geom_point()`, and mark the selected degree with `which.min()` or a prespecified one-standard-error rule.

### Convex–Concave Curve Regression Plot

![Convex–Concave Curve Regression Plot](../assets/gallery/nonlinear_regression/convex_concave.png)

**Statistical Methods and Features**

- Fits a prespecified nonlinear mean function such as exponential growth or decay, an asymptotic curve, a power function, a logarithmic curve, or a rectangular hyperbola.
- Function choice should reflect the expected biological process. Saturation, decay rate, and asymptote parameters should be interpreted only when supported by the observed range.
- Replicate measurements do not become independent because they are plotted separately; dependence should be addressed in formal inference.

**Code Features**

- Use `stat_smooth(method = "nls", method.args = list(formula = ..., start = ...), se = FALSE)` with an explicit function and plausible starting values.
- Check the domain of each formula, especially `log(x)` and `x^b`, and compare candidate functions on a consistent dataset and predictor range.

- code reference: source script `\StatsVisual-Skill\assets\templates\nonlinear_regression\Convex–Concave Curve Regression Plot.R`

### Sigmoid Curve Regression Plot

![Sigmoid Curve Regression Plot](../assets/gallery/nonlinear_regression/sigmoid.png)

**Statistical Methods and Features**

- Models responses with a transition region and plateau, including logistic, Gompertz, log-logistic, and Weibull-shaped curves.
- Parameters may represent an upper asymptote, slope, and midpoint or inflection-related location, but their exact meaning depends on the chosen parameterization.
- Three-parameter forms commonly fix the lower asymptote. Use a four-parameter model when a nonzero lower plateau is scientifically required and supported by the data.

**Code Features**

- Fit each model with `stat_smooth(method = "nls", method.args = list(formula = ..., start = ...), se = FALSE)`.
- Use positive predictor values for formulas containing `log(x)`, supply model-specific starting values, and verify convergence before comparing fitted curves.

- code reference: source script `\StatsVisual-Skill\assets\templates\nonlinear_regression\Sigmoid Curve Regression Plot.R`

### Quantile Regression Plot

![Quantile Regression Plot](../assets/gallery/nonlinear_regression/quantile.png)

**Statistical Methods and Features**

- Estimates the relationship between a predictor and selected conditional quantiles of the outcome rather than its conditional mean.
- Differences in slope across quantiles indicate that the predictor–outcome association varies across the conditional outcome distribution.
- Quantile regression is less sensitive to extreme outcome values than least squares, but it is not immune to influential predictor values or model misspecification.

**Code Features**

- Draw selected linear quantile fits with `geom_quantile(quantiles = ...)` while retaining the observed points.
- Use a limited, prespecified set of quantiles and transform the predictor in the data or formula before fitting when a logarithmic exposure scale is intended.

- code reference: source script `\StatsVisual-Skill\assets\templates\nonlinear_regression\Quantile Regression Plot.R`

### Quantile Regression Coefficient Plot

**Statistical Methods and Features**

- Displays one exposure or predictor coefficient across fitted conditional quantiles of the outcome.
- The horizontal axis represents the outcome quantile level; the vertical axis represents the estimated coefficient at that quantile.
- Interval estimates should identify the method used, such as bootstrap or asymptotic standard errors. Crossing zero indicates compatibility with no association at that quantile under the stated interval procedure.

**Code Features**

- Store `quantile`, coefficient estimate, lower limit, and upper limit in a tidy table.
- Draw the estimate with `geom_line()`, the interval with `geom_ribbon()`, and add `geom_hline(yintercept = 0)` as the no-association reference.

### Smoothed Quantile Regression Plot

**Statistical Methods and Features**

- Estimates nonlinear conditional-quantile curves when a straight quantile-regression line is inadequate.
- The smoothing parameter controls curve flexibility; small values may overfit, while large values may suppress clinically meaningful variation.
- Multiple fitted quantiles should preserve their logical order. Quantile crossing indicates model instability or insufficient constraints.

**Code Features**

- Use `geom_quantile(method = "rqss", lambda = ...)` with selected quantiles and retain the raw observations.
- Choose `lambda` using sample size, diagnostics, and sensitivity analysis rather than a fixed default, and inspect fitted curves for boundary instability and quantile crossing.

## 7. QA Checklist

- Confirm the scientific rationale for the selected function, polynomial degree, or quantile model.
- Verify predictor and outcome units, transformations, mathematical domain, missing-data handling, and the analysis sample.
- For polynomial models, inspect cross-validation stability and boundary behavior.
- For nonlinear least squares, check starting values, convergence warnings, parameter plausibility, and sensitivity to alternative starts.
- Examine residuals, heteroscedasticity, influential observations, repeated-measure dependence, and data coverage across the fitted range.
- For quantile models, report fitted quantiles and interval method, and check sparse tails, overfitting, and quantile crossing.
- Do not extrapolate beyond the observed predictor range or interpret the fitted shape as causal evidence without an appropriate study design.
