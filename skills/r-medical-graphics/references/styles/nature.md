# Nature Style

Use this style when the user asks for `nature`, Nature-family presentation, high-impact journal figures, compact manuscript figures, or a restrained multi-panel figure with a strong evidence hierarchy.

This guidance is adapted from public Nature-style skill patterns in `Yuan1z0825/nature-skills`, especially its short skill entrypoint, figure contract, stance, R backend fragment, design-theory, workflow, and QA contract ideas. Keep the local implementation R/ggplot2-focused.

## Visual Contract

- Make the primary evidence visually dominant; supporting panels should be quieter.
- Use compact typography and tight but readable spacing. Do not fill the canvas with explanatory titles.
- Prefer lowercase panel labels `a`, `b`, `c`, placed consistently and outside the plotting region when possible.
- Keep SVG text editable. Avoid rasterizing text or flattening vector marks unless the data layer is genuinely raster-like.
- Use a white background, no legend frame, no decorative shadows, no heavy grid, and no boxed plot panel unless a specific matrix/image panel needs a boundary.
- Use direct labels or one shared legend when they reduce lookup. Avoid repeating legends across panels.
- Use thin axes and ticks. Keep grid lines absent or very pale.
- Use concise axis labels with units and explicit interval/test definitions.

## Palette

- Use low-saturation, color-blind-aware colors.
- Use gray for context/reference data, blue/teal for primary groups or estimates, muted red for risk/harm/highlight, and muted green for favorable or secondary signals.
- Avoid rainbow palettes and saturated red/green-only contrasts.
- Keep the same semantic group color across all panels and output reruns.

Recommended order for discrete groups:

```text
#3B6EA8, #5E9C76, #B45A56, #7A6FA6, #C79A43, #6D8791, #8A8A8A
```

## Multi-Panel Rules

- Write or save a figure contract before coding any multi-panel Nature-style figure.
- The contract must state core conclusion, primary evidence, supporting evidence, reviewer risk, panel map, shared encodings, final dimensions, and export formats.
- Do not create a multi-panel figure by placing several redundant chart types together. Each panel must answer a distinct scientific question.
- Attach dependent elements to their parent panel: risk tables, scale bars, inset labels, legend strips, and color bars should not receive separate panel labels unless they are scientific panels.
- Use asymmetric layouts when one result is primary. Avoid equal tiled grids unless the panels have equal evidential weight.

## R Implementation

- Source `assets/styles/theme_registry.R` through `assets/theme_medical_graphics.R`.
- Use `rmg_theme("nature", base_size = 8-10)` for compact manuscript panels.
- Use `rmg_palette(n, "nature")` for discrete groups.
- Prefer `svglite` for SVG, `cairo_pdf` for PDF, and `ragg` for TIFF/PNG.
- Use final journal dimensions before export instead of scaling after export.

## QA

- Check that all labels remain readable at final size.
- Check that panel labels are present, aligned, and do not collide with data.
- Check that SVG opens with editable text where feasible.
- Check that colors remain interpretable in grayscale or when printed small.
- Check that all statistics, intervals, denominators, and model definitions used in the figure are stated in the rationale.
