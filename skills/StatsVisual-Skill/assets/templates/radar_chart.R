# Radar chart template for r-medical-graphics.
# Expected input shape: one row per facet/group/axis/value combination.
# Required columns are supplied through function arguments.

rmg_radar_plot <- function(data,
                           axis,
                           value,
                           group,
                           facet = NULL,
                           axis_levels = NULL,
                           group_levels = NULL,
                           facet_levels = NULL,
                           style = "general",
                           title = NULL,
                           subtitle = NULL,
                           caption = NULL,
                           value_label = NULL,
                           symmetric = TRUE,
                           value_limits = NULL,
                           inner_radius = 0.08,
                           max_data_radius = 0.96,
                           outer_radius = 1.00,
                           label_radius = 1.10,
                           ring_n = 5,
                           palette = NULL) {
  required <- c(axis, value, group, facet)
  required <- required[!is.null(required)]
  missing_cols <- setdiff(required, names(data))
  if (length(missing_cols) > 0) {
    stop("Missing required columns: ", paste(missing_cols, collapse = ", "), call. = FALSE)
  }
  if (!requireNamespace("ggplot2", quietly = TRUE)) stop("Package 'ggplot2' is required.", call. = FALSE)
  if (!requireNamespace("dplyr", quietly = TRUE)) stop("Package 'dplyr' is required.", call. = FALSE)
  if (!requireNamespace("tidyr", quietly = TRUE)) stop("Package 'tidyr' is required.", call. = FALSE)
  if (!requireNamespace("scales", quietly = TRUE)) stop("Package 'scales' is required.", call. = FALSE)

  if (!exists("rmg_palette", mode = "function")) {
    rmg_palette <- function(n, style = "general") {
      grDevices::hcl.colors(n, palette = "Dark 3")
    }
  }
  if (!exists("rmg_theme", mode = "function")) {
    rmg_theme <- function(style = "general", base_size = 10) ggplot2::theme_classic(base_size = base_size)
  }

  df <- data |>
    dplyr::transmute(
      .axis = as.character(.data[[axis]]),
      .value = as.numeric(.data[[value]]),
      .group = as.character(.data[[group]]),
      .facet = if (is.null(facet)) "All" else as.character(.data[[facet]])
    ) |>
    dplyr::filter(!is.na(.axis), !is.na(.value), !is.na(.group), !is.na(.facet))

  if (nrow(df) == 0) stop("No complete rows remain for radar plotting.", call. = FALSE)

  if (is.null(axis_levels)) axis_levels <- unique(df$.axis)
  if (is.null(group_levels)) group_levels <- unique(df$.group)
  if (is.null(facet_levels)) facet_levels <- unique(df$.facet)

  axis_count <- length(axis_levels)
  group_count <- length(group_levels)
  if (axis_count < 3) stop("Radar chart requires at least 3 axes.", call. = FALSE)
  if (axis_count > 8) warning("Radar chart has more than 8 axes; consider faceting, heatmap, or Cleveland dot plot.", call. = FALSE)
  if (group_count > 6) warning("Radar chart has more than 6 groups; use small multiples or reduce groups.", call. = FALSE)

  df <- df |>
    dplyr::mutate(
      .axis = factor(.axis, levels = axis_levels),
      .group = factor(.group, levels = group_levels),
      .facet = factor(.facet, levels = facet_levels)
    ) |>
    dplyr::filter(!is.na(.axis), !is.na(.group), !is.na(.facet))

  if (is.null(value_limits)) {
    if (isTRUE(symmetric)) {
      max_abs <- max(abs(df$.value), na.rm = TRUE)
      if (!is.finite(max_abs) || max_abs == 0) max_abs <- 1
      value_limits <- c(-max_abs, max_abs)
    } else {
      value_limits <- range(df$.value, na.rm = TRUE)
      if (!all(is.finite(value_limits)) || diff(value_limits) == 0) value_limits <- c(0, 1)
    }
  }

  axis_lookup <- dplyr::tibble(
    .axis = factor(axis_levels, levels = axis_levels),
    .axis_index = seq_along(axis_levels),
    .angle = pi / 2 - 2 * pi * (seq_along(axis_levels) - 1) / length(axis_levels)
  )

  plot_df <- df |>
    dplyr::left_join(axis_lookup, by = ".axis") |>
    dplyr::mutate(
      .r = scales::rescale(.value, to = c(inner_radius, max_data_radius), from = value_limits),
      .r = pmin(pmax(.r, inner_radius), max_data_radius),
      .x = .r * cos(.angle),
      .y = .r * sin(.angle)
    ) |>
    dplyr::arrange(.facet, .group, .axis_index)

  closed_df <- plot_df |>
    dplyr::group_by(.facet, .group) |>
    dplyr::arrange(.axis_index, .by_group = TRUE) |>
    dplyr::group_modify(~ dplyr::bind_rows(.x, dplyr::slice(.x, 1))) |>
    dplyr::ungroup()

  ring_values <- pretty(value_limits, n = ring_n)
  ring_values <- ring_values[ring_values >= value_limits[1] & ring_values <= value_limits[2]]
  if (isTRUE(symmetric) && !any(abs(ring_values) < .Machine$double.eps^0.5)) {
    ring_values <- sort(unique(c(ring_values, 0)))
  }
  if (!any(abs(ring_values - value_limits[2]) < .Machine$double.eps^0.5)) {
    ring_values <- sort(unique(c(ring_values, value_limits[2])))
  }

  ring_df <- tidyr::expand_grid(
    .facet = factor(facet_levels, levels = facet_levels),
    .ring_value = ring_values,
    .theta = seq(0, 2 * pi, length.out = 241)
  ) |>
    dplyr::mutate(
      .r = dplyr::if_else(
        abs(.ring_value - value_limits[2]) < .Machine$double.eps^0.5,
        outer_radius,
        scales::rescale(.ring_value, to = c(inner_radius, max_data_radius), from = value_limits)
      ),
      .x = .r * cos(.theta),
      .y = .r * sin(.theta),
      .role = dplyr::case_when(
        isTRUE(symmetric) & abs(.ring_value) < .Machine$double.eps^0.5 ~ "zero",
        TRUE ~ "grid"
      ),
      .ring_group = interaction(.facet, .ring_value, drop = TRUE)
    )

  axis_df <- tidyr::expand_grid(
    .facet = factor(facet_levels, levels = facet_levels),
    .axis = factor(axis_levels, levels = axis_levels)
  ) |>
    dplyr::left_join(axis_lookup, by = ".axis") |>
    dplyr::mutate(.x = 0, .y = 0, .xend = outer_radius * cos(.angle), .yend = outer_radius * sin(.angle))

  label_df <- axis_lookup |>
    dplyr::mutate(
      .x = label_radius * cos(.angle),
      .y = label_radius * sin(.angle),
      .label = as.character(.axis),
      .hjust = dplyr::case_when(.x > 0.12 ~ 0, .x < -0.12 ~ 1, TRUE ~ 0.5),
      .vjust = dplyr::case_when(.y > 0.8 ~ 0, .y < -0.8 ~ 1, TRUE ~ 0.5)
    )

  ring_label_df <- tidyr::expand_grid(
    .facet = factor(facet_levels, levels = facet_levels),
    .ring_value = ring_values
  ) |>
    dplyr::mutate(
      .r = dplyr::if_else(
        abs(.ring_value - value_limits[2]) < .Machine$double.eps^0.5,
        outer_radius,
        scales::rescale(.ring_value, to = c(inner_radius, max_data_radius), from = value_limits)
      ),
      .x = 0.025,
      .y = .r,
      .label = scales::number(.ring_value, accuracy = 0.1)
    )

  if (is.null(palette)) palette <- rmg_palette(length(group_levels), style = style)
  names(palette) <- group_levels

  ggplot2::ggplot() +
    ggplot2::geom_path(
      data = ring_df |> dplyr::filter(.role == "grid"),
      ggplot2::aes(.x, .y, group = .ring_group),
      colour = "grey84", linewidth = 0.3, linetype = "dashed"
    ) +
    ggplot2::geom_path(
      data = ring_df |> dplyr::filter(.role == "zero"),
      ggplot2::aes(.x, .y, group = .ring_group),
      colour = "#2A9DB0", linewidth = 0.35, linetype = "dashed"
    ) +
    ggplot2::geom_segment(
      data = axis_df,
      ggplot2::aes(x = .x, y = .y, xend = .xend, yend = .yend),
      colour = "grey86", linewidth = 0.3
    ) +
    ggplot2::geom_polygon(
      data = closed_df,
      ggplot2::aes(.x, .y, group = .group, colour = .group, fill = .group),
      linewidth = 0.7, alpha = 0.08
    ) +
    ggplot2::geom_path(
      data = closed_df,
      ggplot2::aes(.x, .y, group = .group, colour = .group),
      linewidth = 0.75
    ) +
    ggplot2::geom_point(
      data = plot_df,
      ggplot2::aes(.x, .y, colour = .group),
      size = 1.7
    ) +
    ggplot2::geom_text(
      data = label_df,
      ggplot2::aes(.x, .y, label = .label, hjust = .hjust, vjust = .vjust),
      inherit.aes = FALSE, size = 3.0, colour = "#272727"
    ) +
    ggplot2::geom_text(
      data = ring_label_df,
      ggplot2::aes(.x, .y, label = .label),
      inherit.aes = FALSE, size = 2.5, colour = "grey35", hjust = 0, vjust = -0.25
    ) +
    ggplot2::facet_wrap(~ .facet, nrow = 1) +
    ggplot2::coord_equal(xlim = c(-1.24, 1.24), ylim = c(-1.22, 1.2), clip = "off") +
    ggplot2::scale_colour_manual(values = palette, drop = FALSE, name = group) +
    ggplot2::scale_fill_manual(values = palette, drop = FALSE, guide = "none") +
    ggplot2::labs(title = title, subtitle = subtitle, caption = caption, x = NULL, y = NULL) +
    rmg_theme(style = style, base_size = 10) +
    ggplot2::theme(
      aspect.ratio = 1,
      axis.title = ggplot2::element_blank(),
      axis.text = ggplot2::element_blank(),
      axis.ticks = ggplot2::element_blank(),
      axis.line = ggplot2::element_blank(),
      panel.grid = ggplot2::element_blank(),
      panel.border = ggplot2::element_blank(),
      legend.position = "bottom",
      legend.title = ggplot2::element_text(face = "bold"),
      strip.text = ggplot2::element_text(face = "bold"),
      plot.margin = ggplot2::margin(12, 36, 12, 36)
    )
}