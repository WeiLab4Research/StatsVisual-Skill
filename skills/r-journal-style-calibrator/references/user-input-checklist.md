# User Input Checklist

Use this checklist at the start of a new journal-style conversation. Do not ask for items that can be discovered from the workspace.

## Required Inputs

- Journal target: journal name, style id, and aliases, for example `NEJM`, `nejm`, `NEJM style`, `NEJM风格`, `New England Journal of Medicine`.
- Example figure folder: a user-provided external folder containing journal reference figures.
- Official guideline folder: a user-provided external folder containing author or artwork guidance.
- Target skill path: default to the current repository's `skills/r-medical-graphics` folder when available.
- Scope: planning only, implementation, or implementation plus smoke plot.

## High-Quality Example Figures

Ask for 15-25 examples when possible. A strong set includes:

- Forest plots or subgroup/effect-estimate displays.
- Survival curves and number-at-risk tables.
- Line, scatter, bar, box, distribution, and heatmap-like panels when relevant.
- Trial profiles, CONSORT diagrams, or study-flow displays.
- Multi-panel figures with A/B/C labels.
- Table-like figure panels, direct labels, legends, and statistical text.
- At least one "must match this" figure if a layout is critical.

## Official Guidance

Useful files include:

- Artwork or figure preparation guidelines.
- Information for authors.
- Statistical reporting instructions.
- Figure legend, font, resolution, vector, and editability requirements.
- Number-format, decimal, P-value, CI, units, and abbreviation rules.

If the user asks to search the web for official guidance and a page fails with 404, 403, network, or permission errors, pause and report the exact issue before continuing from unofficial sources.

## Review Artifacts

When debugging a generated style, ask for:

- The generated output image or SVG/PDF.
- The closest journal reference figure.
- A concrete mismatch, for example too many grid lines, wrong font, wrong decimal mark, legend position differs, forest plot outside the table, or background should be white.

## Default Constraints

- Do not modify generic chart-family references unless explicitly requested.
- Use concise rewritten guidance from official files; do not copy official PDFs, source images, or private examples into public skill references.
- Prefer editable vector outputs and keep text editable where possible.
