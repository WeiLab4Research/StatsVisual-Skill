rmg_normalize_style <- function(style = "general") {
  if (is.null(style) || length(style) == 0 || is.na(style[[1]]) || !nzchar(style[[1]])) {
    return("general")
  }
  style <- tolower(trimws(style[[1]]))
  aliases <- c(
    "default" = "general",
    "general-style" = "general",
    "通用" = "general",
    "通用风格" = "general",
    "nature-style" = "nature",
    "nature family" = "nature",
    "nature-family" = "nature",
    "nature风格" = "nature",
    "lancet-style" = "lancet",
    "the lancet" = "lancet",
    "lancet journal" = "lancet",
    "lancet风格" = "lancet",
    "柳叶刀" = "lancet",
    "柳叶刀风格" = "lancet",
    "nejm-style" = "nejm",
    "new england journal of medicine" = "nejm",
    "nejm journal" = "nejm",
    "nejm风格" = "nejm",
    "新英格兰医学杂志" = "nejm",
    "新英格兰医学杂志风格" = "nejm",
    "jama-style" = "jama",
    "jama network" = "jama",
    "jama journal" = "jama",
    "journal of the american medical association" = "jama",
    "jama风格" = "jama",
    "美国医学会杂志" = "jama",
    "美国医学会杂志风格" = "jama",
    "bmj-style" = "bmj",
    "the bmj" = "bmj",
    "bmj journal" = "bmj",
    "british medical journal" = "bmj",
    "bmj风格" = "bmj",
    "英国医学杂志" = "bmj",
    "英国医学杂志风格" = "bmj"
  )
  if (style %in% names(aliases)) {
    style <- aliases[[style]]
  }
  if (!style %in% c("general", "nature", "lancet", "nejm", "jama", "bmj")) {
    warning("Unknown style '", style, "'. Falling back to 'general'.", call. = FALSE)
    style <- "general"
  }
  style
}

rmg_style_label <- function(style = "general") {
  style <- rmg_normalize_style(style)
  switch(
    style,
    general = "General style",
    nature = "Nature style",
    lancet = "Lancet style",
    nejm = "NEJM style",
    jama = "JAMA style",
    bmj = "BMJ style"
  )
}

rmg_style_base_size <- function(style = "general") {
  style <- rmg_normalize_style(style)
  switch(
    style,
    general = 11,
    nature = 9,
    lancet = 10,
    nejm = 11,
    jama = 10,
    bmj = 10.5
  )
}

rmg_font_family <- function(style = "general", role = "figure") {
  style <- rmg_normalize_style(style)
  if (is.null(role) || length(role) == 0 || is.na(role[[1]]) || !nzchar(role[[1]])) {
    role <- "figure"
  }
  role <- tolower(trimws(role[[1]]))
  if (style == "lancet" && role %in% c("submission", "document", "legend", "heading", "manuscript")) {
    return("Times New Roman")
  }
  switch(
    style,
    general = "",
    nature = "Arial",
    lancet = "Arial",
    nejm = "Arial",
    jama = "Arial",
    bmj = "Arial"
  )
}

rmg_format_number <- function(x, style = "general", digits = 2, trim = FALSE, na_label = "NA") {
  style <- rmg_normalize_style(style)
  out <- rep(na_label, length(x))
  ok <- !is.na(x)
  if (any(ok)) {
    values <- formatC(round(x[ok], digits = digits), format = "f", digits = digits)
    if (isTRUE(trim)) {
      values <- sub("\\.?0+$", "", values)
      values <- sub("\\.$", "", values)
    }
    if (style == "lancet") {
      values <- gsub(".", "\u00b7", values, fixed = TRUE)
    }
    out[ok] <- values
  }
  out
}

rmg_format_ci <- function(est, low, high, style = "general", digits = 2) {
  style <- rmg_normalize_style(style)
  dash <- if (style %in% c("lancet", "nejm", "jama", "bmj")) "\u2013" else "-"
  paste0(
    rmg_format_number(est, style = style, digits = digits),
    " (",
    rmg_format_number(low, style = style, digits = digits),
    dash,
    rmg_format_number(high, style = style, digits = digits),
    ")"
  )
}

rmg_format_p <- function(p, style = "general", digits = 2, threshold = 0.001, prefix = FALSE) {
  style <- rmg_normalize_style(style)
  out <- rep("", length(p))
  ok <- !is.na(p)
  if (any(ok)) {
    values <- character(sum(ok))
    small <- p[ok] < threshold
    values[small] <- paste0("<", rmg_format_number(threshold, style = style, digits = 3))
    values[!small] <- rmg_format_number(p[ok][!small], style = style, digits = digits)
    if (isTRUE(prefix)) {
      values <- paste0("P", ifelse(grepl("^<", values), "", "="), values)
    }
    out[ok] <- values
  }
  out
}

rmg_label_number <- function(style = "general", accuracy = NULL, digits = NULL, trim = FALSE, na_label = "NA") {
  style <- rmg_normalize_style(style)
  decimal_mark <- if (style == "lancet") "\u00b7" else "."
  if (is.null(digits)) {
    if (is.null(accuracy)) {
      digits <- 0
    } else {
      digits <- max(0, ceiling(-log10(accuracy)))
    }
  }
  force(style)
  force(accuracy)
  force(digits)
  force(decimal_mark)
  force(trim)
  force(na_label)
  function(x) {
    out <- rep(na_label, length(x))
    ok <- !is.na(x)
    if (!is.null(accuracy)) {
      x <- round(x / accuracy) * accuracy
    }
    if (any(ok)) {
      values <- formatC(round(x[ok], digits = digits), format = "f", digits = digits)
      if (isTRUE(trim)) {
        values <- sub("\\.?0+$", "", values)
        values <- sub("\\.$", "", values)
      }
      if (decimal_mark != ".") {
        values <- gsub(".", decimal_mark, values, fixed = TRUE)
      }
      out[ok] <- values
    }
    out
  }
}

rmg_palette <- function(n, style = "general") {
  style <- rmg_normalize_style(style)
  palettes <- list(
    general = c(
      "#0072B2", "#D55E00", "#009E73", "#CC79A7",
      "#56B4E9", "#E69F00", "#000000", "#999999"
    ),
    nature = ggsci::pal_npg()(10),
    lancet = ggsci::pal_lancet()(9),
    nejm = ggsci::pal_nejm()(8),
    jama = ggsci::pal_jama()(7),
    bmj = ggsci::pal_bmj()(9)
  )
  palette <- sub("FF$", "", palettes[[style]], ignore.case = TRUE)

  if (n <= length(palette)) {
    palette[seq_len(n)]
  } else {
    grDevices::colorRampPalette(palette)(n)
  }
}

rmg_line_defaults <- function(style = "general") {
  style <- rmg_normalize_style(style)
  if (style == "lancet") {
    return(
      list(
        linewidth = 0.85,
        point_size = 2.2,
        point_shape = 16,
        point_fill = NA_character_,
        point_stroke = 0.6,
        legend_position = "top",
        direct_label = TRUE
      )
    )
  }
  if (style == "nejm") {
    return(
      list(
        linewidth = 0.95,
        point_size = 2.3,
        point_shape = 16,
        point_fill = NA_character_,
        point_stroke = 0.65,
        legend_position = "top",
        direct_label = TRUE
      )
    )
  }
  if (style == "jama") {
    return(
      list(
        linewidth = 0.8,
        point_size = 2.0,
        point_shape = 16,
        point_fill = NA_character_,
        point_stroke = 0.55,
        legend_position = "top",
        direct_label = TRUE
      )
    )
  }
  if (style == "bmj") {
    return(
      list(
        linewidth = 0.8,
        point_size = 2.1,
        point_shape = 16,
        point_fill = NA_character_,
        point_stroke = 0.55,
        legend_position = "top",
        direct_label = TRUE
      )
    )
  }
  list(
    linewidth = 0.7,
    point_size = 1.8,
    point_shape = 16,
    point_fill = NA_character_,
    point_stroke = 0.5,
    legend_position = "right",
    direct_label = FALSE
  )
}

rmg_bar_defaults <- function(style = "general") {
  style <- rmg_normalize_style(style)
  if (style == "lancet") {
    return(
      list(
        width = 0.72,
        linewidth = 0.45,
        zero_line_width = 0.45,
        legend_position = "top",
        strip_background = FALSE,
        shared_axis_titles = TRUE
      )
    )
  }
  if (style == "nejm") {
    return(
      list(
        width = 0.7,
        linewidth = 0.5,
        zero_line_width = 0.55,
        legend_position = "top",
        strip_background = FALSE,
        shared_axis_titles = TRUE
      )
    )
  }
  if (style == "jama") {
    return(
      list(
        width = 0.68,
        linewidth = 0.45,
        zero_line_width = 0.5,
        legend_position = "top",
        strip_background = FALSE,
        shared_axis_titles = TRUE
      )
    )
  }
  if (style == "bmj") {
    return(
      list(
        width = 0.72,
        linewidth = 0.45,
        zero_line_width = 0.5,
        legend_position = "top",
        strip_background = FALSE,
        shared_axis_titles = TRUE
      )
    )
  }
  list(
    width = 0.75,
    linewidth = 0.1,
    zero_line_width = 0.5,
    legend_position = "right",
    strip_background = TRUE,
    shared_axis_titles = FALSE
  )
}

rmg_theme <- function(style = "general", base_size = NULL, base_family = "") {
  style <- rmg_normalize_style(style)
  if (is.null(base_size)) {
    base_size <- rmg_style_base_size(style)
  }
  if (style %in% c("lancet", "nejm", "jama", "bmj") && (is.null(base_family) || !nzchar(base_family))) {
    base_family <- rmg_font_family(style)
  }
  if (style == "nature") {
    return(
      ggplot2::theme_classic(base_size = base_size, base_family = base_family) +
        ggplot2::theme(
          plot.title = ggplot2::element_text(face = "plain", hjust = 0, size = ggplot2::rel(1.0)),
          plot.subtitle = ggplot2::element_text(color = "grey30", size = ggplot2::rel(0.9)),
          axis.title = ggplot2::element_text(face = "bold", color = "grey10"),
          axis.title.x = ggplot2::element_text(margin = ggplot2::margin(t = 6)),
          axis.title.y = ggplot2::element_text(margin = ggplot2::margin(r = 6)),
          axis.text = ggplot2::element_text(color = "grey20"),
          axis.line = ggplot2::element_line(linewidth = 0.35, colour = "grey15"),
          axis.ticks = ggplot2::element_line(linewidth = 0.25, colour = "grey20"),
          axis.ticks.length = grid::unit(0.11, "cm"),
          legend.title = ggplot2::element_text(face = "plain"),
          legend.background = ggplot2::element_blank(),
          legend.box.background = ggplot2::element_blank(),
          legend.key = ggplot2::element_blank(),
          strip.background = ggplot2::element_blank(),
          strip.text = ggplot2::element_text(face = "plain", color = "grey10"),
          panel.grid.major = ggplot2::element_blank(),
          panel.grid.minor = ggplot2::element_blank(),
          plot.margin = ggplot2::margin(5, 5, 5, 5)
        )
    )
  }

  if (style == "lancet") {
    return(
      ggplot2::theme_classic(base_size = base_size, base_family = base_family) +
        ggplot2::theme(
          plot.title = ggplot2::element_text(face = "bold", hjust = 0, color = "grey10", size = ggplot2::rel(1.02)),
          plot.subtitle = ggplot2::element_text(color = "grey20", size = ggplot2::rel(0.92)),
          axis.title = ggplot2::element_text(face = "bold", color = "grey10"),
          axis.title.x = ggplot2::element_text(margin = ggplot2::margin(t = 7)),
          axis.title.y = ggplot2::element_text(margin = ggplot2::margin(r = 7)),
          axis.text = ggplot2::element_text(color = "grey10"),
          axis.line = ggplot2::element_line(linewidth = 0.55, colour = "grey10"),
          axis.ticks = ggplot2::element_line(linewidth = 0.45, colour = "grey10"),
          axis.ticks.length = grid::unit(0.13, "cm"),
          legend.title = ggplot2::element_text(face = "bold", color = "grey10"),
          legend.text = ggplot2::element_text(color = "grey10"),
          legend.background = ggplot2::element_blank(),
          legend.box.background = ggplot2::element_blank(),
          legend.key = ggplot2::element_blank(),
          strip.background = ggplot2::element_blank(),
          strip.text = ggplot2::element_text(face = "bold", color = "grey10"),
          panel.grid.major = ggplot2::element_blank(),
          panel.grid.minor = ggplot2::element_blank(),
          plot.tag = ggplot2::element_text(face = "bold", color = "grey10", size = ggplot2::rel(1.15)),
          plot.margin = ggplot2::margin(6, 7, 6, 7)
        )
    )
  }

  if (style == "nejm") {
    return(
      ggplot2::theme_classic(base_size = base_size, base_family = base_family) +
        ggplot2::theme(
          plot.title = ggplot2::element_text(face = "bold", hjust = 0, color = "grey10", size = ggplot2::rel(1.05)),
          plot.subtitle = ggplot2::element_text(color = "grey20", size = ggplot2::rel(0.92)),
          axis.title = ggplot2::element_text(face = "bold", color = "grey10"),
          axis.title.x = ggplot2::element_text(margin = ggplot2::margin(t = 8)),
          axis.title.y = ggplot2::element_text(margin = ggplot2::margin(r = 8)),
          axis.text = ggplot2::element_text(color = "grey10"),
          axis.line = ggplot2::element_line(linewidth = 0.65, colour = "grey10"),
          axis.ticks = ggplot2::element_line(linewidth = 0.5, colour = "grey10"),
          axis.ticks.length = grid::unit(0.14, "cm"),
          legend.title = ggplot2::element_text(face = "bold", color = "grey10"),
          legend.text = ggplot2::element_text(color = "grey10"),
          legend.background = ggplot2::element_blank(),
          legend.box.background = ggplot2::element_blank(),
          legend.key = ggplot2::element_blank(),
          strip.background = ggplot2::element_blank(),
          strip.text = ggplot2::element_text(face = "bold", color = "grey10"),
          panel.grid.major = ggplot2::element_blank(),
          panel.grid.minor = ggplot2::element_blank(),
          plot.tag = ggplot2::element_text(face = "bold", color = "grey10", size = ggplot2::rel(1.18)),
          plot.margin = ggplot2::margin(7, 8, 7, 8)
        )
    )
  }

  if (style == "jama") {
    return(
      ggplot2::theme_classic(base_size = base_size, base_family = base_family) +
        ggplot2::theme(
          plot.title = ggplot2::element_text(face = "bold", hjust = 0, color = "grey10", size = ggplot2::rel(1.02)),
          plot.subtitle = ggplot2::element_text(color = "grey25", size = ggplot2::rel(0.9)),
          axis.title = ggplot2::element_text(face = "bold", color = "grey10"),
          axis.title.x = ggplot2::element_text(margin = ggplot2::margin(t = 7)),
          axis.title.y = ggplot2::element_text(margin = ggplot2::margin(r = 7)),
          axis.text = ggplot2::element_text(color = "grey10"),
          axis.line = ggplot2::element_line(linewidth = 0.55, colour = "grey10"),
          axis.ticks = ggplot2::element_line(linewidth = 0.4, colour = "grey10"),
          axis.ticks.length = grid::unit(0.13, "cm"),
          legend.title = ggplot2::element_text(face = "bold", color = "grey10"),
          legend.text = ggplot2::element_text(color = "grey10"),
          legend.background = ggplot2::element_blank(),
          legend.box.background = ggplot2::element_blank(),
          legend.key = ggplot2::element_blank(),
          strip.background = ggplot2::element_blank(),
          strip.text = ggplot2::element_text(face = "bold", color = "grey10"),
          panel.grid.major = ggplot2::element_blank(),
          panel.grid.minor = ggplot2::element_blank(),
          plot.tag = ggplot2::element_text(face = "bold", color = "grey10", size = ggplot2::rel(1.12)),
          plot.margin = ggplot2::margin(6, 7, 6, 7)
        )
    )
  }

  if (style == "bmj") {
    return(
      ggplot2::theme_classic(base_size = base_size, base_family = base_family) +
        ggplot2::theme(
          plot.title = ggplot2::element_text(face = "bold", hjust = 0, color = "grey10", size = ggplot2::rel(1.02)),
          plot.subtitle = ggplot2::element_text(color = "grey25", size = ggplot2::rel(0.92)),
          axis.title = ggplot2::element_text(face = "bold", color = "grey10"),
          axis.title.x = ggplot2::element_text(margin = ggplot2::margin(t = 8)),
          axis.title.y = ggplot2::element_text(margin = ggplot2::margin(r = 8)),
          axis.text = ggplot2::element_text(color = "grey10"),
          axis.line = ggplot2::element_line(linewidth = 0.5, colour = "grey10"),
          axis.ticks = ggplot2::element_line(linewidth = 0.38, colour = "grey10"),
          axis.ticks.length = grid::unit(0.13, "cm"),
          legend.title = ggplot2::element_text(face = "bold", color = "grey10"),
          legend.text = ggplot2::element_text(color = "grey10"),
          legend.background = ggplot2::element_blank(),
          legend.box.background = ggplot2::element_blank(),
          legend.key = ggplot2::element_blank(),
          strip.background = ggplot2::element_blank(),
          strip.text = ggplot2::element_text(face = "bold", color = "grey10"),
          panel.grid.major = ggplot2::element_blank(),
          panel.grid.minor = ggplot2::element_blank(),
          plot.tag = ggplot2::element_text(face = "bold", color = "grey10", size = ggplot2::rel(1.12)),
          plot.margin = ggplot2::margin(7, 8, 7, 8)
        )
    )
  }

  ggpubr::theme_pubr(base_family = base_family) +
    ggplot2::theme(
      axis.title.y = ggplot2::element_text(
        margin = ggplot2::margin(t = 0, r = 10, b = 0, l = 0)
      ),
      axis.title.x = ggplot2::element_text(
        margin = ggplot2::margin(t = 10, r = 0, b = 0, l = 0)
      ),
      axis.title = ggplot2::element_text(size = 13, face = "bold"),
      axis.line = ggplot2::element_line(linewidth = 0.6, color = "black"),
      axis.ticks = ggplot2::element_line(linewidth = 0.3),
      axis.ticks.length = grid::unit(0.15, "cm"),
      axis.text = ggplot2::element_text(size = 10),
      legend.background = ggplot2::element_blank(),
      legend.box.background = ggplot2::element_blank(),
      legend.key = ggplot2::element_blank(),
      panel.grid.major = ggplot2::element_blank(),
      panel.grid.minor = ggplot2::element_blank(),
      plot.margin = ggplot2::margin(0.5, 0.5, 0.5, 0.5, "cm")
    )
}