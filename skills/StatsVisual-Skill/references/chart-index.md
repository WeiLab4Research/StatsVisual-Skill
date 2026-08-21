# Chart Index

Use this index to move from data structure and scientific intent to a chart reference. Load the detailed chart file only after the route is clear.

## First Questions

Before routing to a chart, answer these questions from the data profile:

- What is the target message: comparison, trend, relationship, distribution, composition, diagnosis, survival, or model fit?
- Which variables are continuous, categorical, ordered categorical, time/date, event status, or high-dimensional features?
- Is the unit of analysis individual-level, aggregated, repeated-measure, or matrix-like?
- Does the plot need to show uncertainty, sample size, statistical tests, or model predictions?

## Common Routes

Map the data structure and research intent to a recommended chart family first, then use the `Chart family → Reference` table below to load the detailed reference.

| Data / intent | Prefer | Good alternatives | Notes |
| --- | --- | --- | --- |
| One continuous variable | Histogram or density plot | Boxplot, violin, QQ plot | Show distribution shape before summary-only graphics. |
| Continuous outcome by 2+ groups | Boxplot plus jitter or violin | Raincloud, dot plot with CI | Use raw points when sample size is not too large. |
| Mean/rate/proportion by groups | Bar chart with CI or count labels | Dot plot, forest-style interval plot | Avoid bars for raw continuous observations. |
| Two continuous variables | Scatter plot | Scatter with regression, density scatter, bubble plot | Add smoothing only when it supports the question. |
| Many pairwise continuous variables | Scatterplot matrix | Correlation heatmap | Use only selected variables for readability. |
| Time or ordered x variable | Line plot | Area, step, calendar, streamgraph | Use points when observations are sparse. |
| Cumulative event over time | Step plot | Survival curve | Be explicit about risk set and censoring. |
| Time-to-event outcome | Kaplan-Meier curve | Cumulative hazard, forest plot for Cox model | Include risk table when useful. |
| Categorical composition | Stacked bar | 100% stacked bar, mosaic-like plot | Label denominators or percentages. |
| Categorical numeric summaries with `>25` categories where the goal is frequency, proportion, composition, absolute contribution, burden, or overview ranking | Polar plot or rose chart | | Use circular layouts for compact overview messages, not for significance-value precision, correlation-coefficient comparison, thresholds, P values, CIs, significance marks, or adjusted-versus-unadjusted differences. |
| Part-to-whole with few categories | Bar chart | Pie/donut only for simple composition | Prefer bars when comparing slices matters. |
| High-dimensional numeric matrix | Heatmap | Clustered heatmap, annotated heatmap | Standardize rows/columns only when scientifically justified. |
| Three components summing to one | Ternary plot | Stacked bar if groups are discrete | Validate that components sum to a constant. |
| Model diagnostics | Residual plot | QQ plot, influence plot, calibration curve | Tie chart to model assumptions. |
| Regression estimates | Forest plot | Coefficient dot-whisker plot | Show effect size, CI, reference group, and scale. |

## Chart Family → Reference

| Chart family | Suitable data structure | Main message | Reference |
|---|---|---|---|
| Bar chart | One categorical variable plus count, proportion, rate, mean, or other summary; optional grouping | Compare magnitudes across categories or ordered groups | `bar-chart.md` |
| Line chart | Time/order variable plus numeric outcome; optional repeated groups | Show trend, trajectory, time series, cumulative process, or connected ordered values | `line-chart.md` |
| Pie chart | Few mutually exclusive parts that sum to one whole | Show simple composition only when exact comparison is not the goal | `pie-chart.md` |
| Histogram | One continuous variable; optional grouping | Show distribution shape, center, spread, skewness, multimodality, or potential outliers | `histogram.md` |
| Cleveland dot plot | Categories or indicators plus numeric estimates; optional groups | Rank many values more precisely than bars or pies | `cleveland-dot-plot.md` |
| Box plot | Continuous outcome plus optional categorical grouping | Compare distributions using median, IQR, spread, and outliers | `box-plot.md` |
| Scatter plot | Two continuous variables; optional group, size, label, or density | Show association, covariance, clusters, outliers, or dose-response pattern | `scatter-plot.md` |
| Heatmap | Numeric matrix, correlation matrix, omics abundance matrix, or two-dimensional binned values | Show pattern across many variables, samples, or categories | `heatmap.md` |
| Ternary plot | Three non-negative components that sum to a constant, often 1 or 100% | Show three-part composition in a two-dimensional triangle | `ternary-plot.md` |
| Q-Q plot | Sample values or p-values compared with theoretical quantiles | Check distributional assumptions, inflation, or tail deviations | `q-q-plot.md` |
| Probability and statistical distribution plot | Distribution family parameters or theoretical/empirical density/probability values | Explain probability distributions or compare parameter effects | `probability-distribution-plot.md` |
| Smoothing curve | Ordered x plus numeric y where local/nonlinear trend is the focus | Reveal trend while preserving raw-data context | `smoothing-curve.md` |
| Linear regression | Two continuous variables or model output from linear model | Show fitted linear association, uncertainty, and assumptions | `linear-regression.md` |
| Nonlinear regression | Continuous x-y relation with nonlinear pattern or mechanistic curve | Show polynomial, spline, segmented, logistic, exponential, or NLS fit | `nonlinear-regression.md` |
| Regression model diagnostics | Fitted model object, residuals, leverage, fitted values, covariates | Check LINE assumptions, influence, heteroscedasticity, normality, and collinearity | `regression-diagnostics.md` |
| Survival curve | Time-to-event variable plus event indicator and optional group/covariates | Show Kaplan-Meier survival, cumulative hazard/event, risk table, and Cox diagnostics | `survival-curve.md` |
| Forest plot | Effect estimates plus confidence intervals, usually subgroups or meta-analysis | Compare effect sizes and uncertainty across terms or studies | Use `forest-plot.md` plus model/effect-size rules |
| Polar plot / Polar bar plot / Grouped polar bar plot / Polar dot plot / Annular polar scatter | Multiple categorical groups (`>25`) with numeric values where the goal is frequency, proportion, composition, absolute contribution, burden, or overview ranking; optional grouping, radius, size and color dimensions | Show compact categorical overviews for dense category sets | Use `special-charts.md` plus polar layout, central blank, grouped/ring rules, and radial label rules |
| Radar chart | 2-6 comparison groups with 3-8 normalized, consistent numeric measurement axes | Compare standardized multi-dimensional profiles and comprehensive domain performance across groups | Use `special-charts.md` plus normalized axis and group limit rules |
| Stream / river chart | Continuous ordered time variable, numeric magnitude values and discrete stratified categories | Show dynamic compositional changes and dominant component shifts across longitudinal time series | Use `special-charts.md` plus temporal composition and stratum collapsing rules |
| Rose chart | More than 25 ranked categorical items with non-negative frequency, proportion, composition, absolute contribution, or burden values | Display circular ranked magnitude overview and burden distribution across numerous categories | Use `special-charts.md` plus area-proportional encoding, central blank, and bar-adjacent label rules |
| Fourfold plot | 2x2 binary contingency table with count values; optional stratified subgroup layers | Visualize binary association, statistical independence and odds ratio imbalance for clinical pairwise data | Use `special-charts.md` plus 2x2 table and odds ratio interpretation rules |
| Spiral histogram | High-frequency periodic time series with repeated seasonal or circadian cyclic cycles | Reveal rhythmic periodicity and cyclic fluctuation trends in repeated time-series datasets | Use `special-charts.md` plus cyclic visualization and threshold annotation rules |
| Manhattan plot | Genomic chromosome labels, variant position data and association p-values with optional variant labels | Identify and visualize genome-wide significant association signals and key susceptibility loci | Use `special-charts.md` plus GWAS threshold and genomic annotation rules |
| Sunflower density plot | Bivariate discrete or rounded numeric paired data with severe duplicate point overlap | Resolve point overlap and quantify duplicate observation density for discrete bivariate measurements | Use `special-charts.md` plus overlap-density and petal-count encoding rules |
| Bubble chart | Two continuous core variables, one positive magnitude size variable and optional categorical color grouping | Visualize four-dimensional associations among continuous metrics, magnitude scale and subgroup characteristics | Use `special-charts.md` plus area-scaling and multi-variable encoding rules |
| LOWESS smooth curve | Ordered numeric or date x-variable, continuous numeric y-outcome; optional grouping strata | Explore and visualize descriptive nonlinear trends while retaining original raw data context | Use `special-charts.md` plus span parameter and raw-data overlay rules |
| Model-diagnostic bubble plot | Fitted regression model or diagnostic data frame with leverage, standardized/studentized residuals, and Cook's distance | Screen influential observations by combining leverage, residual extremeness, and Cook's distance in one panel | Use `special-charts.md` plus Cook's-distance sizing, residual reference lines, and leverage/influence-screening rules |
| Density ternary plot | Three non-negative components that form a constant-sum composition, with many observations or severe point overlap; optional density surface and raw points | Show where three-part compositions concentrate and distinguish high-density from sparse regions in ternary space | Use `special-charts.md` plus ternary density, normalization, and raw-point overlay rules |

## Manuscript-Derived Figure Families

The source manuscript covers bar chart, line chart, pie chart, histogram, Cleveland dot plot, box plot, scatter plot, heatmap, ternary plot, Q-Q plot, probability/statistical distribution plot, smoothing curve, linear regression, nonlinear regression, regression model diagnostics, and survival curve. Keep all of these families available, but choose by data structure and intent rather than by template availability.
