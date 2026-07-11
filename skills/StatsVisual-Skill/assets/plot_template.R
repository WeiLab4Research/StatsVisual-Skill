#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly = TRUE)
if (length(args) < 3) {
  stop("Usage: Rscript plot_template.R <project_dir> <data_file> <figure_name> [style]", call. = FALSE)
}

project_dir <- normalizePath(args[[1]], winslash = "/", mustWork = TRUE)
data_file <- normalizePath(args[[2]], winslash = "/", mustWork = TRUE)
figure_name <- args[[3]]
style <- if (length(args) >= 4 && nzchar(args[[4]])) args[[4]] else "general"

root <- project_dir
figures_dir <- file.path(root, "figures")
output_dir <- file.path(root, "output")
dir.create(figures_dir, showWarnings = FALSE, recursive = TRUE)
dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)

find_skill_dir <- function() {
  candidates <- c(
    Sys.getenv("R_MEDICAL_GRAPHICS_SKILL", unset = NA_character_),
    file.path(getwd(), "skills", "r-medical-graphics"),
    file.path(dirname(getwd()), "skills", "r-medical-graphics")
  )
  candidates <- candidates[!is.na(candidates) & nzchar(candidates)]
  for (candidate in candidates) {
    if (file.exists(file.path(candidate, "SKILL.md"))) {
      return(normalizePath(candidate, winslash = "/", mustWork = TRUE))
    }
  }
  stop("Cannot find r-medical-graphics skill. Set R_MEDICAL_GRAPHICS_SKILL to the skill directory.", call. = FALSE)
}

skill_dir <- find_skill_dir()
source(file.path(skill_dir, "scripts", "setup_r_library.R"), local = TRUE)
rmg_ensure_packages(c("ggplot2", "ragg"), project_dir = root, skill_dir = skill_dir)
source(file.path(skill_dir, "assets", "theme_medical_graphics.R"), local = TRUE)
style <- rmg_normalize_style(style)

data <- utils::read.csv(data_file, stringsAsFactors = FALSE, check.names = FALSE)
required_cols <- c("group", "value")
if (!all(required_cols %in% names(data))) {
  stop("Data must contain columns: ", paste(required_cols, collapse = ", "), call. = FALSE)
}

data$group <- factor(data$group)

p <- ggplot2::ggplot(data, ggplot2::aes(x = group, y = value, fill = group)) +
  ggplot2::geom_boxplot(width = 0.5, outlier.shape = NA, alpha = 0.75) +
  ggplot2::geom_jitter(width = 0.12, height = 0, alpha = 0.55, size = 1.6) +
  ggplot2::scale_fill_manual(values = rmg_palette(nlevels(data$group), style)) +
  ggplot2::labs(x = "Group", y = "Value", fill = "Group") +
  rmg_theme(style)

rds_file <- file.path(output_dir, paste0(figure_name, ".rds"))
saveRDS(p, rds_file)

export_script <- file.path(skill_dir, "scripts", "export_publication_figures.R")
status <- system2("Rscript", c(export_script, rds_file, figures_dir, figure_name, "7", "5", "700", root))
if (!identical(status, 0L)) {
  stop("Figure export failed.", call. = FALSE)
}

qa_script <- file.path(skill_dir, "scripts", "validate_figure_readability.R")
qa_status <- system2("Rscript", c(qa_script, rds_file, figures_dir, figure_name, "7", "5", root))
if (!identical(qa_status, 0L)) {
  stop("Figure readability QA failed.", call. = FALSE)
}
