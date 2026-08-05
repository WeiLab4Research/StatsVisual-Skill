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
dir.create(figures_dir, showWarnings = FALSE, recursive = TRUE)

find_skill_dir <- function() {
  candidates <- c(
    Sys.getenv("R_MEDICAL_GRAPHICS_SKILL", unset = NA_character_),
    {
      skills_dir <- file.path(getwd(), "skills")
      if (dir.exists(skills_dir)) {
        subdirs <- list.dirs(skills_dir, full.names = TRUE, recursive = FALSE)
        subdirs[file.exists(file.path(subdirs, "SKILL.md"))]
      }
    },
    {
      skills_dir <- file.path(dirname(getwd()), "skills")
      if (dir.exists(skills_dir)) {
        subdirs <- list.dirs(skills_dir, full.names = TRUE, recursive = FALSE)
        subdirs[file.exists(file.path(subdirs, "SKILL.md"))]
      }
    }
  )
  candidates <- unique(unlist(candidates))
  candidates <- candidates[!is.na(candidates) & nzchar(candidates)]
  for (candidate in candidates) {
    if (file.exists(file.path(candidate, "SKILL.md"))) {
      return(normalizePath(candidate, winslash = "/", mustWork = TRUE))
    }
  }
  stop("Cannot find the skill directory. Set R_MEDICAL_GRAPHICS_SKILL to the skill directory.", call. = FALSE)
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

source(file.path(skill_dir, "scripts", "export_publication_figures.R"))
export_publication_figures(p, figures_dir, figure_name, 7, 5, 700, project_dir, skill_dir)