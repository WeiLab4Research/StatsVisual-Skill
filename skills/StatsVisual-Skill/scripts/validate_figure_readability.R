#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly = TRUE)
if (length(args) < 5) {
  stop(
    "Usage: Rscript validate_figure_readability.R <plot_rds> <figures_dir> <figure_name> <width_in> <height_in> [project_dir]",
    call. = FALSE
  )
}

plot_rds <- normalizePath(args[[1]], winslash = "/", mustWork = TRUE)
figures_dir <- normalizePath(args[[2]], winslash = "/", mustWork = TRUE)
figure_name <- args[[3]]
width_in <- as.numeric(args[[4]])
height_in <- as.numeric(args[[5]])
project_dir <- if (length(args) >= 6 && nzchar(args[[6]])) {
  normalizePath(args[[6]], winslash = "/", mustWork = TRUE)
} else {
  normalizePath(file.path(dirname(plot_rds), ".."), winslash = "/", mustWork = FALSE)
}

if (!is.finite(width_in) || !is.finite(height_in) || width_in <= 0 || height_in <= 0) {
  stop("width_in and height_in must be positive numbers.", call. = FALSE)
}

script_path <- sub("^--file=", "", grep("^--file=", commandArgs(FALSE), value = TRUE)[1])
script_dir <- if (!is.na(script_path) && nzchar(script_path)) {
  dirname(normalizePath(script_path, winslash = "/", mustWork = TRUE))
} else {
  getwd()
}
skill_dir <- normalizePath(file.path(script_dir, ".."), winslash = "/", mustWork = TRUE)
source(file.path(skill_dir, "scripts", "setup_r_library.R"), local = TRUE)
rmg_ensure_packages(c("ggplot2", "ragg", "png"), project_dir = project_dir, skill_dir = skill_dir)

output_dir <- file.path(project_dir, "output")
dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)
qa_file <- file.path(output_dir, "figure_qa.md")

p <- readRDS(plot_rds)
if (!inherits(p, "ggplot")) {
  stop("RDS must contain a ggplot-compatible object.", call. = FALSE)
}

issues <- data.frame(
  severity = character(),
  area = character(),
  evidence = character(),
  recommendation = character(),
  stringsAsFactors = FALSE
)

add_issue <- function(severity, area, evidence, recommendation) {
  issues[nrow(issues) + 1, ] <<- list(severity, area, evidence, recommendation)
}

safe_num <- function(x) {
  suppressWarnings(as.numeric(x))
}

finite_span <- function(x) {
  x <- safe_num(x)
  x <- x[is.finite(x)]
  if (length(x) < 2) return(NA_real_)
  diff(range(x, na.rm = TRUE))
}

extract_axis_range <- function(panel, axis = c("x", "y")) {
  axis <- match.arg(axis)
  direct <- panel[[paste0(axis, ".range")]]
  if (!is.null(direct)) {
    direct <- safe_num(direct)
    if (sum(is.finite(direct)) >= 2) return(range(direct, na.rm = TRUE))
  }
  scale_obj <- panel[[axis]]
  if (!is.null(scale_obj)) {
    lim <- tryCatch(scale_obj$get_limits(), error = function(e) NULL)
    if (!is.null(lim)) {
      lim <- safe_num(lim)
      if (sum(is.finite(lim)) >= 2) return(range(lim, na.rm = TRUE))
    }
    range_obj <- scale_obj$range$range
    if (!is.null(range_obj)) {
      range_obj <- safe_num(range_obj)
      if (sum(is.finite(range_obj)) >= 2) return(range(range_obj, na.rm = TRUE))
    }
  }
  c(NA_real_, NA_real_)
}

collect_layer_values <- function(layer_df, panel_id, axis = c("x", "y")) {
  axis <- match.arg(axis)
  cols <- if (axis == "y") c("y", "ymin", "ymax", "lower", "upper", "middle") else c("x", "xmin", "xmax", "xend")
  cols <- intersect(cols, names(layer_df))
  if (!length(cols)) return(numeric())
  if ("PANEL" %in% names(layer_df)) {
    layer_df <- layer_df[as.character(layer_df$PANEL) == as.character(panel_id), , drop = FALSE]
  }
  vals <- unlist(layer_df[cols], use.names = FALSE)
  vals <- safe_num(vals)
  vals[is.finite(vals)]
}

collect_text_grobs <- function(grob) {
  out <- list()
  if (inherits(grob, "text")) out <- c(out, list(grob))
  if (!is.null(grob$grobs)) {
    for (child in grob$grobs) out <- c(out, collect_text_grobs(child))
  }
  if (!is.null(grob$children)) {
    for (child in grob$children) out <- c(out, collect_text_grobs(child))
  }
  out
}

readable_label <- function(x) {
  x <- as.character(x)
  x[!is.na(x) & nzchar(x)]
}

color_distance_min <- function(cols) {
  cols <- cols[!is.na(cols) & nzchar(cols)]
  cols <- unique(cols[!grepl("^transparent$", cols, ignore.case = TRUE)])
  if (length(cols) < 2) return(NA_real_)
  rgb <- tryCatch(grDevices::col2rgb(cols) / 255, error = function(e) NULL)
  if (is.null(rgb) || ncol(rgb) < 2) return(NA_real_)
  distances <- stats::dist(t(rgb))
  min(as.numeric(distances), na.rm = TRUE)
}

built <- ggplot2::ggplot_build(p)
panel_params <- built$layout$panel_params
panel_ids <- seq_along(panel_params)

if (length(panel_ids) > 0) {
  y_axis_ranges <- lapply(panel_params, extract_axis_range, axis = "y")
  y_axis_spans <- vapply(y_axis_ranges, function(rng) diff(rng), numeric(1))
  y_data_spans <- vapply(panel_ids, function(panel_id) {
    values <- unlist(lapply(built$data, collect_layer_values, panel_id = panel_id, axis = "y"), use.names = FALSE)
    finite_span(values)
  }, numeric(1))
  span_ratio <- y_data_spans / y_axis_spans
  span_ratio[!is.finite(span_ratio) | y_data_spans <= 0 | y_axis_spans <= 0] <- NA_real_

  low_panels <- which(!is.na(span_ratio) & span_ratio < 0.2)
  failed_panels <- which(!is.na(span_ratio) & span_ratio < 0.1)
  for (panel_id in failed_panels) {
    add_issue(
      "FAIL",
      "panel-scale",
      sprintf("Panel %s uses %.1f%% of the y-axis span.", panel_id, 100 * span_ratio[[panel_id]]),
      "Do not deliver with a visually collapsed subgroup. Consider free_y facets, log scale, inset, split figure, or direct numeric labels."
    )
  }
  warn_panels <- setdiff(low_panels, failed_panels)
  for (panel_id in warn_panels) {
    add_issue(
      "WARN",
      "panel-scale",
      sprintf("Panel %s uses %.1f%% of the y-axis span.", panel_id, 100 * span_ratio[[panel_id]]),
      "Reassess shared y-axis scaling; use an alternative scale strategy if the subgroup is difficult to read."
    )
  }

  valid_spans <- y_data_spans[is.finite(y_data_spans) & y_data_spans > 0]
  if (length(valid_spans) >= 2 && max(valid_spans) / min(valid_spans) > 10) {
    axis_range_keys <- vapply(y_axis_ranges, function(rng) paste(signif(rng, 8), collapse = ":"), character(1))
    if (length(unique(axis_range_keys[is.finite(y_axis_spans)])) == 1) {
      add_issue(
        "WARN",
        "shared-axis",
        sprintf("Panel data spans differ %.1f-fold under a shared y-axis.", max(valid_spans) / min(valid_spans)),
        "Shared axes are only appropriate for direct absolute comparison; otherwise use free scales, log scale, inset, or split panels."
      )
    }
  }
}

for (i in seq_along(p$layers)) {
  geom_class <- class(p$layers[[i]]$geom)[[1]]
  if (geom_class %in% c("GeomBar", "GeomCol")) {
    y_ranges <- lapply(panel_params, extract_axis_range, axis = "y")
    excludes_zero <- vapply(y_ranges, function(rng) all(is.finite(rng)) && !(rng[[1]] <= 0 && rng[[2]] >= 0), logical(1))
    if (any(excludes_zero)) {
      add_issue(
        "WARN",
        "bar-axis",
        paste("Bar-like layer uses a y-axis range that excludes zero in panel(s):", paste(which(excludes_zero), collapse = ", ")),
        "Length-encoded bars should normally start at zero. Use points/intervals if a truncated axis is scientifically required."
      )
    }
  }
}

for (scale in p$scales$scales) {
  trans_name <- tryCatch(scale$trans$name, error = function(e) NULL)
  if (!is.null(trans_name) && !identical(trans_name, "identity")) {
    aes <- paste(scale$aesthetics, collapse = ", ")
    label_text <- paste(unlist(p$labels), collapse = " ")
    if (!grepl(trans_name, label_text, ignore.case = TRUE)) {
      add_issue(
        "WARN",
        "axis-transform",
        paste("Scale transform", trans_name, "on", aes, "is not mentioned in labels."),
        "State log, square-root, probability, or other transformations in the axis title or figure rationale."
      )
    }
  }
}

gt <- ggplot2::ggplotGrob(p)
text_grobs <- collect_text_grobs(gt)
font_sizes <- unlist(lapply(text_grobs, function(g) safe_num(g$gp$fontsize)), use.names = FALSE)
font_sizes <- font_sizes[is.finite(font_sizes)]
if (length(font_sizes) > 0) {
  min_font <- min(font_sizes)
  if (min_font < 6) {
    add_issue("FAIL", "font-size", sprintf("Smallest text is %.1f pt.", min_font), "Increase base size or final figure dimensions before export.")
  } else if (min_font < 7) {
    add_issue("WARN", "font-size", sprintf("Smallest text is %.1f pt.", min_font), "Check final-size readability; increase base size if preview text is hard to read.")
  }
}

labels <- unlist(lapply(text_grobs, function(g) readable_label(g$label)), use.names = FALSE)
long_labels <- labels[nchar(labels, type = "width") > 35]
if (length(long_labels) > 0) {
  add_issue(
    "WARN",
    "label-length",
    paste(length(long_labels), "text label(s) exceed 35 display characters."),
    "Wrap, abbreviate, rotate sparingly, or move long explanations to the figure legend/rationale."
  )
}

guide_idx <- grep("guide-box", gt$layout$name)
if (length(guide_idx) > 0) {
  guide_text <- unlist(lapply(gt$grobs[guide_idx], function(g) {
    readable_label(unlist(lapply(collect_text_grobs(g), function(tg) tg$label), use.names = FALSE))
  }), use.names = FALSE)
  guide_text <- setdiff(unique(guide_text), "")
  if (length(guide_text) > 20) {
    add_issue("FAIL", "legend", paste("Legend has", length(guide_text), "text entries."), "Reduce mapped groups, use direct labels, or split the figure.")
  } else if (length(guide_text) > 12) {
    add_issue("WARN", "legend", paste("Legend has", length(guide_text), "text entries."), "Check that the legend remains readable at final size.")
  }
}

panel_layout <- gt$layout[grepl("^panel", gt$layout$name), , drop = FALSE]
if (nrow(panel_layout) > 0) {
  panel_cols <- length(unique(panel_layout$l))
  panel_rows <- length(unique(panel_layout$t))
  panel_width <- width_in / max(1, panel_cols)
  panel_height <- height_in / max(1, panel_rows)
  if (panel_width < 1.2 || panel_height < 1.0) {
    add_issue(
      "FAIL",
      "panel-size",
      sprintf("Approximate panel cell is %.2f x %.2f in.", panel_width, panel_height),
      "Increase figure dimensions, reduce panel count, or split into separate figures."
    )
  } else if (panel_width < 1.5 || panel_height < 1.2) {
    add_issue(
      "WARN",
      "panel-size",
      sprintf("Approximate panel cell is %.2f x %.2f in.", panel_width, panel_height),
      "Inspect final-size output carefully; small panels may not support axis labels or dense data."
    )
  }
}

mapped_colors <- unique(unlist(lapply(built$data, function(df) {
  cols <- intersect(c("colour", "color", "fill"), names(df))
  unlist(df[cols], use.names = FALSE)
}), use.names = FALSE))
mapped_colors <- mapped_colors[!is.na(mapped_colors) & nzchar(mapped_colors)]
mapped_colors <- unique(mapped_colors)
if (length(mapped_colors) > 12) {
  add_issue("WARN", "color", paste("Plot uses", length(mapped_colors), "unique rendered colors/fills."), "Use fewer categories, direct labels, or a secondary encoding.")
}
min_color_distance <- color_distance_min(mapped_colors)
if (is.finite(min_color_distance) && min_color_distance < 0.12) {
  add_issue(
    "WARN",
    "color",
    sprintf("Minimum RGB color distance is %.2f.", min_color_distance),
    "Increase contrast or add shape/linetype/direct labels so groups remain distinguishable."
  )
}

tmp_png <- tempfile(fileext = ".png")
pixel_status <- tryCatch({
  ragg::agg_png(tmp_png, width = width_in, height = height_in, units = "in", res = 144, background = "white")
  print(p)
  grDevices::dev.off()
  img <- png::readPNG(tmp_png)
  rgb <- img[, , seq_len(min(3, dim(img)[3])), drop = FALSE]
  alpha <- if (dim(img)[3] >= 4) img[, , 4] else matrix(1, nrow = dim(img)[1], ncol = dim(img)[2])
  nonwhite <- apply(rgb, c(1, 2), function(px) mean(px) < 0.985) & alpha > 0.05
  if (any(nonwhite)) {
    rows <- which(rowSums(nonwhite) > 0)
    cols <- which(colSums(nonwhite) > 0)
    bbox_fraction <- (length(rows) * length(cols)) / (dim(img)[1] * dim(img)[2])
    ink_fraction <- sum(nonwhite) / (dim(img)[1] * dim(img)[2])
    if (bbox_fraction < 0.25) {
      add_issue(
        "FAIL",
        "rendered-preview",
        sprintf("Rendered content bounding box covers %.1f%% of the image.", 100 * bbox_fraction),
        "Reduce margins/legends or increase the data panel so the figure is readable at final size."
      )
    } else if (bbox_fraction < 0.35) {
      add_issue(
        "WARN",
        "rendered-preview",
        sprintf("Rendered content bounding box covers %.1f%% of the image.", 100 * bbox_fraction),
        "Inspect the final preview; large empty margins may make the plotted data too small."
      )
    }
    if (ink_fraction < 0.015) {
      add_issue(
        "WARN",
        "rendered-preview",
        sprintf("Non-white ink covers only %.2f%% of pixels.", 100 * ink_fraction),
        "Check whether very thin marks, small points, or large empty space make the figure hard to read."
      )
    }
  } else {
    add_issue("FAIL", "rendered-preview", "Rendered PNG appears blank.", "Debug plotting code and export device before delivery.")
  }
  TRUE
}, error = function(e) {
  add_issue("WARN", "rendered-preview", paste("PNG pixel check could not run:", conditionMessage(e)), "Inspect the web PNG/TIFF manually.")
  FALSE
}, finally = {
  if (file.exists(tmp_png)) unlink(tmp_png)
})

severity_rank <- c(FAIL = 1, WARN = 2, PASS = 3)
if (nrow(issues) > 0) {
  issues <- issues[order(severity_rank[issues$severity], issues$area), , drop = FALSE]
}
overall <- if (any(issues$severity == "FAIL")) "FAIL" else if (any(issues$severity == "WARN")) "WARN" else "PASS"

lines <- c(
  "# Figure Readability QA",
  "",
  paste0("- Figure: `", figure_name, "`"),
  paste0("- Plot RDS: `", normalizePath(plot_rds, winslash = "/", mustWork = FALSE), "`"),
  paste0("- Figures directory: `", normalizePath(figures_dir, winslash = "/", mustWork = FALSE), "`"),
  sprintf("- Final size: %.2f x %.2f in", width_in, height_in),
  paste0("- Overall status: **", overall, "**"),
  "",
  "## Findings",
  ""
)

if (nrow(issues) == 0) {
  lines <- c(lines, "- PASS: No scripted readability problems detected.")
} else {
  for (i in seq_len(nrow(issues))) {
    lines <- c(
      lines,
      paste0(
        "- ", issues$severity[[i]], " / ", issues$area[[i]], ": ",
        issues$evidence[[i]], " Recommendation: ", issues$recommendation[[i]]
      )
    )
  }
}

lines <- c(
  lines,
  "",
  "## Visual Review Reminder",
  "",
  "- Inspect the final web PNG or TIFF preview when image viewing is available.",
  "- Check whether the plotted data are large enough, text is readable, labels/legends do not overlap, panels are balanced, and shared axes do not visually collapse any subgroup."
)

writeLines(lines, qa_file)
message("Figure readability QA status: ", overall)
message("Wrote: ", normalizePath(qa_file, winslash = "/", mustWork = FALSE))

if (overall == "FAIL") {
  stop("Figure readability QA failed. See: ", qa_file, call. = FALSE)
}
