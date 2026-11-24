# Custom academic diagram design

## When to use

Use this route for a requested flow, study-design, conceptual or architecture diagram whose purpose or relationships do not fit the eight priority cards. Examples may include a specialised study design, data/system architecture, a composite overview or another source-supported process. These examples are illustrative, not an exhaustive whitelist or a set of new mandatory folders.

Do not relabel the request as a nearby type just to satisfy an enum. Keep the eight existing exemplar directories; a custom diagram does not require creating a new library category. Relevant fragments may be reused as visual references without copying their science or topology.

## Before drawing

Read the [eight-dimensional proposal template](proposal-template.md). Establish the positioning, content organisation, logic, layout, graphical encoding, visual style, reference basis, and validation/delivery plan. Identify source-supported requirements and uncertainty first. Use academic journal visual conventions through the selected style card; if no journal is selected, use General. Styles apply only to appearance, not research eligibility or content.

Look for relevant user-provided or available references; check official sources when current journal requirements are material. Report when no close example exists. Do not invent an official template, clinical rule, reference attribution or missing dataset. No local example is a reason to explain the design basis, not to refuse the request.

Present the proposal and end the turn. Wait for explicit user confirmation before making diagram files or previews. Preserve all shared no-title/no-annotation, compact-margin and three-format requirements.

## Specification

Use schema 2.3 and `metadata.type: custom`. Supply `metadata.custom_design` with these nonempty fields:

```json
{
  "name": "Actual diagram name",
  "positioning": "Purpose, application context and reason for custom routing",
  "content_organisation": "Source-supported information, core and supporting nodes, content choices",
  "logical_structure": "Order, parallelism, hierarchy, containment, dependencies and feedback",
  "layout": "Reading direction, regions, node ordering, alignment and spacing",
  "graphical_encoding": "Shapes, arrows, borders and containers with their intended meanings",
  "visual_style": "Selected visual card, palette, typography, sizes, strokes and margins",
  "reference_basis": "Actual references/guidance and status; explain if no close reference is available",
  "validation_delivery": "Content/logic checks, export approach, unresolved points and visual verification"
}
```

These values must describe the actual confirmed plan, not repeat field definitions. They are project metadata, never canvas annotations. When a composite includes `custom` in `metadata.panel_types`, provide this plan even if the primary type is a priority type; name the custom panel(s) and explain their relations. Keep `metadata.guidance` for actual applicable guidance records. Generic source/geometry, count, time and approval checks still apply.

## Rendering boundary

The shared scene supports basic shapes, containment and explicit connector routes; custom routing does not promise automatic layout or arbitrary specialised graphics. Use explicit coordinates for nonstandard structures. If new primitives or specialised rendering are required, implement project-specific vector drawing/export code, preserve the approval gate and source traceability, and adapt the consistency/visual checks to those outputs. Do not bypass unsupported geometry by flattening the entire PPTX or silently dropping elements. Report an unresolved export limitation before claiming completion.

## Flexible layout and missing references
Exact sizes, spacing and equalities are not required. Numeric defaults are advisory; keep readable text, clean routes and balanced proportions. Without useful examples, use [independent layout](independent-layout.md) and describe the reasoning briefly. A separate reference-review.md is optional; one overall visual review normally suffices. Content, path preservation, confirmation and editable three-format delivery remain required.
