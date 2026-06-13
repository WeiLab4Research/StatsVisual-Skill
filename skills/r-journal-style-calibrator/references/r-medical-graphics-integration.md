# R Medical Graphics Integration

Use this reference before editing `r-medical-graphics`.

## Public Style Interface

Add the new style wherever users or routing can name a style:

- `SKILL.md` first-turn style choices and reference loading notes.
- `references/design-rules.md`.
- `references/chart-router.md`.
- `references/styles/style-router.md`.
- `scripts/inspect_data_for_charts.R`.
- `agents/openai.yaml` if UI text mentions available styles.

Use aliases for journal name, abbreviation, journal-family phrasing, English style wording, and Chinese wording when relevant.

## Style Reference

Create `references/styles/<style>.md` with this structure:

- Use case.
- Visual contract.
- Typography and numeric/statistical text.
- Palette.
- Multi-panel rules.
- Chart-specific overrides.
- R implementation.
- Official submission rules.
- QA and reject conditions.

Keep guidance concise and rewritten. Do not paste long official text.

## R Implementation

Update `assets/styles/theme_registry.R` for:

- Style normalization and aliases.
- Style label and base size.
- Font family roles when submission font differs from figure-internal font.
- Palette.
- Theme defaults.
- Line/bar/default geometry settings.
- Number, CI, P-value, or scale-label helpers when the journal has special statistical formatting.

Update template `known_styles` in:

- `assets/templates/distribution_compare.R`.
- `assets/templates/scatter_association.R`.
- `assets/templates/multipanel_figure.R`.

Keep `assets/theme_medical_graphics.R` unchanged unless it does not already delegate to the registry.

## No-Go Files By Default

Do not modify these generic chart-family references unless the user explicitly requests a generic rule change:

- `references/forest-plot.md`.
- `references/box-plot.md`.
- `references/bar-chart.md`.
- `references/survival-curve.md`.
- Other chart-family references such as scatter, heatmap, line, histogram, and regression files.

Put journal-specific exceptions in `references/styles/<style>.md` and, when needed, in `SKILL.md` reference-loading priority notes.

## Validation

Run or plan these checks:

- `quick_validate.py` for the skill folder.
- R helper checks by sourcing `assets/styles/theme_registry.R`.
- Alias normalization tests.
- Palette, font, base-size, and number-format helper tests.
- Minimal ggplot build with `rmg_theme("<style>")`.
- Smoke plot under a temporary project directory such as `<repo-root>/demo/<style>_style_smoke` or another ignored per-request project folder.
- `scripts/validate_r_plot.R`.
- `scripts/validate_figure_readability.R`.
- SVG text checks for font family and visible number formatting.
- `rg` checks for stale style-option wording.
- No-go-file checks confirming generic chart references were not edited.
