# Special Medical Charts

Use this reference when the selected figure is an advanced or less common chart family. These charts can be effective in manuscripts, reviews, supplements, and high-impact medical journals, but they should be chosen only when the data structure makes the special geometry easier to read than a plain bar, dot, line, heatmap, or forest plot.

This reference is derived from the local special-chart manuscript notes and calibrated to the visual habits of top medical journals: restrained color, clear denominators, explicit units, readable labels, uncertainty or thresholds when scientifically relevant, and no decorative geometry that weakens quantitative reading.

## General Selection Rules

- Prefer conventional charts when the reader needs exact value comparison, effect-size inference, or clinical decision thresholds.
- Use special charts when the geometry carries meaning: cyclic time, dense categories, repeated periods, multi-axis profiles, 2 by 2 association, genome-wide scans, or severe point overlap.
- State sample size, denominator, time window, genome build, model, threshold, or smoothing parameter in the caption or rationale.
- Keep palettes color-blind-aware and avoid saturated rainbow defaults unless the encoding is categorical and labels remain readable.
- For top-journal style, include a simpler companion panel or table when the special chart is visually rich but not sufficient for precise inference.

## Quick Router

| Chart | Prefer when | Avoid when | Key data structure |
|---|---|---|---|
| Polar plot | Category count is >25 and the goal is frequency, proportion, composition, absolute contribution, burden, or overview ranking | Significance-value precision, correlation-coefficient precision, P values, CIs, threshold judgment, significance marks, or adjusted-versus-unadjusted differences are the main evidence | Category + numeric value; optional group, radius, size, color |
| Signed polar plot | Dense categorical signed values used for overview only | exact CI/threshold/P-value/significance reading or adjusted-versus-unadjusted comparison is the main evidence | Category + signed value; optional point distribution, group, radius, size, color |
| Radar chart | 3 to 8 comparable axes and 2 to 6 groups with normalized scales | Axes use incompatible scales or more than 6 groups overlap | Group + several numeric profile variables |
| Stream / river chart | Longitudinal composition across many time points, usually 4 to 12 dominant strata | Sparse time points, exact category comparison, too many small strata | Time + value + stratum |
| Rose chart | Category count is >25 with non-negative frequency, proportion, composition, absolute contribution, burden, or overview-ranking values | Exact comparison, P values, CIs, thresholds, significance marks, adjusted-versus-unadjusted differences, or negative values are primary | Category + positive value |
| Fourfold plot | One or more 2 by 2 tables where odds ratio / independence is the message | Sparse cells, non-binary variables, adjusted models are needed | Binary row + binary column + counts; optional strata |
| Spiral histogram | At least two repeated cycles of high-frequency time data where seasonality/circadian pattern is the message | Short, non-periodic, or irregular time series | Date/time + value, optional threshold |
| Manhattan plot | Genome-wide or exome-wide association scan with many variants/features and p values | Small candidate-gene plot or adjusted effect interpretation is primary | Chromosome + position + p value; optional labels |
| Sunflower density plot | Many overlapping points, especially discrete or rounded bivariate values | Continuous dense data better shown by hexbin/density contours | x + y, often integer/factor-like |
| Bubble chart | Two continuous axes plus a third positive magnitude; optional region/group color | Size must be read exactly, sample size is very large, or sizes span orders of magnitude without transformation | x + y + positive size; optional color |
| LOWESS smooth | Exploratory nonlinear trend over ordered x with enough observations | Formal model inference or causal claim is needed | Ordered numeric/date x + numeric y; optional group |
| Density ternary plot | Three components form a compositional whole and the message is where observations concentrate within that mixture space | Components do not sum to a meaningful whole, many points lie exactly on boundaries, or exact component comparison is primary | Three non-negative components summing to a constant; optional group, label, density level |
| Model-diagnostic bubble plot | Regression diagnostics require residual outliers, high leverage, and Cook's distance to be screened in one panel | A formal deletion/influence table is required, the model is not yet specified, or sample size is too small for a stable smooth | Model object or observation-level leverage + standardized/studentized residual + Cook's distance; optional label/group |

## 1. Polar Plot
Use for radial category displays when the category count is high enough to justify circular layout and the message is an overview. A good default threshold is more than 25 categories for one variable, and the main goal should be frequency, proportion, composition, absolute contribution, burden, or overview ranking. Do not prioritize polar plots when exact comparison, P values, CIs, thresholds, significance marks, correlation coefficients, or adjusted-versus-unadjusted differences are central.

Top-journal notes:

- Use polar bars for pattern, composition, burden, or ranking overview.
- Keep an interpretable scale label because polar bars lose the familiar y-axis.
- Annular polar scatter is preferable when the radius carries a continuous measure and color/size adds one extra variable.
- Reserve a circular blank center with `scale_y_continuous(limits = c(-inner_blank, ...))` or an equivalent annular baseline. The center may hold a concise denominator/scale note, but should not be filled with decorative graphics.
- Keep every category label radially aligned with its own bar, point, or angular slot. Compute label angle from the category index, flip labels on the left half so text remains upright, and use `coord_polar(clip = "off")` with generous margins.
- Use a clear zero ring for signed polar plots. Encode sign with direction from the zero ring, diverging color, or both; do not encode negative values as rose-chart radius.

```r
library(dplyr)
library(ggplot2)

# 计算外围标签的旋转角度
polar_label_angle <- function(x, n) {
  angle <- 90 - 360 * (x - 0.5) / n
  
  data.frame(
    angle = ifelse(angle < -90, angle + 180, angle),
    hjust = ifelse(angle < -90, 1, 0)
  )
}


# 极坐标核心模板
polar_core <- function(data,
                       category,
                       value,
                       label = NULL,
                       zero_radius = 0.55,
                       amplitude = 0.40,
                       label_radius = 1.08) {
  
  d <- data %>%
    mutate(
      .cat = as.character(.data[[category]]),
      .val = as.numeric(.data[[value]]),
      .lab = if (is.null(label)) .cat else as.character(.data[[label]])
    ) %>%
    filter(!is.na(.cat), !is.na(.val))
  
  # 给每个分类一个圆周编号
  order_df <- d %>%
    distinct(.cat, .keep_all = TRUE) %>%
    transmute(
      .cat = .cat,
      .index = row_number(),
      .label = .lab
    )
  
  n <- nrow(order_df)
  
  # x = 分类编号，即角度位置
  # r = 半径位置
  max_abs <- max(abs(d$.val), na.rm = TRUE)
  if (!is.finite(max_abs) || max_abs == 0) max_abs <- 1
  
  d <- d %>%
    left_join(order_df, by = ".cat") %>%
    mutate(
      .x = .index,
      .r = zero_radius + (.val / max_abs) * amplitude
    )
  
  # 外围标签：使用同一个 .index，所以和分类一一对应
  label_df <- order_df %>%
    mutate(
      .x = .index,
      .y = label_radius
    )
  
  angle_df <- polar_label_angle(label_df$.x, n)
  label_df$angle <- angle_df$angle
  label_df$hjust <- angle_df$hjust
  
  ggplot(d, aes(x = .x, y = .r)) +
    geom_hline(yintercept = zero_radius, color = "grey60") +
    geom_point(size = 1.2) +
    geom_text(
      data = label_df,
      aes(
        x = .x,
        y = .y,
        label = .label,
        angle = angle,
        hjust = hjust
      ),
      inherit.aes = FALSE,
      size = 2.6
    ) +
    scale_x_continuous(
      limits = c(0.5, n + 0.5),
      expand = c(0, 0)
    ) +
    scale_y_continuous(
      limits = c(0, label_radius + 0.1),
      expand = c(0, 0)
    ) +
    coord_polar(theta = "x", clip = "off") +
    theme_void() +
    theme(
      plot.margin = margin(25, 40, 25, 40)
    )
}
```

## 2. Radar Chart

Use for compact multivariable profiles where all axes share the same conceptual scale after normalization. Medical examples include regional public-health response profiles, quality-of-care domain scores, immune phenotype summaries, or trial arm profiles across 3 to 8 standardized endpoints.

Top-journal notes:

- Normalize or rescale axes before plotting and disclose the transformation.
- Keep groups to 2 to 6; if more groups are required, use small multiples.
- Do not use radar charts when the order of axes is arbitrary and drives the visual conclusion.
- Radar chart profiles should be represented as crisp polygonal outlines formed by straight connections between adjacent axes. Smoothed curves, circular arcs, or spline interpolation should be avoided because they may imply artificial continuity between discrete variables.
- Use circular dashed reference rings and light radial axis lines by default, matching common medical radar-chart style. Use regular polygon grid rings only when the user explicitly asks for polygonal grid/background.
- Do not let data marks or profile lines exceed the outer reference ring. A safe default is `outer_radius = 1.00` and `max_data_radius = 0.96`.
- Prefer manual Cartesian geometry over `coord_polar()` for publication radar charts: compute `theta`, `r`, `x = r * cos(theta)`, and `y = r * sin(theta)`. This gives explicit control over circular rings, radial axes, labels, clipping, and data bounds.
- Use `coord_equal(clip = "off")`; never allow unequal x/y scaling to distort the radar shape.
- If values are signed, disclose the transformation and show the zero/reference ring clearly. Do not label the center as zero unless zero truly maps to the center.
- If there are more than 8 axes or more than 6 groups, recommend faceting, small multiples, heatmap, or Cleveland dot plot before drawing a single overloaded radar chart.
```r
colnames(covid_nph) = c("region",
                        "Never under control(n=81)", 
                        "once under control(n=85)", 
                        "Rebound(n=56)",
                        "Rebound greater(n=28)", 
                        "Fluctuate(n=10)")
# 定义雷达图颜色
radar_color = c("#FDAF91FF",
                "#0099B4FF",
                "#ED0000FF",
                "#00468BFF",
                "#42B540FF",
                "#925E9FFF")

ggradar(covid_nph,
        base.size = 1,
        background.circle.transparency = 0,
        plot.extent.x.sf = 1.2,
        group.colours = radar_color,
        legend.position = "bottom",
        legend.text.size = 8,
        group.point.size = 4,
        axis.label.offset = 1.1,
        axis.label.size = 4,
        font.radar = 1)
}
```

## 3. Stream / River Chart

Use for changing composition over time: disease burden by pathogen, weekly admissions by department, vaccine adverse-event categories, or top causes of death over repeated time points. It is strongest when the manuscript message is "which strata dominate when" rather than exact point estimates.

Top-journal notes:

- Limit to the dominant 4 to 12 strata; collapse small strata into "Other".
- Use a conventional line or area chart if exact values are the main evidence.
- Keep the time axis honest; do not use a stream chart for unordered categories.

```r
rmg_stream_plot <- function(data, x, y, fill, palette = NULL, title = NULL,
                            x_label = NULL, y_label = NULL) {
  rmg_check_cols(data, c(x, y, fill))
  if (!requireNamespace("ggstream", quietly = TRUE)) {
    stop("Package 'ggstream' is required for rmg_stream_plot().", call. = FALSE)
  }

  d <- data %>%
    mutate(
      .x = .data[[x]],
      .y = as.numeric(.data[[y]]),
      .fill = as.factor(.data[[fill]])
    ) %>%
    filter(!is.na(.x), !is.na(.y), .y >= 0)

  p <- ggplot(d, aes(.x, .y, fill = .fill)) +
    ggstream::geom_stream(color = "white", linewidth = 0.25, type = "ridge") +
    labs(x = x_label %||% x, y = y_label %||% y, title = title) +
    rmg_special_theme()

  if (!is.null(palette)) p <- p + scale_fill_manual(values = palette)
  p
}
```

## 4. Rose Chart

Use for a circular ranked display where category magnitude is encoded by radius or area. Medical examples include global epidemic category summaries, cause-specific mortality, regional case counts, ranked cancer burden, adverse-event burden, absolute SHAP summaries, and non-negative feature-importance rankings. Prefer area-proportional encoding (`sqrt(value)`) when the visual area should correspond to the value.

Top-journal notes:

- Use for editorial overview or supplement figures, not primary inference.
- Label the original values because radial area is hard to read precisely.
- Use rose charts only for non-negative magnitudes. If values are signed or centered around zero, switch to a signed polar plot with a zero ring.
- Keep a clean circular blank center. The center can carry a compact summary such as total N, mean coefficient, or study window, but the blank should remain visually obvious.
- Order categories deliberately, usually by rank or clinically meaningful grouping. If the chart aggregates multiple groups, rank within the plotted total or facet/group with clear separators; do not mix arbitrary group order with magnitude order.
- Place each outside label next to the corresponding bar tip using a small value-scaled offset. Avoid putting all labels on one large outer concentric circle, because short bars then lose visual contact with their labels.
- Use inside labels only for the longest or top-ranked bars where contrast is strong; use outside labels for shorter bars.
- Keep outer padding just large enough for labels, not so large that labels float far from the petals. Check the exported final size because radial labels often look acceptable on screen but fail in journal-column width.
Grouped full-category rose chart rules:

1. Group-first ordering
   - If the data include an explicit grouping variable such as `Group`, `class`, or `family`, the rose chart should prioritize grouped ordering.
   - Categories from the same group must be adjacent; different groups should be distinguished with discrete colours.
   - Within each group, categories should be sorted by the main numeric value in descending order.

2. Between-group angular gaps
   - Grouped rose charts should include slight angular gaps between groups.
   - Gaps should only signal group boundaries and must not dominate the figure.
   - A default gap of about one category slot is recommended; avoid large gaps that fragment the circular display.

3. Colour rules
   - Group colours must use distinct discrete palettes. Different groups must not use repeated or overly similar colours.

4. Outside labels
   - In full-category rose charts, outside labels should stay close to their corresponding petal tips.
   - Labels should include the category name and original value when feasible, for example `GENE  6.8`.

5. Center title
   - Center text should be short and professional, avoiding stacked explanatory wording.
   - Prefer a concise main message such as `Grouped protein significance`.
   - Center text must be horizontally and vertically centered, anchored to the true polar origin rather than visually offset upward or downward.

6. Radial reference scale
   - Rose charts should include radial reference lines or concentric reference rings, especially when values vary widely.
   - Reference rings should be evenly spaced on the displayed radius and labelled with the corresponding values transformed back to the original scale.

```r
library(ggplot2)
library(dplyr)
library(rlang)
library(scales)

add_rose_label_geometry <- function(data,
                                    category_col = ".rose_category",
                                    value_col = ".rose_value",
                                    rank_col = ".rose_rank",
                                    inside_n = 8,
                                    outside_pad = NULL,
                                    inside_pad = NULL,
                                    accuracy = 0.001) {

  x <- droplevels(data[[category_col]])
  values <- data[[value_col]]
  labels <- as.character(x)

  # 根据 ggplot 中 x 轴 factor 的顺序计算角度
  if (is.factor(x)) {
    ids <- match(labels, levels(x))
    n <- length(levels(x))
  } else {
    ids <- seq_len(nrow(data))
    n <- nrow(data)
  }

  value_max <- max(values, na.rm = TRUE)

  if (is.null(outside_pad)) {
    outside_pad <- value_max * 0.028
  }

  if (is.null(inside_pad)) {
    inside_pad <- value_max * 0.025
  }

  angle_raw <- 90 - 360 * (ids - 0.5) / n
  flip <- angle_raw < -90

  label_angle <- ifelse(flip, angle_raw + 180, angle_raw)
  outside_hjust <- ifelse(flip, 1, 0)
  inside <- data[[rank_col]] <= inside_n

  tibble(
    .rose_category = x,
    .rose_value = values,
    .rose_rank = data[[rank_col]],
    label = ifelse(
      inside,
      paste0(labels, "\n", scales::number(values, accuracy = accuracy)),
      paste0(labels, "  ", scales::number(values, accuracy = accuracy))
    ),
    label_y = ifelse(
      inside,
      pmax(values - inside_pad, values * 0.72),
      values + outside_pad
    ),
    label_angle = label_angle,
    label_hjust = ifelse(
      inside,
      1 - outside_hjust,
      outside_hjust
    ),
    label_colour = ifelse(inside, "inside", "outside")
  )
}

rose_plot_template <- function(data,
                               category,
                               value,
                               rank = NULL,
                               top_n = 30,
                               inside_n = 8,
                               title = NULL,
                               subtitle = NULL,
                               center_label = "Mean\ncoef.",
                               fill_low = "#D9E8F5",
                               fill_high = "#0F4D92",
                               inside_label_color = "white",
                               outside_label_color = "#272727",
                               bar_width = 0.86,
                               bar_border_color = "white",
                               bar_border_width = 0.12,
                               base_family = "Arial",
                               value_accuracy = 0.001,
                               inner_blank = NULL,
                               outer_pad = NULL,
                               replace_hyphen = TRUE) {

  category_q <- enquo(category)
  value_q <- enquo(value)
  rank_q <- enquo(rank)

  has_rank <- !quo_is_null(rank_q)

  df <- data %>%
    transmute(
      .rose_category_raw = as.character(!!category_q),
      .rose_value = as.numeric(!!value_q),
      .rose_rank = if (has_rank) as.numeric(!!rank_q) else NA_real_
    ) %>%
    filter(
      !is.na(.rose_category_raw),
      !is.na(.rose_value)
    )

  if (!has_rank) {
    df <- df %>%
      arrange(desc(.rose_value)) %>%
      mutate(.rose_rank = row_number())
  } else {
    df <- df %>%
      filter(!is.na(.rose_rank)) %>%
      arrange(.rose_rank)
  }

  if (!is.null(top_n)) {
    df <- df %>% slice_head(n = top_n)
  }

  if (replace_hyphen) {
    df <- df %>%
      mutate(.rose_category_raw = stringr::str_replace_all(.rose_category_raw, "-", " "))
  }

  df <- df %>%
    mutate(
      .rose_category = factor(
        .rose_category_raw,
        levels = rev(unique(.rose_category_raw))
      )
    )

  value_max <- max(df$.rose_value, na.rm = TRUE)

  if (is.null(outer_pad)) {
    outer_pad <- value_max * 0.09
  }

  if (is.null(inner_blank)) {
    inner_blank <- value_max * 0.35
  }

  label_df <- add_rose_label_geometry(
    data = df,
    category_col = ".rose_category",
    value_col = ".rose_value",
    rank_col = ".rose_rank",
    inside_n = inside_n,
    accuracy = value_accuracy
  )

  ggplot(df, aes(x = .rose_category, y = .rose_value, fill = .rose_value)) +
    geom_col(
      width = bar_width,
      colour = bar_border_color,
      linewidth = bar_border_width
    ) +
    annotate(
      "text",
      x = 1,
      y = -inner_blank * 0.7,
      label = center_label,
      size = 2.1,
      colour = "#272727",
      fontface = "bold",
      family = base_family
    ) +
    geom_text(
      data = label_df,
      aes(
        x = .rose_category,
        y = label_y,
        label = label,
        angle = label_angle,
        hjust = label_hjust,
        colour = label_colour
      ),
      inherit.aes = FALSE,
      size = 2.0,
      family = base_family,
      lineheight = 0.9
    ) +
    coord_polar(start = 0, clip = "off") +
    scale_fill_gradient(
      low = fill_low,
      high = fill_high
    ) +
    scale_colour_manual(
      values = c(
        inside = inside_label_color,
        outside = outside_label_color
      ),
      guide = "none"
    ) +
    scale_y_continuous(
      limits = c(-inner_blank, value_max + outer_pad),
      expand = expansion(mult = c(0, 0))
    ) +
    labs(
      title = title,
      subtitle = subtitle,
      x = NULL,
      y = NULL,
      fill = NULL
    ) +
    theme_void(base_size = 7, base_family = base_family) +
    theme(
      axis.text.x = element_blank(),
      legend.position = "none",
      plot.title = element_text(face = "bold", size = 9),
      plot.subtitle = element_text(size = 7),
      plot.margin = margin(8, 8, 8, 8)
    )
}
```

## 5. Fourfold Plot

Use for 2 by 2 tables where the odds ratio and independence are the scientific message. Medical examples include treatment response by arm, exposure by disease status, sex by admission outcome, or stratified 2 by 2 comparisons across centers.

Top-journal notes:

- Report the odds ratio and confidence interval in caption/rationale; the plot alone is not enough.
- Use only when cells are not sparse. For adjusted inference, prefer a forest plot of logistic-regression estimates.
- For many strata, use a small-multiple forest plot rather than many fourfold panels.

```r
rmg_fourfold_plot <- function(data, row = NULL, col = NULL, count = NULL, strata = NULL,
                              color = c("#3C5488FF", "#DC0000FF"),
                              main = NULL, margin = c(4, 4, 1, 1)) {
  if (is.table(data) || is.array(data)) {
    tab <- data
  } else {
    rmg_check_cols(data, c(row, col, count, strata))
    form <- if (is.null(strata)) {
      stats::as.formula(paste(count, "~", row, "+", col))
    } else {
      stats::as.formula(paste(count, "~", row, "+", col, "+", strata))
    }
    tab <- stats::xtabs(form, data = data)
  }

  old_par <- graphics::par(no.readonly = TRUE)
  on.exit(graphics::par(old_par), add = TRUE)
  graphics::par(mar = margin)
  graphics::fourfoldplot(tab, color = color, main = main)
  invisible(tab)
}
```

## 6. Spiral Histogram

Use for repeated-cycle time series: daily air pollution over multiple years, circadian heart rate over repeated days, seasonal hospital admissions, or hourly monitoring across repeated cycles. It is strongest when seasonality or rhythm is the message.

Top-journal notes:

- Include a threshold line/color midpoint when clinical or regulatory cutoffs exist.
- Provide a conventional time-series panel if exact dates matter.
- Use at least two complete cycles; otherwise use a line chart.

```r
rmg_spiral_histogram <- function(data, date, value, threshold = NULL,
                                 palette = c("#2166AC", "#F7F7F7", "#B2182B"),
                                 title = NULL, value_label = NULL) {
  rmg_check_cols(data, c(date, value))
  d <- data %>%
    mutate(
      .date = as.Date(.data[[date]]),
      .value = as.numeric(.data[[value]]),
      .year = as.integer(format(.date, "%Y")),
      .doy = as.integer(format(.date, "%j"))
    ) %>%
    filter(!is.na(.date), !is.na(.value)) %>%
    arrange(.date)

  d <- d %>%
    mutate(
      .ring = as.numeric(factor(.year, levels = sort(unique(.year)))),
      .height = rescale(.value, to = c(0.05, 0.75)),
      .ymin = .ring,
      .ymax = .ring + .height
    )

  p <- ggplot(d) +
    geom_linerange(aes(x = .doy, ymin = .ymin, ymax = .ymax, color = .value), linewidth = 0.8) +
    geom_line(aes(x = .doy, y = .ymin, group = .year), color = "grey70", linewidth = 0.25) +
    coord_polar(theta = "x") +
    scale_x_continuous(
      breaks = c(1, 32, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335),
      labels = month.abb,
      minor_breaks = NULL
    ) +
    labs(x = NULL, y = NULL, color = value_label %||% value, title = title) +
    rmg_special_theme() +
    theme(axis.text.y = element_blank(), axis.ticks.y = element_blank())

  if (is.null(threshold)) {
    p + scale_color_gradientn(colors = palette)
  } else {
    p + scale_color_gradient2(low = palette[1], mid = palette[2], high = palette[3], midpoint = threshold)
  }
}
```

## 7. Manhattan Plot

Use for genome-wide, exome-wide, methylome-wide, or other high-dimensional association scans. Medical examples include GWAS/exome association for disease susceptibility, pharmacogenomic signals, or omics-wide biomarker discovery.

Top-journal notes:

- Always state genome build, association model, correction threshold, and number of tested variants/features.
- Mark the genome-wide threshold, usually `5e-8` for standard GWAS unless the study defines another threshold.
- Label only credible top hits; avoid covering the skyline with labels.

```r
rmg_manhattan_plot <- function(data, chrom, pos, p, label = NULL,
                               genomewide = 5e-8, suggestive = NULL,
                               palette = c("#4DBBD5FF", "#3C5488FF"),
                               title = NULL) {
  rmg_check_cols(data, c(chrom, pos, p, label))
  d <- data %>%
    transmute(
      .chrom = as.character(.data[[chrom]]),
      .pos = as.numeric(.data[[pos]]),
      .p = as.numeric(.data[[p]]),
      .label = if (is.null(label)) NA_character_ else as.character(.data[[label]])
    ) %>%
    filter(!is.na(.chrom), !is.na(.pos), !is.na(.p), .p > 0, .p <= 1)

  chrom_levels <- mixedsort_unique(d$.chrom)
  d <- d %>%
    mutate(.chrom = factor(.chrom, levels = chrom_levels)) %>%
    arrange(.chrom, .pos)

  chr_info <- d %>%
    group_by(.chrom) %>%
    summarise(.chr_len = max(.pos, na.rm = TRUE), .groups = "drop") %>%
    mutate(.offset = lag(cumsum(.chr_len), default = 0),
           .center = .offset + .chr_len / 2)

  d <- d %>%
    left_join(chr_info, by = ".chrom") %>%
    mutate(.x = .pos + .offset, .logp = -log10(pmax(.p, .Machine$double.xmin)),
           .hit_label = ifelse(!is.na(.label) & .p <= genomewide, .label, NA_character_))

  p <- ggplot(d, aes(.x, .logp, color = .chrom)) +
    geom_point(size = 0.6, alpha = 0.75) +
    geom_hline(yintercept = -log10(genomewide), color = "#BC3C29FF", linetype = "dashed", linewidth = 0.35) +
    scale_x_continuous(breaks = chr_info$.center, labels = as.character(chr_info$.chrom), expand = expansion(mult = 0.01)) +
    scale_color_manual(values = rep(palette, length.out = length(chrom_levels)), guide = "none") +
    labs(x = "Chromosome", y = expression(-log[10](italic(P))), title = title) +
    rmg_special_theme()

  if (!is.null(suggestive)) {
    p <- p + geom_hline(yintercept = -log10(suggestive), color = "grey45", linetype = "dotted", linewidth = 0.3)
  }
  if (!all(is.na(d$.hit_label))) {
    p <- p + ggrepel::geom_text_repel(aes(label = .hit_label), size = 2.4, max.overlaps = 30, show.legend = FALSE)
  }
  p
}

mixedsort_unique <- function(x) {
  ux <- unique(x)
  suppressWarnings({
    num <- as.numeric(ux)
    if (all(!is.na(num))) return(as.character(sort(num)))
  })
  ux[order(gsub("[0-9]+", "", ux), suppressWarnings(as.numeric(gsub("[^0-9]", "", ux))), ux)]
}
```

## 8. Density Sunflower Plot

Use when ordinary scatter points overlap so heavily that duplicated observations disappear. It is especially useful for rounded or discrete values such as number of children by region, integer symptom scores, ordinal categories encoded numerically, or repeated identical measurement pairs.

Top-journal notes:

- Explain that petals represent duplicate observations.
- For continuous dense data, consider hexbin, density contours, or alpha-blended scatter instead.
- If variables are categorical, relabel numeric axes with original factor labels.

```r
rmg_sunflower_plot <- function(data, x, y, xlab = NULL, ylab = NULL,
                               col = "goldenrod2", seg_col = "goldenrod2",
                               size = 0.18, cex = 0.8, rotate = TRUE) {
  rmg_check_cols(data, c(x, y))
  dx <- data[[x]]
  dy <- data[[y]]
  x_is_factor <- !is.numeric(dx)
  y_is_factor <- !is.numeric(dy)
  x_fac <- if (x_is_factor) factor(dx) else NULL
  y_fac <- if (y_is_factor) factor(dy) else NULL

  plot_df <- data.frame(
    .x = if (x_is_factor) as.numeric(x_fac) else as.numeric(dx),
    .y = if (y_is_factor) as.numeric(y_fac) else as.numeric(dy)
  )
  plot_df <- plot_df[stats::complete.cases(plot_df), , drop = FALSE]

  old_par <- graphics::par(no.readonly = TRUE)
  on.exit(graphics::par(old_par), add = TRUE)
  graphics::par(mar = c(5, 5, 2, 2))
  graphics::sunflowerplot(
    plot_df$.x, plot_df$.y,
    xlab = xlab %||% x, ylab = ylab %||% y,
    col = col, seg.col = seg_col, size = size, cex = cex,
    rotate = rotate, xaxt = if (x_is_factor) "n" else "s",
    yaxt = if (y_is_factor) "n" else "s"
  )
  if (x_is_factor) graphics::axis(1, seq_along(levels(x_fac)), labels = levels(x_fac), las = 2, cex.axis = 0.75)
  if (y_is_factor) graphics::axis(2, seq_along(levels(y_fac)), labels = levels(y_fac), las = 2, cex.axis = 0.75)
  invisible(plot_df)
}
```

## 9. Bubble Chart

Use when two continuous variables form the main relationship and a third positive variable is legitimately a magnitude, such as population, case count, tumor volume, sample size, or expenditure. It can also carry a fourth categorical variable through color.

Top-journal notes:

- Use area scaling, not radius scaling, so bubble area represents magnitude.
- Keep alpha below 1 when bubbles overlap.
- Directly label only selected clinically important points; too many labels make the plot unusable.

```r
rmg_bubble_plot <- function(data, x, y, size, color = NULL, label = NULL,
                            palette = NULL, max_size = 18, smooth = FALSE,
                            log_x = FALSE, log_y = FALSE, title = NULL) {
  rmg_check_cols(data, c(x, y, size, color, label))
  d <- data %>%
    mutate(
      .x = as.numeric(.data[[x]]),
      .y = as.numeric(.data[[y]]),
      .size = as.numeric(.data[[size]]),
      .color = if (is.null(color)) "All" else as.character(.data[[color]]),
      .label = if (is.null(label)) NA_character_ else as.character(.data[[label]])
    ) %>%
    filter(!is.na(.x), !is.na(.y), !is.na(.size), .size > 0)

  p <- ggplot(d, aes(.x, .y, size = .size, color = .color)) +
    geom_point(alpha = 0.55) +
    scale_size_area(max_size = max_size) +
    labs(x = x, y = y, size = size, title = title) +
    rmg_special_theme()

  if (smooth) p <- p + geom_smooth(method = "loess", formula = y ~ x, se = TRUE, linewidth = 0.5, color = "grey25")
  if (log_x) p <- p + scale_x_log10(labels = label_number())
  if (log_y) p <- p + scale_y_log10(labels = label_number())
  if (!is.null(palette)) p <- p + scale_color_manual(values = palette)
  if (!all(is.na(d$.label))) {
    p <- p + ggrepel::geom_text_repel(aes(label = .label), size = 2.4, show.legend = FALSE)
  }
  p
}
```

## 10. LOWESS Smooth Curve

Use for exploratory nonlinear patterns in ordered data: body temperature rhythm, Holter heart-rate monitoring, dose-response exploration, biomarker drift over time, or device signal trends. LOWESS is descriptive; it does not replace a prespecified longitudinal or nonlinear model.

Top-journal notes:

- State the span/frac value and whether it was chosen by sensitivity check or criterion.
- Show raw points or a faint raw trajectory so smoothing does not hide data quality.
- For periodic data, include enough cycles and avoid overinterpreting edge behavior.

```r
rmg_lowess_plot <- function(data, x, y, group = NULL, spans = 0.4,
                            palette = NULL, title = NULL,
                            show_points = TRUE, show_raw_line = TRUE) {
  rmg_check_cols(data, c(x, y, group))
  d <- data %>%
    mutate(
      .x_raw = .data[[x]],
      .x_num = if (inherits(.x_raw, "Date") || inherits(.x_raw, "POSIXt")) {
        as.numeric(.x_raw)
      } else if (is.factor(.x_raw) || is.character(.x_raw)) {
        as.numeric(factor(.x_raw, levels = unique(.x_raw), ordered = TRUE))
      } else {
        as.numeric(.x_raw)
      },
      .y = as.numeric(.data[[y]]),
      .group = if (is.null(group)) "All" else as.character(.data[[group]])
    ) %>%
    filter(!is.na(.x_num), !is.na(.y)) %>%
    arrange(.group, .x_num)

  fits <- bind_rows(lapply(split(d, d$.group), function(dd) {
    bind_rows(lapply(spans, function(span) {
      span <- max(as.numeric(span), 1e-6)
      ord <- order(dd$.x_num)
      dd <- dd[ord, , drop = FALSE]
      dd$.lowess <- stats::lowess(dd$.x_num, dd$.y, f = span)$y
      dd$.span <- paste0("span=", format(span, trim = TRUE))
      dd
    }))
  }))

  p <- ggplot(d, aes(.x_raw, .y, color = .group))
  if (show_raw_line) p <- p + geom_line(alpha = 0.25, linewidth = 0.35)
  if (show_points) p <- p + geom_point(alpha = 0.55, size = 1.4)
  p <- p +
    geom_line(data = fits, aes(.x_raw, .lowess, color = .group, linetype = .span), linewidth = 0.75) +
    labs(x = x, y = y, title = title, linetype = NULL) +
    rmg_special_theme()

  if (!is.null(palette)) p <- p + scale_color_manual(values = palette)
  p
}
```

## 11. Density Ternary Plot

Use when each observation is described by three non-negative components that form a meaningful whole, such as percentages, proportions, or concentrations after closure. Medical examples include arsenic metabolite composition, immune-cell composition, macronutrient distribution, microbiome dominance among three taxa, or adverse-event burden split across three clinically meaningful categories. The density layer is useful when many ternary points overlap and the manuscript message is where compositions concentrate rather than the exact value of each individual observation.

Top-journal notes:

- Confirm that the three axes represent parts of the same denominator and state whether values were normalized to sum to 1 or 100%.
- Use density as an exploratory distribution summary; do not treat high-density regions as inferential clusters without a prespecified method.
- Label the three components with units or percent signs.
- Show raw points over the density surface unless the figure is too dense; the density surface alone can hide boundary observations.
- Consider a companion table or marginal summaries when exact composition values are clinically important.

```r
rmg_density_ternary_plot <- function(data, x, y, z,
                                     normalize = TRUE,
                                     density_breaks = NULL) {
  if (!requireNamespace("ggtern", quietly = TRUE)) {
    stop("Package 'ggtern' is required.", call. = FALSE)
  }

  d <- data %>%
    dplyr::transmute(
      .x = as.numeric(.data[[x]]),
      .y = as.numeric(.data[[y]]),
      .z = as.numeric(.data[[z]])
    ) %>%
    dplyr::filter(!is.na(.x), !is.na(.y), !is.na(.z),
                  .x >= 0, .y >= 0, .z >= 0)

  if (normalize) {
    d <- d %>%
      dplyr::mutate(.total = .x + .y + .z) %>%
      dplyr::filter(.total > 0) %>%
      dplyr::mutate(
        .x = .x / .total,
        .y = .y / .total,
        .z = .z / .total
      )
  }

  ggtern::ggtern(d, ggplot2::aes(.x, .y, .z)) +
    ggtern::stat_density_tern(
      ggplot2::aes(fill = ggplot2::after_stat(level)),
      geom = "polygon",
      breaks = density_breaks,
      na.rm = TRUE
    ) +
    ggplot2::geom_point(size = 1, na.rm = TRUE) +
    ggtern::Tlab(x) +
    ggtern::Llab(y) +
    ggtern::Rlab(z) +
    ggplot2::labs(fill = "Density level") +
    ggtern::theme_bw()
}
```

## 12. Model-Diagnostic Bubble Plot

Use for regression diagnostic screening when one panel should combine three related quantities: leverage on the x-axis, standardized or studentized residuals on the y-axis, and Cook's distance as bubble size. Medical examples include checking influential observations in linear or generalized linear regression, biomarker-outcome models, dose-response models, risk-score calibration models, or site-level quality regressions before presenting final estimates.

Top-journal notes:

- Use this as a screening plot, not as the only basis for excluding observations; document any exclusion rule in the methods.
- Label only the most influential observations or prespecified clinically important records; too many labels turn the diagnostic into a lookup table.
- Draw horizontal reference lines such as residual = 0 and residual = +/-2, and draw a leverage rule such as 2p/n only when it is appropriate for the fitted model.
- State whether the y-axis uses standardized or studentized residuals, and whether Cook's distance size was transformed for display.
- Follow with sensitivity analyses or influence/deletion tables when influential observations affect the study conclusion.

```r
rmg_model_diagnostic_bubble <- function(model,
                                        residual_type = c("standardized", "studentized"),
                                        label_top_n = 3,
                                        resid_lines = c(-2, 0, 2),
                                        leverage_cutoff = NULL) {
  residual_type <- match.arg(residual_type)

  d <- data.frame(
    .hat = stats::hatvalues(model),
    .resid = if (residual_type == "studentized") {
      stats::rstudent(model)
    } else {
      stats::rstandard(model)
    },
    .cooksd = stats::cooks.distance(model)
  )

  d$.label <- rownames(d)
  if (is.null(d$.label)) d$.label <- seq_len(nrow(d))

  if (is.null(leverage_cutoff)) {
    leverage_cutoff <- 2 * sum(!is.na(stats::coef(model))) / nrow(d)
  }

  d <- d %>%
    dplyr::filter(!is.na(.hat), !is.na(.resid), !is.na(.cooksd)) %>%
    dplyr::mutate(
      .label_plot = ifelse(
        rank(-.cooksd, ties.method = "first") <= label_top_n,
        .label,
        NA
      )
    )

  ggplot2::ggplot(d, ggplot2::aes(.hat, .resid)) +
    ggplot2::geom_point(ggplot2::aes(size = .cooksd), shape = 1, na.rm = TRUE) +
    ggplot2::geom_smooth(method = "loess", formula = y ~ x, se = TRUE, na.rm = TRUE) +
    ggplot2::geom_hline(yintercept = resid_lines, linetype = "dashed") +
    ggplot2::geom_vline(xintercept = leverage_cutoff, linetype = "dotted") +
    ggplot2::geom_text(
      ggplot2::aes(label = .label_plot),
      check_overlap = TRUE,
      na.rm = TRUE
    ) +
    ggplot2::scale_size_area(name = "Cook's distance") +
    ggplot2::labs(
      x = "Leverage",
      y = ifelse(residual_type == "studentized",
                 "Studentized residuals",
                 "Standardized residuals")
    ) +
    ggplot2::theme_bw()
}
```


## QA Checklist

- Confirm the special chart improves interpretation compared with a bar, dot, line, heatmap, or forest plot.
- Confirm all encoded variables are stated in the caption/rationale, including any transformation such as `sqrt(value)`, `-log10(P)`, area scaling, normalization, or LOWESS span.
- Check labels at final export size; radial labels that look acceptable on screen often fail in print.
- For clinical or genomic thresholds, draw the threshold and name it in the figure rationale.
- For exploratory charts such as stream, spiral, bubble, sunflower, and LOWESS, do not overstate inference without a model or uncertainty estimate.
