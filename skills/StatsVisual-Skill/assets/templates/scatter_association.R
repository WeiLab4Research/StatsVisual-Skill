#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly = TRUE)
if (length(args) < 5) {
  stop("Usage: Rscript scatter_association.R <project_dir> <data_file> <figure_name> <x_col> <y_col> [group_col] [smooth_method] [style]", call. = FALSE)
}

project_dir <- normalizePath(args[[1]], winslash = "/", mustWork = TRUE)
data_file <- normalizePath(args[[2]], winslash = "/", mustWork = TRUE)
figure_name <- args[[3]]
x_col <- args[[4]]
y_col <- args[[5]]
arg6 <- if (length(args) >= 6 && nzchar(args[[6]])) args[[6]] else NA_character_
arg7 <- if (length(args) >= 7 && nzchar(args[[7]])) args[[7]] else NA_character_
arg8 <- if (length(args) >= 8 && nzchar(args[[8]])) args[[8]] else NA_character_

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
rmg_ensure_packages(c("ggplot2", "dplyr", "readr", "forcats", "ragg"), project_dir = project_dir, skill_dir = skill_dir)
source(file.path(skill_dir, "assets", "theme_medical_graphics.R"), local = TRUE)

known_styles <- c("general", "default", "general-style", "通用", "通用风格", "nature", "nature-style", "nature family", "nature-family", "nature风格", "lancet", "lancet-style", "the lancet", "lancet journal", "lancet风格", "柳叶刀", "柳叶刀风格", "nejm", "nejm-style", "new england journal of medicine", "nejm journal", "nejm风格", "新英格兰医学杂志", "新英格兰医学杂志风格", "jama", "jama-style", "jama network", "jama journal", "journal of the american medical association", "jama风格", "美国医学会杂志", "美国医学会杂志风格", "bmj", "bmj-style", "the bmj", "bmj journal", "british medical journal", "bmj风格", "英国医学杂志", "英国医学杂志风格")
known_smoothers <- c("lm", "loess", "gam", "glm")
if (!is.na(arg6) && tolower(trimws(arg6)) %in% known_styles && is.na(arg7)) {
  group_col <- NA_character_
  smooth_method <- "lm"
  style <- arg6
} else if (!is.na(arg6) && tolower(trimws(arg6)) %in% known_smoothers) {
  group_col <- NA_character_
  smooth_method <- arg6
  style <- if (!is.na(arg7)) arg7 else "general"
} else {
  group_col <- arg6
  smooth_method <- if (!is.na(arg7)) arg7 else "lm"
  style <- if (!is.na(arg8)) arg8 else "general"
}
style <- rmg_normalize_style(style)

data <- readr::read_csv(data_file, show_col_types = FALSE)
required_cols <- c(x_col, y_col, group_col[!is.na(group_col)])
missing_cols <- setdiff(required_cols, names(data))
if (length(missing_cols) > 0) {
  stop("Missing required columns: ", paste(missing_cols, collapse = ", "), call. = FALSE)
}

plot_data <- data |>
  dplyr::filter(!is.na(.data[[x_col]]), !is.na(.data[[y_col]])) |>
  dplyr::mutate(
    .x = as.numeric(.data[[x_col]]),
    .y = as.numeric(.data[[y_col]])
  )

if (!is.na(group_col)) {
  plot_data <- plot_data |>
    dplyr::filter(!is.na(.data[[group_col]])) |>
    dplyr::mutate(.group = forcats::fct_inorder(as.factor(.data[[group_col]])))
}

if (nrow(plot_data) == 0) {
  stop("No complete numeric rows remain after filtering x/y columns.", call. = FALSE)
}

if (is.na(group_col)) {
  p <- ggplot2::ggplot(plot_data, ggplot2::aes(x = .x, y = .y)) +
    ggplot2::geom_point(alpha = 0.65, size = 1.6, color = rmg_palette(1, style)[[1]]) +
    ggplot2::geom_smooth(method = smooth_method, se = TRUE, linewidth = 0.7, color = "grey20", fill = "grey70")
} else {
  p <- ggplot2::ggplot(plot_data, ggplot2::aes(x = .x, y = .y, color = .group, fill = .group)) +
    ggplot2::geom_point(alpha = 0.62, size = 1.5) +
    ggplot2::geom_smooth(method = smooth_method, se = TRUE, linewidth = 0.7, alpha = 0.16) +
    ggplot2::scale_color_manual(values = rmg_palette(length(unique(plot_data$.group)), style)) +
    ggplot2::scale_fill_manual(values = rmg_palette(length(unique(plot_data$.group)), style)) +
    ggplot2::labs(color = group_col, fill = group_col)
}

p <- p +
  ggplot2::labs(x = x_col, y = y_col) +
  rmg_theme(style)

rds_file <- file.path(output_dir, paste0(figure_name, ".rds"))
saveRDS(p, rds_file)

export_script <- file.path(skill_dir, "scripts", "export_publication_figures.R")
status <- system2("Rscript", c(export_script, rds_file, figures_dir, figure_name, "7", "5", "700", project_dir))
if (!identical(status, 0L)) {
  stop("Figure export failed.", call. = FALSE)
}

qa_script <- file.path(skill_dir, "scripts", "validate_figure_readability.R")
qa_status <- system2("Rscript", c(qa_script, rds_file, figures_dir, figure_name, "7", "5", project_dir))
if (!identical(qa_status, 0L)) {
  stop("Figure readability QA failed.", call. = FALSE)
}
