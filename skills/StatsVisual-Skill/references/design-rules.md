# Design Rules

Use this file as the style entrypoint. The detailed rules live in `references/styles/` so more styles can be added without crowding the chart references.

## Available Styles

- `general` / 通用风格: default style derived from Peking University Professor Yongyue Wei's edited book *The Art of Statistical Graphics* (`统计图形艺术`). Load `styles/general.md`.
- `nature` / Nature 风格: restrained Nature-family publication style for high-impact journal figures. Load `styles/nature.md`.
- `lancet` / Lancet 风格: clinical and epidemiological Lancet-style figures with strong legibility, editable vector outputs, solid contrasting encodings, and table-plus-estimate discipline. Load `styles/lancet.md`.
- `nejm` / NEJM 风格: example-derived New England Journal of Medicine clinical-trial style with white backgrounds, strong axes, direct curve labels, risk tables, and light-gray table bands. Load `styles/nejm.md`.
- `jama` / JAMA 风格: JAMA-style clinical research figures with restrained editorial colour, strong statistical labeling, readable tables, and vector-first submission discipline. Load `styles/jama.md`.
- `bmj` / BMJ 风格: BMJ-style pragmatic clinical figures with high readability, plain-language evidence displays, conservative colour, and accessible publication outputs. Load `styles/bmj.md`.

## Selection Rules

- During the first data-profile and chart-recommendation response, ask the user to choose both chart option and style.
- If the user selects a chart but does not select a style, use `general`.
- If the user requests Nature, Nature-family, high-impact journal, compact multi-panel manuscript figures, or explicitly says `nature`, use `nature`.
- If the user requests Lancet, The Lancet, 柳叶刀, clinical trial/profile style, editable journal artwork, or explicitly says `lancet`, use `lancet`.
- If the user requests NEJM, New England Journal of Medicine, 新英格兰医学杂志, survival curves with risk tables, clinical-trial subgroup forest plots, or explicitly says `nejm`, use `nejm`.
- If the user requests JAMA, JAMA Network, Journal of the American Medical Association, clinical research style, or explicitly says `jama`, use `jama`.
- If the user requests BMJ, The BMJ, British Medical Journal, pragmatic clinical or health-services style, or explicitly says `bmj`, use `bmj`.
- Use `assets/styles/theme_registry.R` in plotting scripts and call `rmg_theme(style)` plus `rmg_palette(n, style)`.
- Keep chart-specific statistical rules in the detailed chart reference; keep style-specific typography, palette, panel, and layout rules in the selected style document.
