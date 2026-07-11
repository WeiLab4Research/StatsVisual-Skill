# Heatmap

## Use For

Use heatmaps for numeric matrices, correlation matrices, omics abundance matrices, confusion-style grids, or two-dimensional binned summaries.

## Variants

- Simple matrix heatmap.
- Correlation heatmap.
- Linkage disequilibrium heatmap.
- Clustered heatmap.
- Annotated omics heatmap.
- Calendar/temporal heatmap.
- Contour or filled contour for continuous surfaces.

## Core Mapping Logic

### Basic Heatmap

**Applicable Data**

- Matrix data in the form of a two-dimensional matrix or long table.
- Commonly used to display abundance, expression, correlation coefficient, exposure level correlation, etc.

**Mapping Logic**

- `x`: column variable.
- `y`: row variable.
- `fill`: Numerical intensity in the matrix, such as correlation coefficient, abundance, content, or degree of connection.
- Use `geom_tile()` as the core geometry layer.
- Colors usually use continuous color scale; if the data has a central value (such as correlation coefficient 0), `scale_fill_gradient2()` is preferred.
- If the label is long, you can use `str_wrap()` or preprocessing to wrap the label.

**Additional Requirements**

- Heatmaps are suitable for matrix comparisons, not for expressing precise numerical values ​​per se.
- If it is a correlation matrix, it is recommended to use a symmetrical color band centered on 0.
- The order of rows and columns must have statistical meaning; if there is no clustering, the ordering should be clearly based on original order or research semantics.
- You can use white strokes on the grid borders to enhance the sense of segmentation, but they should not be too thick.
- When the matrix is ​​too large, the text should be reduced and the x-axis text should be rotated
- Place the legend on the right and center it vertically.
- Place the title at the top and center it.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

### Linkage Disequilibrium Heatmap

**Applicable Data**

- SNP-level genotype or linkage disequilibrium data.
- Commonly used to show association structure among SNPs, haplotype blocks, or nearby genetic markers.

**Mapping Logic**

- Input usually includes SNP genotypes or an LD matrix plus marker positions.
- Use `LDheatmap::LDheatmap()` when working with the manuscript-style LD heatmap example.
- The triangular heatmap encodes linkage disequilibrium strength through color intensity.
- `genetic.distances` or equivalent marker-position information controls the genomic coordinate spacing.

**Additional Requirements**

- State whether the color encodes `D'`, `r^2`, or another LD statistic.
- Preserve marker order by genomic position unless there is a documented reason to reorder.
- Use a restrained sequential palette; darker color should correspond to stronger LD when following the manuscript example.
- Keep SNP labels readable; for many markers, reduce labels or show only key markers instead of shrinking text excessively.
- Place the title at the top and center it.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

### Clustered Heatmap

**Applicable Data**

- Square or near square matrix data.
- Commonly found in correlation matrices, abundance matrices, and sample × feature matrices.

**Mapping Logic**

- Typically `pheatmap()` is entered in matrix form.
- `color`: Continuous color band, often constructed according to negative correlation - no correlation - positive correlation.
- `cluster_rows`/`cluster_cols`: rearrange ranks by hierarchical clustering.
- `annotation_row` / `annotation_col` can be appended to add grouping comments.

**Additional Requirements**

- The core of the cluster heat map is not simple coloring, but revealing the proximity of variables or samples through distance structure.
- The original row and column order is no longer retained and rearranged by similarity.
- The higher the similarity → the closer the distance → the earlier the clustering tree is merged and the branches are shorter
- Place the legend on the right and center it vertically.
- Place the title at the top and center it.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.

### Contour Line Plot

**Applicable Data**

- Two continuous variables + an implicit intensity dimension derived from 2D density estimation.
- Suitable for expressing three-dimensional density information in two-dimensional way.
- Typical examples include two-dimensional density of eruption time and waiting time.

**Mapping Logic**

- `x`: Continuous variable 1.
- `y`: Continuous variable 2.
- Use `stat_density2d()` to calculate and plot 2D kernel density contours.
- `colour = after_stat(level)` maps contour levels to colors.
- Often superimposed on `geom_point()` to display the original observation point.

**Additional Requirements**

- If the number of points is small, the contour plot may be unstable and should be used with caution.
- Contour colors need to correspond monotonically to density levels.
- If original points have been overlaid, point and line colors must be avoided to be confused.
- Place the legend on the right and center it vertically.
- Place the title at the top and center it.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.
- code reference:source script `\StatsVisual-Skill\assets\templates\Contour Line Plot.R`

### Contour with Filled Areas

**Applicable Data**

- Same as contour plots, suitable for density or intensity distributions of two-dimensional continuous variables.
- Regular grid data is usually obtained in advance, such as `x-y-z` format.

**Mapping Logic**

- `x`: Continuous variable 1.
- `y`: Continuous variable 2.
- `z`: Density or intensity value.
- Use `geom_contour_filled()` to draw the filled outline area.
- The color band layering reflects the range of `z`.

**Additional Requirements**

- Compared with simple contour plots, contour filled plots place more emphasis on continuous intensity intervals.
- Filled pictures tend to look gaudy due to too many color levels, so the number of segments needs to be limited.
- Additional grid or border decoration should be reduced.
- When hot spots need to be highlighted, contour fill plots are often better than single-line contour plots.
- Place the legend on the right and center it vertically.
- Place the title at the top and center it.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.
- code reference:source script `\StatsVisual-Skill\assets\templates\Contour with Filled Areas.R`

### Sankey Plot

**Applicable Data**

- Source-destination-traffic data.
- Commonly used in case input sources and places, energy flow, material flow, etc.

**Mapping Logic**

- Draw using `ggalluvial` system.
- `axis1`, `axis2`: two-end categories.
- `y`: Traffic or number of people.
- `fill`: Typically maps to endpoint, origin, or flow category.
- `geom_alluvium()` draws the flow direction zone.
- `geom_stratum()` draws the category rectangle layer.
- `geom_text(stat = "stratum")` label category name.

**Additional Requirements**

- The width of each stream must correspond to the numerical size.
- When the number of categories is too large, the number of colors and label crowding must be controlled.
- If there are many flow directions, it is preferable to turn off the legend and label the categories directly on the layer.
- Place the legend on the right and center it vertically.
- Place the title at the top and center it.
- Do not add a gridline background.
- code reference:source script `\StatsVisual-Skill\assets\templates\Sankey Plot.R`

### Venn Plot

**Applicable Data**

- Show the intersection relationship of a small number of sets (usually <=5 groups).
- Commonly used in gene sets, differentially expressed gene sets, overlapping research object sets, etc.
- Can be composed of multiple vector or list objects.

**Mapping Logic**

- Use `ggvenn()`.
- The input is usually a named list, where each element is a set member.
- `show_percentage = TRUE/FALSE` controls whether to display the intersection ratio.
- `fill`: Collection fill color.
- The overlapping area between circles does not necessarily map exactly by quantity, but the intersection labels should be accurate.

**Additional Requirements**

- Venn diagrams are suitable for use when the number of sets is small, and it is generally not recommended to exceed 4–5 sets.
- The focus is on the number of intersections and combination relationships, rather than the precise comparison of the circle areas themselves.
- Colors should be mild and transparent to ensure overlapping areas are still legible.
- Place the legend on the right and center it vertically.
- Place the title at the top and center it.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.
- code reference:source script `\StatsVisual-Skill\assets\templates\Venn Plot.R`

### UpSet Plot

**Applicable Data**

- Display of intersection relationships for multiple sets (usually > 5 sets).
- Commonly used for symptom combinations, intersection of gene sets, co-occurrence of multiple phenotypes, etc.

**Mapping Logic**

- Use `UpSetR::upset()`.
- The input is typically a 0/1 matrix or wide table, with each column representing a set member state.
- Horizontal bars indicate collection size.
- Dot matrix + connected line represents intersection combination.
- The vertical bar chart represents the size of each intersection combination.

**Additional Requirements**

- Must meet:
  - Horizontal bars represent individual collection sizes;
  - Vertical bars represent intersection combination sizes.
- The set order and intersection order must be consistent with the research question, and they must be sorted by numerical value.
- Place the title at the top and center it.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.
- code reference:source script `\StatsVisual-Skill\assets\templates\UpSet Plot.R`

### Calendar Chart

**Applicable Data**

- Time series data recorded by date.
- Typical examples include the number of daily new cases, daily number of events, and daily monitoring values.

**Mapping Logic**

- `x`: week dimension.
- `y`: Week number in the month.
- `fill`: Daily value.
- Use `geom_tile()` to draw the calendar grid.
- Use `geom_text()` to mark the date numbers in the grid.
- `facet_wrap(~ month)` forms a monthly faceted calendar layout.
- Often used with `scale_y_reverse()` to make the calendar from top to bottom more consistent with reading habits.

**Additional Requirements**

- Date derived fields must be generated correctly first: month, week number, day of week, day number.
- The faceted month order must also be set explicitly.
- The fill color should be light-dark enough to be distinct, but should not overwhelm the date text.
- The darker/warmer the color, the higher the value, the more events, and the stronger the indicator; the lighter/cooler the color, the lower the value, and the fewer occurrences.
- Place the legend on the right and center it vertically.
- Place the title at the top and center it.
- Do not add a gridline background.
- Unless specifically requested, do not add subtitles or explanatory text outside the plot.
- code reference:source script `\StatsVisual-Skill\assets\templates\Calendar Chart.R`

## QA

- State whether values are raw, centered, scaled, z-scored, or transformed.
- Use perceptually ordered palettes; avoid rainbow.
- Keep dendrograms only when clustering is meaningful.
- Avoid tiny unreadable labels; filter, group, or annotate selected features.

