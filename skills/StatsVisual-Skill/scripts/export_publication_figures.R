#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly = TRUE)
if (length(args) < 3) {
  stop("Usage: Rscript export_publication_figures.R <plot_rds> <figures_dir> <name> [width] [height] [dpi] [project_dir]", call. = FALSE)
}

plot_rds <- args[[1]]
figures_dir <- args[[2]]
name <- args[[3]]
width <- if (length(args) >= 4) as.numeric(args[[4]]) else 7
height <- if (length(args) >= 5) as.numeric(args[[5]]) else 5
dpi <- if (length(args) >= 6) as.integer(args[[6]]) else 700
project_dir <- if (length(args) >= 7) normalizePath(args[[7]], winslash = "/", mustWork = TRUE) else NA_character_

dir.create(figures_dir, showWarnings = FALSE, recursive = TRUE)
figures_dir <- normalizePath(figures_dir, winslash = "/", mustWork = TRUE)
if (!is.na(project_dir) && !startsWith(figures_dir, paste0(project_dir, "/")) && figures_dir != file.path(project_dir, "figures")) {
  stop("Refusing to export outside the per-request project directory: ", figures_dir, call. = FALSE)
}

script_path <- sub("^--file=", "", grep("^--file=", commandArgs(FALSE), value = TRUE)[1])
script_dir <- if (!is.na(script_path) && nzchar(script_path)) dirname(normalizePath(script_path, winslash = "/", mustWork = TRUE)) else getwd()
skill_dir <- normalizePath(file.path(script_dir, ".."), winslash = "/", mustWork = TRUE)
source(file.path(skill_dir, "scripts", "setup_r_library.R"), local = TRUE)
rmg_ensure_packages(c("ggplot2", "ragg", "svglite"), project_dir = project_dir, skill_dir = skill_dir)

p <- readRDS(plot_rds)

if (!inherits(p, "ggplot")) {
  stop("RDS must contain a ggplot object. Do not use base-R fallback output for this skill.", call. = FALSE)
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

manifest <- file.path(figures_dir, paste0(name, "_exports.txt"))
writeLines(c(
  paste("PDF:", normalizePath(pdf_file, winslash = "/", mustWork = FALSE)),
  paste("SVG:", normalizePath(svg_file, winslash = "/", mustWork = FALSE)),
  paste("TIFF:", normalizePath(tiff_file, winslash = "/", mustWork = FALSE)),
  paste("Web:", normalizePath(web_file, winslash = "/", mustWork = FALSE)),
  paste("Web bytes:", if (file.exists(web_file)) file.info(web_file)$size else NA),
  paste("DPI:", dpi)
), manifest)

message("Exported: ", pdf_file)
message("Exported: ", svg_file)
message("Exported: ", tiff_file)
message("Exported: ", web_file)