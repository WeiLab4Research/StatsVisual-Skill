# Publication QA

Run this checklist before final delivery. Use it together with `readability-qa.md`; this file defines the delivery gate, while `readability-qa.md` defines detailed readability thresholds and fixes.

## Required Scripted Checks

- Run `scripts/validate_r_plot.R <project_dir>/figures` to verify PDF, SVG, TIFF, and web image presence.
- Run `scripts/validate_figure_readability.R <plot_rds> <project_dir>/figures <figure_name> <width_in> <height_in> <project_dir>` to verify final-size readability.
- Confirm the R script can be rerun from the project root.

## Delivery-Blocking Failures

- Missing or empty PDF, SVG, TIFF, or web image.
- TIFF exported below the requested DPI.
- SVG lacks editable text when editable vector text is feasible for the chart type.
- Readability QA reports `FAIL`, including a visually collapsed subgroup or panel.
- A bar chart uses a truncated length axis without a clear scientific reason.
- Statistical annotations contradict computed/provided values.
- Survival event coding, censoring, or time unit is unverified for survival graphics.
- A multi-panel figure is only a collage and does not match the figure plan.
- A categorical numeric summary with `>25` categories and a frequency, proportion, composition, absolute contribution, burden, or overview-ranking message uses a tall bar/dot layout when a polar plot or rose chart would be more legible.
- A categorical numeric summary uses a rose chart or polar plot as the primary figure for significance-value precision, correlation-coefficient precision, threshold judgment, P values, CIs, significance marks, or adjusted-versus-unadjusted differences.

## Warnings To Resolve Or Report

- Any panel uses less than 20% of its axis span.
- Panel data spans differ more than 10-fold under a shared axis.
- Labels, legends, or annotations crowd the main data.
- Font sizes are borderline at the final journal size.
- Color contrast is weak or too many categories are encoded by color alone.
- Group sizes, missing-value handling, transformations, scaling, clustering, denominators, interval definitions, or model/test sources are not explicit.
- Web image size can only be kept under 1 MB by making the preview hard to read.

## Visual Review

When image viewing is available, inspect the final web PNG or TIFF preview directly. Check whether:

- plotted data are large enough to read;
- text is readable at the final size;
- labels, legends, and statistical annotations do not overlap the data;
- multi-panel labels are consistent and aligned;
- shared legends are collected or deliberately repeated only when encodings differ;
- colors encode the same group, method, or cohort consistently across panels;
- shared axes do not visually collapse any subgroup.

## Delivery Note

Mention any unresolved warning, such as package installation failure, a borderline readability issue, or a web image that could not fit under 1 MB without hurting readability. Do not present fallback output as equivalent to the requested publication output.