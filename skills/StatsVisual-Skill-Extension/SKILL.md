---
name: StatsVisual-Skill-Extension
description: Extend StatsVisual-Skill by proposing and applying confirmed updates to chart references, plotting templates, and skill indexes. This skill must never directly modify StatsVisual-Skill before user confirmation.
---

# StatsVisual-Skill-Extension

## Purpose

This skill manages the extension of `StatsVisual-Skill`.

It is responsible for:
- adding new statistical visualization capabilities;
- updating existing chart specifications;
- adding or updating plotting templates;
- maintaining the StatsVisual-Skill capability registry.

It does not perform chart generation itself.

---

# Mandatory Workflow

## Step 1. Identify user request

Classify the request:

### New chart capability
Examples:
- add geographic maps;
- add network graphs;
- add spatial visualization;
- add new biomedical visualization methods.

### Existing chart modification
Examples:
- change forest plot rules;
- modify Kaplan-Meier style;
- update journal-specific requirements.

### Template modification
Examples:
- add R plotting script;
- update existing template code.

Before any action, read:

```
references/statsvisual_skill_registry.md
```

to determine whether the capability already exists.

---

# Step 2. Proposal First (Mandatory)

The skill MUST NOT modify any file immediately.

It must provide a complete modification proposal containing:

## Request analysis

- requested capability;
- whether it is new or existing;
- related chart family.

## Current status

Include:

- existing reference file;
- existing template location;
- whether duplication exists.

## Planned changes

List exact paths.

Example:

```
ADD:
skills/StatsVisual-Skill/references/network-graph.md

ADD:
skills/StatsVisual-Skill/assets/templates/network_graph/

UPDATE:
skills/StatsVisual-Skill/SKILL.md

UPDATE:
skills/StatsVisual-Skill-Extension/references/statsvisual_skill_registry.md
```

## Modification details

Describe:

- new sections;
- changed rules;
- added templates.

Then ask:

"是否确认执行以上修改？"

---

# Step 3. Confirmation Requirement

Only after explicit user confirmation may modifications be performed.

Ambiguous responses are not approval.

---

# Step 4. Modification Rules

## Adding new chart

Create:

```
StatsVisual-Skill/references/{chart_name}.md
```

The reference should contain:

- Scope
- Purpose
- Data requirements
- Statistical principles
- Visual rules
- Code implementation guidance

If a validated plotting script is provided:

Add:

```
StatsVisual-Skill/assets/templates/{chart_name}/
```

---

## Modifying existing chart

Only update:

```
StatsVisual-Skill/references/
StatsVisual-Skill/assets/templates/
```

Prefer incremental updates.

---

## Registry update

After successful modification:

Update only:

```
StatsVisual-Skill-Extension/references/statsvisual_skill_registry.md
```

Add new chart entries or update paths.

---

# Security Restrictions

Allowed modification scope:

```
skills/StatsVisual-Skill/
skills/StatsVisual-Skill-Extension/references/statsvisual_skill_registry.md
```

Forbidden:

- modifying files outside the above scope;
- modifying application source code;
- deleting existing chart knowledge without confirmation;
- changing StatsVisual-Skill-Extension workflow rules during normal extension tasks.

