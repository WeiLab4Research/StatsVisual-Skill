# Survival Curve

## Use For

Use survival curves when both event occurrence and time to event matter. Required fields are follow-up time and event status; optional fields include group and covariates.

## Variants

- Kaplan-Meier survival curve.
- Curve truncated to a clinically meaningful follow-up window.
- Median survival line.
- Confidence band.
- Cumulative hazard curve.
- Cumulative event curve.
- Risk table and censor table.
- Adjusted survival curve from Cox model.
- Schoenfeld residual plot for proportional-hazards assumption.
- Deviance/DFBETA diagnostics for Cox model.

## Core Mapping Logic

### Kaplan–Meier Survival Plot

**Applicable Data**

- time-to-event raw data.
- Contains at least:
  - Follow-up time
  - Event indicator variable, usually 1 = event occurred, 0 = censored/alive
  - grouping variable, optional

**Mapping Logic**

- Fit `survfit(Surv(time, event) ~ group, data = df)` first.
- Then use `ggsurvplot()` or `ggsurvfit()` to draw.
- `x`: survival time
- `y`: Cumulative survival probability
- `color = group`
- The censoring mark is drawn on the step curve by default and can be controlled by parameters such as `censor.shape`.

**Additional Requirements**

- The time unit must be specified in the axis title, such as years, months, days.
- The encoding direction of `event` must be clear to avoid inverting the meaning of 0/1.
- The survival curve is a step-shaped curve and should not be mistakenly changed to a smooth polyline.
- Multiple sets of KM curves should be clearly distinguished using color or line type, and legends should be retained.
- Place both the title and legend at the top and center them.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

### Truncated Survival Plot

**Applicable Data**

- Same as conventional survival curve.
- The study focuses on the early period of follow-up, or the long-term censoring is too much, so the display time needs to be limited to a specific window.

**Mapping Logic**

- The base fit is still `survfit(...)`.
- Set in `ggsurvplot()` / `ggsurvfit()`:
  - `xlim = c(t0, t1)`
  - `break.x.by = ...`
- Only the display range is changed, the basic fitting object is not changed.

**Additional Requirements**

- Censoring is often used in scenarios where post-censoring is too high and the number of samples is rapidly reduced.
- The time range of the risk table and the main graph panel must be consistent.
- If critical late differences are lost after censoring, this should be noted in the description.
- Place both the title and legend at the top and center them.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

### Median Survival Reference Plot

**Applicable Data**

- General KM curve object.
- Study highlights include median survival time or median event-free time.

**Mapping Logic**

- Use `surv.median.line = "hv"` in `ggsurvplot()`.
- The horizontal line represents `Survival = 0.5`.
- Vertical lines indicate the median survival time of the corresponding group.

**Additional Requirements**

- Only when the curve drops below 50% is there an identifiable median survival time.
- If the curve never reaches 50%, honestly state that "median survival time has not been reached."
- For multiple group graphs, if the median survival time of each group is different, the cross reference line should be clearly identifiable.
- Place both the title and legend at the top and center them.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

### Survival Plot with Confidence Band

**Applicable Data**

- General KM curve object.
- The focus of the study is to present survival estimates and their uncertainties simultaneously.

**Mapping Logic**

- `ggsurvplot(fit, conf.int = TRUE, ...)`
- Or equivalently add an interval band layer to the `ggsurvfit()` system.
- `fill = group` corresponds to the interval band color.
- `color = group` corresponds to the KM curve color.

**Additional Requirements**

- It must be stated that the interval bands represent 95% confidence intervals.
- The color of the interval band should have low transparency and should not cover the main curve.
- When there are multiple groups, the fill color and curve color must be consistent in the same group.
- Place both the title and legend at the top and center them.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

### Cumulative Hazard Plot

**Applicable Data**

- General survival fitting object.
- The research focus shifts from "survival probability" to "event cumulative risk".

**Mapping Logic**

- Set `fun = "cumhaz"` in `ggsurvplot()`.
- Or set `type = "cumhaz"` in `ggsurvfit()`.
- `x`: Follow-up time
- `y`: Cumulative risk / cumulative hazard function
- `color = group`

**Additional Requirements**

- If the event rate is very low, consider nesting subgraphs to amplify small-scale differences.
- Place both the title and legend at the top and center them.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

### Survival Plot with Risk Table

**Applicable Data**

- The research report needs to provide the number of people at risk and the number of people censored at each time point.
- Typically used for clinical trials or survival curve display in high-quality journals.

**Mapping Logic**

- The commonly used fitting object is `survfit2()`.
- Use `ggsurvfit(fit, type = "survival" or "cumhaz")` for the main image.
- Add table via `add_risktable(risktable_stats = "{n.risk} ({n.censor})", ...)`.
- The main graph and the risk table share the same timeline.

**Additional Requirements**

- Risk table text, line height, and main image width must be coordinated to avoid compressing the main image.
- The order of the risk table must match the order of the curves and legend.
- If the time scale is converted to months or years, the risk table must also use the same scale system simultaneously.
- Place both the title and legend at the top and center them.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

### Survival Curve with Inset Plot

**Applicable Data**

- Cumulative risk or survival is generally low, but early or low-proportion interval differences need to be highlighted.
- Commonly used to display results of cardiovascular or low event rate clinical trials.

**Mapping Logic**

- Main image: KM/cumulative risk plot for the full range.
- Subfigure: Focus on a smaller y-axis range and supplement key HR, P value, event rate and other information through `annotate()`.
- Use `annotation_custom(ggplotGrob(subplot), xmin = ..., xmax = ..., ymin = ..., ymax = ...)` to embed the subfigure into the main image.
- The main chart and subchart usually share the same x-axis time range.

**Additional Requirements**

- The sub-picture must serve to "amplify the difference" and cannot just repeat the main picture.
- The position of the nested graph should avoid the dense area of ​​the main curve.
- Annotations in subfigures, such as `Log-rank P`, `HR (95% CI)`, must be consistent with the statistical results in the main text.
- Nested plots of survival curves are particularly common in cardiovascular and low-event rate studies.
- Place both the title and legend at the top and center them.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

### Survival Curve Comparison Methods Plot

**Applicable Data**

- Two or more groups of survival curve fitting objects.
- The study focused on comparing the P value results of different survival curve testing methods.

**Mapping Logic**

- First, obtain the P value result table of each comparison method through the extended function script.
- `x`：`-log10(p value)`
- `y`: method name
- The results of each method are usually displayed in a dot plot/lollipop plot style.
- Add a vertical reference line to represent `-log10(0.05)` corresponding to `P = 0.05`.

**Additional Requirements**

- This graph is not the KM curve itself, but a "result graph of the KM curve comparison method".
- It must be noted in the description whether the different methods favor early differences, late differences, or cross-curve situations.
- If using an external GitHub script, you must check that the script path exists and that the version is reproducible.
- Suitable for methodological presentation or supplementary material, or as a secondary main figure for complex survival comparisons.
- Place both the title and legend at the top and center them.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

### Integrated Survival-and-Comparison Plot

**Applicable Data**

- There are both standard survival curves, risk number tables and multi-method comparison results.
- The research focus is on "integration of one picture" to display the survival process and comparison between groups.

**Mapping Logic**

- Upper left: KM curve main graph.
- Bottom left: Table of people at risk.
- Right: Multi-method comparison plot.
- Usually `ggdraw()` + `draw_plot()` is used for free layout.
- `patchwork` / `cowplot` can also be used to achieve an approximate layout.

**Additional Requirements**

- The integrated diagram must maintain a clear information hierarchy and cannot sacrifice the readability of the main diagram due to too much information.
- The main curve and the risk table are usually proportionally larger than the comparison plot.
- The risk table and main graph must be precisely aligned on the timeline.
- Place both the title and legend at the top and center them.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

### Schoenfeld Residual Plot

**Applicable Data**

- Fitted Cox proportional hazards model object.
- The study focuses on testing whether the proportional hazards (PH) assumption holds.

**Mapping Logic**

- Fitting model: `coxph(Surv(time, event) ~ covariates, data = df)`
- Inspection object: `cox.zph(res.cox, global = TRUE)`
- Drawing: `ggcoxzph(test.ph, var = c(...))`
- `x`: time
- `y`: Standardized Schoenfeld residuals
- The spline represents the trend of the residuals over time.

**Additional Requirements**

- If the smooth line is nearly horizontal, the points are roughly within ±2 SD, and test `p > 0.1` is generally supported, the PH hypothesis is supported.
- You must check covariate by covariate, not just the global test.
- This plot tests the Cox model assumptions, not the KM curve itself.
- The order of the panels should be consistent with the order of the covariates in the Cox model.
- Place both the title and legend at the top and center them.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

### Cox Deviance Residual Plot

**Applicable Data**

- Fitted Cox model object.
- Research focuses on identifying potential outliers and abnormally fitting individuals.

**Mapping Logic**

- Use `ggcoxdiagnostics(res.cox, type = "deviance", ...)`.
- `x`: observation number or linear prediction value (according to parameter settings)
- `y`：Deviance residuals
- LOESS smooth lines and their intervals can be preserved.

**Additional Requirements**

- Deviance residuals have a mean of approximately 0 and a standard deviation of approximately 1.
- In general, observations outside the `±1.96` standard error range deserve closer inspection.
- A positive residual indicates that the actual outcome was earlier than the model predicted, and a negative residual indicates that the outcome was later than the model predicted.
- If users need to identify impact points, they can further use extended diagnosis such as `type = "dfbeta"`.

### Adjusted Survival Curve

**Applicable Data**

- Fitted Cox model object.
- The focus of the study was to demonstrate differences in the survival process of the primary exposure factors after controlling for covariates.
- Suitable for observational studies or scenarios where significant confounding factors exist.

**Mapping Logic**

- Fitting model: `coxph(Surv(time, event) ~ exposure + covariates, data = df)`
- Use `ggadjustedcurves(fit, data = df, variable = "exposure", method = "average", ...)`
- `x`: survival time
- `y`: Corrected survival probability
- `color = exposure group`

**Additional Requirements**

- It must be made clear that this is not the original KM curve, but the covariate-corrected estimated curve.
- Corrected curves usually no longer have censored points marked.
- Comparison with uncorrected curves should be recommended to observe the impact of covariates on differences between groups.
- Suitable for reporting visualization results that are closer to "independent exposure effects"

## Template Starter

- Use `assets/templates/km_survival.R` as the starter template for Kaplan-Meier survival curves with risk tables. Copy it into `<project_dir>/R/` and adapt the time, event, grouping, labels, and style-specific annotations before running.
## Code Reference
- Original development note: source script `1600-survival-finished.Rmd` is not included in the public skill.

## QA

- Verify event coding: usually `1 = event`, `0 = censored`.
- Include time unit in x-axis title.
- Mark censoring unless the target style explicitly omits it.
- Provide number at risk at clinically meaningful time points.
- Use log-rank tests for unadjusted group comparison; use Cox model for adjusted effects.
- Check proportional-hazards assumption when reporting Cox hazard ratios.

