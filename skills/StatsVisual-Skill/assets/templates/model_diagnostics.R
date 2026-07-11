#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly = TRUE)
if (length(args) < 4) {
  stop("Usage: Rscript model_diagnostics.R <project_dir> <data_file> <figure_name> <formula> [style]", call. = FALSE)
}

project_dir <- normalizePath(args[[1]], winslash = "/", mustWork = TRUE)
data_file <- normalizePath(args[[2]], winslash = "/", mustWork = TRUE)
figure_name <- args[[3]]
model_formula <- stats::as.formula(args[[4]])
style <- if (length(args) >= 5 && nzchar(args[[5]])) args[[5]] else "general"

figures_dir <- file.path(project_dir, "figures")
output_dir <- file.path(project_dir, "output")
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
rmg_ensure_packages(c("ggplot2", "dplyr", "readr", "broom", "patchwork", "ragg"), project_dir = project_dir, skill_dir = skill_dir)
source(file.path(skill_dir, "assets", "theme_medical_graphics.R"), local = TRUE)
style <- rmg_normalize_style(style)

data <- readr::read_csv(data_file, show_col_types = FALSE)
model <- stats::lm(model_formula, data = data)
aug <- broom::augment(model)

p_resid <- ggplot2::ggplot(aug, ggplot2::aes(x = .fitted, y = .resid)) +
  ggplot2::geom_hline(yintercept = 0, linewidth = 0.35, linetype = "dashed", color = "grey45") +
  ggplot2::geom_point(alpha = 0.65, size = 1.4, color = rmg_palette(1, style)[[1]]) +
  ggplot2::geom_smooth(method = "loess", se = FALSE, linewidth = 0.65, color = "grey20") +
  ggplot2::labs(x = "Fitted values", y = "Residuals", title = "Residuals vs fitted") +
  rmg_theme(style, base_size = 10)

p_qq <- ggplot2::ggplot(aug, ggplot2::aes(sample = .std.resid)) +
  ggplot2::stat_qq(alpha = 0.65, size = 1.4, color = rmg_palette(1, style)[[1]]) +
  ggplot2::stat_qq_line(linewidth = 0.45, color = "grey20") +
  ggplot2::labs(x = "Theoretical quantiles", y = "Standardized residuals", title = "Normal Q-Q") +
  rmg_theme(style, base_size = 10)

p_scale <- ggplot2::ggplot(aug, ggplot2::aes(x = .fitted, y = sqrt(abs(.std.resid)))) +
  ggplot2::geom_point(alpha = 0.65, size = 1.4, color = rmg_palette(1, style)[[1]]) +
  ggplot2::geom_smooth(method = "loess", se = FALSE, linewidth = 0.65, color = "grey20") +
  ggplot2::labs(x = "Fitted values", y = "Sqrt(|standardized residuals|)", title = "Scale-location") +
  rmg_theme(style, base_size = 10)

p_leverage <- ggplot2::ggplot(aug, ggplot2::aes(x = .hat, y = .std.resid)) +
  ggplot2::geom_hline(yintercept = 0, linewidth = 0.35, linetype = "dashed", color = "grey45") +
  ggplot2::geom_point(ggplot2::aes(size = .cooksd), alpha = 0.6, color = rmg_palette(1, style)[[1]]) +
  ggplot2::scale_size_continuous(range = c(1, 4), name = "Cook's distance") +
  ggplot2::labs(x = "Leverage", y = "Standardized residuals", title = "Residuals vs leverage") +
  rmg_theme(style, base_size = 10)

p <- (p_resid + p_qq) / (p_scale + p_leverage)

rds_file <- file.path(output_dir, paste0(figure_name, ".rds"))
saveRDS(p, rds_file)

export_script <- file.path(skill_dir, "scripts", "export_publication_figures.R")
status <- system2("Rscript", c(export_script, rds_file, figures_dir, figure_name, "8", "6.5", "700", project_dir))
if (!identical(status, 0L)) {
  stop("Figure export failed.", call. = FALSE)
}

qa_script <- file.path(skill_dir, "scripts", "validate_figure_readability.R")
qa_status <- system2("Rscript", c(qa_script, rds_file, figures_dir, figure_name, "8", "6.5", project_dir))
if (!identical(qa_status, 0L)) {
  stop("Figure readability QA failed.", call. = FALSE)
}

writeLines(capture.output(summary(model)), file.path(output_dir, paste0(figure_name, "_model_summary.txt")))
