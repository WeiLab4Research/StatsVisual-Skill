# Pie Chart

## Use For

Use pie or donut charts only for a small number of mutually exclusive parts that sum to one meaningful whole. They show composition, not rates.

Prefer bar charts, Cleveland dot plots, or stacked bars when categories are numerous, values are close, or exact comparison matters.

## Variants

- Pie chart.
- Donut chart.
- Rose chart for circular or many-category composition, used cautiously.
- Sunburst for hierarchical composition.
- Fourfold plot for 2x2 table frequency structure.

## Core Mapping Logic

### Pie Plot

**Applicable Data**

- Aggregated multi-category constituent data.
- Each category has a corresponding frequency, proportion or composition ratio.

**Mapping Logic**

- The typical writing method is to first use `geom_bar(stat = "identity")` or `geom_col()` to generate a single column, and then use `coord_polar(theta = "y")` to convert it into a pie chart.
- `x`: Usually set to the empty string `""`, indicating that all categories share a circle center.
- `y`: The frequency, composition ratio or absolute value corresponding to the category.
- `fill`: categorical variable.
- If the label is placed inside the sector, `position_stack(vjust = 0.5)` is usually used.
- If there are many categories, the cumulative position should be calculated first, and then the labels should be quoted externally.

**Additional Requirements**

- If the research question emphasizes "component ratio", the percentage label will be displayed first.
- The order of each sector plate must be arranged according to the numerical value of each category.
- For composition diagrams with fewer categories and obvious differences, labels can be placed inside sectors; for diagrams with many categories or long labels, external labels should be used instead.
- If there are too many categories and the proportions are close, users should be proactively reminded that conventional pie charts have low differentiation.
- Place the legend on the right and center it vertically.
- Place the title at the top and center it.
- Do not add a gridline background.

### Pie Plot with External Labels

**Applicable Data**

- Still aggregated constituent data.
- There are many categories, long names, or internal tags are easy to overlap.

**Mapping Logic**

- The main image still uses `geom_bar(..., stat = "identity") + coord_polar(theta = "y")`.
- First, calculate the label anchor point of each sector through the cumulative sum `cumsum()`, midpoint position `pos`, etc.
- The label layer uses `geom_label_repel()` or `geom_text_repel()` external import.
- `fill`: categorical variable.
- `label`: Usually a combined string of "category + percentage".

**Additional Requirements**

- The midpoint of the label must be calculated in advance and cannot be directly mechanically introduced, otherwise the connecting line will be misaligned.
- If the legend overlaps with the external label information, remove the legend first to reduce the sense of crowding.
- When there are many categories, it is recommended to add white strokes to the sector boundaries to enhance slice separation.
- The order of each sector plate must be arranged according to the numerical value of each category.
- For composition diagrams with fewer categories and obvious differences, labels can be placed inside sectors; for diagrams with many categories or long labels, external labels should be used instead.
- Place the legend on the right and center it vertically.
- Place the title at the top and center it.
- Do not add a gridline background.

### Doughnut Plot

**Applicable Data**

- Like a regular pie chart, the data is summarized.
- Suitable for scenes where you want the picture to be simpler, or to leave a blank space in the center for subsequent annotations.

**Mapping Logic**

- The essence is still single column + `coord_polar(theta = "y")`.
- `x`: The empty string is no longer used. It can be set to a constant greater than 1, such as `3.5`, and then `xlim()` is used to form a hollow area.
- `y`: frequency or composition ratio.
- `fill`: categorical variable.
- The label is mostly placed in the middle of the ring and is implemented through `position_stack(vjust = .5)`.

**Additional Requirements**

- A clear cavity must be formed through `xlim()` or radius control, and the ring cannot be made too thick or too thin.
- The thickness of the ring should take into account the readability of the label.
- Donut charts are usually better than regular pie charts if the user needs to place a total amount, study object, or year description in the center of the circle.
- The order of each sector plate must be arranged according to the numerical value of each category.
- For composition diagrams with fewer categories and obvious differences, labels can be placed inside sectors; for diagrams with many categories or long labels, external labels should be used instead.
- Place the legend on the right and center it vertically.
- Place the title at the top and center it.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

### Pie Plot with Exploded Slice

**Applicable Data**

- The constituent data have been summarized.
- Research focuses on highlighting one key category rather than emphasizing all categories simultaneously.

**Mapping Logic**

- Use `ggforce::geom_arc_bar(stat = "pie")` instead of plain `coord_polar()`.
- `x0`, `y0`: circle center coordinates.
- `r0`, `r`: inner and outer radius; when `r0 = 0`, it is a solid pie chart, and if `r0 > 0`, it can be expanded into a circular Pac-Bean chart.
- `amount`: Category corresponding value.
- `fill`: categorical variable.
- `explode`: Controls whether a certain category is moved out, usually from a control column such as `focus`.

**Additional Requirements**

- Only a few categories that really need to be emphasized should be highlighted, and it is not appropriate to allow multiple sectors to move out significantly at the same time.
- `explode` The displacement must be restrained, as excessive displacement may easily damage the overall structure.
- The order of each sector plate must be arranged according to the numerical value of each category.
- For composition diagrams with fewer categories and obvious differences, labels can be placed inside sectors; for diagrams with many categories or long labels, external labels should be used instead.
- Place the legend on the right and center it vertically.
- Place the title at the top and center it.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

### Exploding Pie Plot

**Applicable Data**

- The constituent data have been summarized.
- Desire to moderately separate all sectors to enhance category boundaries and visual hierarchy.

**Mapping Logic**

- First calculate the composition ratio of each category `fraction`, and then obtain `ymin` and `ymax` in sequence.
- Use `geom_rect()` to generate a Cartesian representation of a rectangular sector.
- Map the rectangle into separate sectors via `coord_polar(theta = "y")`.
- `fill`: categorical variable.
- `xmin` / `xmax`: Determine the horizontal position of each sector from the center of the circle to form an "explosion" effect.

**Additional Requirements**

- The separation distance of each sector should be uniform or have clear rules.
- The order of each sector plate must be arranged according to the numerical value of each category.
- For composition diagrams with fewer categories and obvious differences, labels can be placed inside sectors; for diagrams with many categories or long labels, external labels should be used instead.
- Place the legend on the right and center it vertically.
- Place the title at the top and center it.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

### Nightingale Rose Chart

**Applicable Data**

- Category data, each category has a numerical value, but the focus is on "magnitude difference" rather than "sum = 100%".
- Commonly used to display the number of cases, deaths, event scale, etc.

**Mapping Logic**

- The rose chart is essentially an extension of `geom_col()` / `geom_bar(stat = "identity")` in polar coordinates, and is not an ordinary pie chart in the strict sense.
- `x`: Category variable, the order needs to be set explicitly.
- `y`: category value, determines the radius length.
- `fill`: Can be mapped to category number, category variable or continuous color scale.
- `coord_polar()`: Convert the column to a rose chart.

**Additional Requirements**

- Preprocessing is required for label angles, such as the `angle` column, otherwise the text will be inverted or overlapped.
- When there are many categories, labels should be processed hierarchically: large values ​​should be placed in sectors, and small values ​​should be quoted outside.
- It is often necessary to leave a local negative `y` space to place the unit description.
- The rose diagram is suitable for displaying large absolute differences, but is not suitable for explaining small differences in composition ratios.
- The order of each sector plate must be arranged according to the numerical value of each category.
- Place the title at the top and center it.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

### Rose Chart with Tiered Label Strategy

**Applicable Data**

- There are many categories and the range of values ​​is huge.
- Different labeling strategies need to be adopted depending on the value size.

**Mapping Logic**

- Main layer: `geom_col()` + `coord_polar()`.
- Label layer: Draw according to the threshold into multiple `geom_text()` layers.
- Large value: The text is placed within the sector.
- Medium value: The text is near the top of the sector.
- Small value: text is quoted and rotated.
- `angle`: must be precalculated.
- `fill`: Can use continuous gradient color or color by category number

**Additional Requirements**

- The internal labels of the sector usually use a font color that is significantly different from the background color of the graphics, and the external labels usually use dark gray or black fonts.
- For Chinese label images, additional attention should be paid to font embedding and font weight.
- The order of each sector plate must be arranged according to the numerical value of each category.
- If the legend does not provide additional information, it should be removed to reduce distractions.
- Place the title at the top and center it.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

### Nested Pie Plot

**Applicable Data**

- Hierarchical structure data.
- Each record contains at least the node name, parent node name and value.

**Mapping Logic**

- `plotly::plot_ly(type = "sunburst")` can be used.
- `labels`: current node name
- `parents`: Upper-level node name
- `values`: Node corresponding value
- `branchvalues = "total"`: Explanation of levels by total amount

**Additional Requirements**

- The data must satisfy a clear parent-child hierarchical relationship; if `parent` is empty, misspelled or broken, the graph will fail.
- It is suitable for answering hierarchical questions such as "total composition + subgroup source", but not suitable for displaying only a single layer of composition.
- The order of each sector plate must be arranged according to the numerical value of each category.
- For composition diagrams with fewer categories and obvious differences, labels can be placed inside sectors; for diagrams with many categories or long labels, external labels should be used instead.
- Place the legend on the right and center it vertically.
- Place the title at the top and center it.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

### Circular Polar Heatmap

**Applicable Data**

- Two discrete dimensions + one continuous metric.
- For example: the incidence change spectrum of "disease × year".

**Mapping Logic**

- First use `geom_tile()` to draw a two-dimensional heat map in Cartesian coordinates.
- `x`: disease category.
- `y`: year.
- `fill`: Incidence rate or standardized value.
- Then use `coord_polar(theta = "x")` to convert it into a circular year spectrum.
- It is also often necessary to manually add year annotations, English labels, or polar scales.

**Additional Requirements**

- When there are many categories, `axis.text.x` should reduce the font size or use English abbreviation instead.
- Place the legend on the right and center it vertically.
- Place the title at the top and center it.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

### Fourfold Plot

**Applicable Data**

- `2 × 2` contingency table, or `2 × 2 × k` hierarchical contingency table.
- The summarized array can be used directly, or the individual-level binary data can be summarized first through `xtabs()`.

**Mapping Logic**

- `fourfoldplot()` using the base graphics system.
- If it is individual-level data, first use `xtabs(~ row_var + col_var, data)` to summarize it into the `2 × 2` table.
- If it is a `2 × 2 × k` layered table, it can be passed directly to `fourfoldplot()`, and the multi-panel layout can be controlled through `mfcol`.
- Color is often used to differentiate between paired groups of quadrants.

**Additional Requirements**

- The row and column variables must all be binary categories; otherwise, the four-petal graph cannot be used directly.
- If there are multiple layers (such as different departments), a multi-panel arrangement should be used.
- Place the legend on the right and center it vertically.
- Place the title at the top and center it.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

## Code Reference
- Original development note: source script `0300-pieplot-finished.rmd` is not included in the public skill.

## QA

- Confirm values sum to a whole and are not independent rates.
- Keep categories few, usually no more than 5-6.
- Report percentages and counts in caption or labels.
- Avoid 3D pies, exploded slices, gradients, and excessive colors.

