# Nature Style

Use this style when the user asks for `nature`, Nature-family presentation, high-impact journal figures, compact manuscript figures, or a restrained multi-panel figure with a clear result hierarchy.

## Visual Rules

- Make the primary result visually dominant; supporting panels should be quieter.
- Use compact typography and tight but readable spacing. Do not fill the canvas with explanatory titles.
- Prefer lowercase panel labels `a`, `b`, `c`, placed consistently and outside the plotting region when possible.
- Keep SVG text editable. Avoid rasterizing text or flattening vector marks unless the data layer is genuinely raster-like.
- Use a white background, no legend frame, no decorative shadows, no heavy grid, and no boxed plot panel unless a specific matrix/image panel needs a boundary.
- Use direct labels or one shared legend when they reduce lookup. Avoid repeating legends across panels.
- Use thin axes and ticks. Keep grid lines absent or very pale.
- Use concise axis labels with units and explicit interval/test definitions.
- Axis titles should be bold relative to tick labels.

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

- Write or save a concise figure plan before coding any multi-panel Nature-style figure.
- The plan must state the main message, primary result, supporting analyses, interpretation risk, panel roles, shared encodings, final dimensions, and export formats.
- Do not create a multi-panel figure by placing several redundant chart types together. Each panel must answer a distinct scientific question.
- Attach dependent elements to their parent panel: risk tables, scale bars, inset labels, legend strips, and color bars should not receive separate panel labels unless they are scientific panels.
- Use asymmetric layouts when one result is primary. Avoid equal tiled grids unless the panels have equal evidential weight.

## Forest Plot Rules

- Use a forest plot only when effect estimates and uncertainty intervals are present or can be computed from a declared model.
- Keep Nature-style forest plots compact, column-aligned, and evidence-first; avoid oversized titles or explanatory text inside the plot.
- Use descriptor columns only when needed: subgroup/level labels, counts, study weights, estimate with CI, and P for interaction are optional analysis-dependent fields.
- Prefer a single integrated table-and-forest layout. The forest axis, text columns, and row labels should share one row coordinate system.
- Use thin CI lines, modest square or point markers, and a pale or absent grid. Use blue or muted journal palette colours only when colour carries meaning.
- Keep forest-plot column headers the same font size as the body category labels; use bold weight for headers if needed.
- Use shallow row bands or fine column guides sparingly to support tracking; they should not dominate the CI marks.
- Place favour labels and axis ticks close to the forest axis, and keep the effect-measure label explicit.
- Reject Nature-style forest plots that are too wide, rely on a detached legend, use heavy table rules, or rasterize editable text.
- For example,the plot should be arranged as follows:
| **Subgroup / level** | **Treatment** | **Comparator** | **HR (95% CI)** | **HR (95% CI)** | **P interaction** |
|---|---:|---:|:---:|---:|---:|
| **Age** |  |  |  |  | 0·48 |
| &nbsp;&nbsp;<65 years | 86/742 | 112/736 | ───■──── | 0·76 (0·58–0·99) |  |
| &nbsp;&nbsp;≥65 years | 74/658 | 89/662 | ─────■── | 0·84 (0·62–1·13) |  |
| **Sex** |  |  |  |  | 0·71 |
| &nbsp;&nbsp;Male | 96/812 | 121/806 | ───■──── | 0·79 (0·61–1·02) |  |
| &nbsp;&nbsp;Female | 64/588 | 80/592 | ─────■── | 0·81 (0·58–1·12) |  |
|  |  |  | └──0·5──1·0──2·0──┘ |  |  |

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