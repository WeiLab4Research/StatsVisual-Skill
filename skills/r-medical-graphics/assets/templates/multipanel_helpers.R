make_medical_multipanel <- function(
  plots,
  design = NULL,
  ncol = NULL,
  tag_levels = "A",
  collect_guides = TRUE,
  legend_position = "bottom",
  tag_size = 8
) {
  stopifnot(length(plots) >= 2)
  guide_mode <- if (isTRUE(collect_guides)) "collect" else "keep"

  if (is.null(design)) {
    fig <- patchwork::wrap_plots(plots, ncol = ncol, guides = guide_mode)
  } else {
    fig <- patchwork::wrap_plots(plots, design = design, guides = guide_mode)
  }

  fig +
    patchwork::plot_annotation(tag_levels = tag_levels) &
    ggplot2::theme(
      legend.position = legend_position,
      plot.tag = ggplot2::element_text(size = tag_size, face = "bold")
    )
}

make_quantitative_grid <- function(
  plots,
  ncol = 2,
  tag_levels = "A",
  collect_guides = TRUE,
  legend_position = "bottom"
) {
  make_medical_multipanel(
    plots = plots,
    ncol = ncol,
    tag_levels = tag_levels,
    collect_guides = collect_guides,
    legend_position = legend_position
  )
}

make_clinical_triptych <- function(
  top_plots,
  middle_plots,
  bottom_plots,
  legend_position = "bottom"
) {
  stopifnot(length(top_plots) == length(middle_plots))
  stopifnot(length(top_plots) == length(bottom_plots))

  top_row <- patchwork::wrap_plots(top_plots, nrow = 1)
  middle_row <- patchwork::wrap_plots(middle_plots, nrow = 1)
  bottom_row <- patchwork::wrap_plots(bottom_plots, nrow = 1)

  top_row / middle_row / bottom_row +
    patchwork::plot_layout(heights = c(1.0, 1.25, 0.8), guides = "collect") +
    patchwork::plot_annotation(tag_levels = "A") &
    ggplot2::theme(
      legend.position = legend_position,
      plot.tag = ggplot2::element_text(size = 8, face = "bold")
    )
}

make_workflow_led_layout <- function(
  p_schematic,
  p_b,
  p_c,
  p_d,
  legend_position = "bottom"
) {
  design <- "
  AAAA
  BCCD
  "

  p_schematic + p_b + p_c + p_d +
    patchwork::plot_layout(design = design, heights = c(2.0, 1.0), guides = "collect") +
    patchwork::plot_annotation(tag_levels = "A") &
    ggplot2::theme(
      legend.position = legend_position,
      plot.tag = ggplot2::element_text(size = 8, face = "bold")
    )
}

make_image_quant_layout <- function(
  p_image,
  p_quant1,
  p_quant2 = NULL,
  legend_position = "bottom"
) {
  if (is.null(p_quant2)) {
    design <- "
    AA
    BB
    "
    return(
      p_image + p_quant1 +
        patchwork::plot_layout(design = design, heights = c(1.55, 1.0), guides = "collect") +
        patchwork::plot_annotation(tag_levels = "A") &
        ggplot2::theme(
          legend.position = legend_position,
          plot.tag = ggplot2::element_text(size = 8, face = "bold")
        )
    )
  }

  design <- "
  AAA
  BBC
  "
  p_image + p_quant1 + p_quant2 +
    patchwork::plot_layout(design = design, heights = c(1.55, 1.0), guides = "collect") +
    patchwork::plot_annotation(tag_levels = "A") &
    ggplot2::theme(
      legend.position = legend_position,
      plot.tag = ggplot2::element_text(size = 8, face = "bold")
    )
}

make_dominant_result_layout <- function(
  p_a,
  p_b,
  p_c,
  p_d,
  p_main,
  p_f,
  legend_position = "bottom"
) {
  design <- "
  AAE
  BCE
  FFE
  "

  p_a + p_b + p_c + p_d + p_main + p_f +
    patchwork::plot_layout(design = design, widths = c(1, 1, 1.2), guides = "collect") +
    patchwork::plot_annotation(tag_levels = "A") &
    ggplot2::theme(
      legend.position = legend_position,
      plot.tag = ggplot2::element_text(size = 8, face = "bold")
    )
}
