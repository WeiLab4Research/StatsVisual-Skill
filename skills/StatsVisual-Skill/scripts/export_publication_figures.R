export_publication_figures <- function(p, figures_dir, name,
                                        width = 7, height = 5,
                                        dpi = 700, project_dir = NULL,
                                        skill_dir = NULL) {
  if (!inherits(p, "ggplot")) {
    stop("The figure object must be a ggplot object. Do not use base-R fallback output for this skill.", call. = FALSE)
  }

  dir.create(figures_dir, showWarnings = FALSE, recursive = TRUE)
  figures_dir <- normalizePath(figures_dir, winslash = "/", mustWork = TRUE)
  if (!is.null(project_dir) && !startsWith(figures_dir, paste0(project_dir, "/")) && figures_dir != file.path(project_dir, "figures")) {
    stop("Refusing to export outside the per-request project directory: ", figures_dir, call. = FALSE)
  }

  if (!is.null(skill_dir)) {
    source(file.path(skill_dir, "scripts", "setup_r_library.R"), local = TRUE)
    rmg_ensure_packages(c("ggplot2", "ragg", "svglite"), project_dir = project_dir, skill_dir = skill_dir)
  }

  pdf_file <- file.path(figures_dir, paste0(name, ".pdf"))
  svg_file <- file.path(figures_dir, paste0(name, ".svg"))
  tiff_file <- file.path(figures_dir, paste0(name, "_", dpi, "dpi.tiff"))
  web_file <- file.path(figures_dir, paste0(name, "_web.png"))

  ggplot2::ggsave(pdf_file, plot = p, width = width, height = height, units = "in", device = grDevices::cairo_pdf)
  ggplot2::ggsave(svg_file, plot = p, width = width, height = height, units = "in", device = svglite::svglite)
  ggplot2::ggsave(
    tiff_file, plot = p, width = width, height = height, units = "in",
    dpi = dpi, device = ragg::agg_tiff, compression = "lzw"
  )

  save_web <- function(file, w, h, dpi_value) {
    ggplot2::ggsave(file, plot = p, width = w, height = h, units = "in", dpi = dpi_value, device = ragg::agg_png)
  }

  web_width <- width
  web_height <- height
  web_dpi <- 300
  save_web(web_file, web_width, web_height, web_dpi)

  limit <- 1024 * 1024
  attempt <- 1
  while (file.exists(web_file) && file.info(web_file)$size > limit && attempt <= 6) {
    scale <- 0.85 ^ attempt
    save_web(web_file, max(3, web_width * scale), max(2.2, web_height * scale), max(96, round(web_dpi * scale)))
    attempt <- attempt + 1
  }

  message("Exported: ", pdf_file)
  message("Exported: ", svg_file)
  message("Exported: ", tiff_file)
  message("Exported: ", web_file)
}