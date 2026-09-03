#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly = TRUE)
if (length(args) < 3) {
  stop("Usage: Rscript multipanel_figure.R <project_dir> <data_file> <figure_name> [layout] [style]", call. = FALSE)
}

project_dir <- normalizePath(args[[1]], winslash = "/", mustWork = TRUE)
data_file <- normalizePath(args[[2]], winslash = "/", mustWork = TRUE)
figure_name <- args[[3]]
arg4 <- if (length(args) >= 4 && nzchar(args[[4]])) args[[4]] else NA_character_
arg5 <- if (length(args) >= 5 && nzchar(args[[5]])) args[[5]] else NA_character_

figures_dir <- file.path(project_dir, "figures")
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
rmg_ensure_packages(c("ggplot2", "dplyr", "readr", "patchwork", "cowplot", "ragg", "svglite"), project_dir = project_dir, skill_dir = skill_dir)
source(file.path(skill_dir, "assets", "theme_medical_graphics.R"), local = TRUE)
source(file.path(skill_dir, "assets", "templates", "multipanel_plot", "multipanel_helpers.R"), local = TRUE)

known_styles <- c("general", "default", "general-style", "通用", "通用风格", "nature", "nature-style", "nature family", "nature-family", "nature风格", "lancet", "lancet-style", "the lancet", "lancet journal", "lancet风格", "柳叶刀", "柳叶刀风格", "nejm", "nejm-style", "new england journal of medicine", "nejm journal", "nejm风格", "新英格兰医学杂志", "新英格兰医学杂志风格", "jama", "jama-style", "jama network", "jama journal", "journal of the american medical association", "jama风格", "美国医学会杂志", "美国医学会杂志风格", "bmj", "bmj-style", "the bmj", "bmj journal", "british medical journal", "bmj风格", "英国医学杂志", "英国医学杂志风格")
if (!is.na(arg4) && tolower(trimws(arg4)) %in% known_styles && is.na(arg5)) {
  layout <- "quantitative-grid"
  style <- arg4
} else {
  layout <- if (!is.na(arg4)) arg4 else "quantitative-grid"
  style <- if (!is.na(arg5)) arg5 else "general"
}
style <- rmg_normalize_style(style)

read_table_auto <- function(path) {
  ext <- tolower(tools::file_ext(path))
  if (ext == "csv") return(readr::read_csv(path, show_col_types = FALSE))
  if (ext %in% c("tsv", "txt")) return(readr::read_tsv(path, show_col_types = FALSE))
  stop("Template supports CSV, TSV, or TXT. Adapt read_table_auto() for other inputs.", call. = FALSE)
}

data <- read_table_auto(data_file)

# Replace these placeholder mappings after writing the figure plan.
group_col <- "REPLACE_WITH_GROUP_COLUMN"
value_col <- "REPLACE_WITH_VALUE_COLUMN"
estimate_col <- "REPLACE_WITH_ESTIMATE_COLUMN"
low_col <- "REPLACE_WITH_LOW_CI_COLUMN"
high_col <- "REPLACE_WITH_HIGH_CI_COLUMN"
term_col <- "REPLACE_WITH_TERM_COLUMN"

required_cols <- c(group_col, value_col)
missing_cols <- setdiff(required_cols, names(data))
if (length(missing_cols) > 0) {
  stop(
    "Replace placeholder column names before running this scaffold. Missing: ",
    paste(missing_cols, collapse = ", "),
    call. = FALSE
  )
}

group_values <- unique(as.character(data[[group_col]]))
group_colors <- stats::setNames(rmg_palette(length(group_values), style), group_values)

p_distribution <- ggplot2::ggplot(data, ggplot2::aes(x = .data[[group_col]], y = .data[[value_col]], fill = .data[[group_col]])) +
  ggplot2::stat_boxplot(geom = "errorbar", width = 0.18, linewidth = 0.35) +
  ggplot2::geom_boxplot(width = 0.48, outlier.shape = NA, alpha = 0.7, linewidth = 0.35) +
  ggplot2::geom_jitter(width = 0.1, height = 0, alpha = 0.45, size = 1.1, color = "grey25") +
  ggplot2::scale_fill_manual(values = group_colors) +
  ggplot2::guides(fill = "none") +
  ggplot2::labs(x = NULL, y = value_col, title = "Distribution") +
  rmg_theme(style, base_size = 8)

# Replace with a task-specific effect-size table computed from the selected analysis.
if (all(c(term_col, estimate_col, low_col, high_col) %in% names(data))) {
  effect_data <- data
} else {
  effect_data <- data.frame(
    term = "Primary comparison",
    estimate = mean(data[[value_col]], na.rm = TRUE),
    low = mean(data[[value_col]], na.rm = TRUE) - stats::sd(data[[value_col]], na.rm = TRUE),
    high = mean(data[[value_col]], na.rm = TRUE) + stats::sd(data[[value_col]], na.rm = TRUE)
  )
  term_col <- "term"
  estimate_col <- "estimate"
  low_col <- "low"
  high_col <- "high"
}

p_effect <- ggplot2::ggplot(effect_data, ggplot2::aes(y = stats::reorder(.data[[term_col]], .data[[estimate_col]]), x = .data[[estimate_col]])) +
  ggplot2::geom_vline(xintercept = 0, linetype = "dashed", linewidth = 0.35, color = "grey45") +
  ggplot2::geom_errorbar(ggplot2::aes(xmin = .data[[low_col]], xmax = .data[[high_col]]), width = 0.16, linewidth = 0.42, orientation = "y") +
  ggplot2::geom_point(size = 1.9, color = rmg_palette(2, style)[[1]]) +
  ggplot2::labs(x = "Effect estimate (interval)", y = NULL, title = "Effect estimate") +
  rmg_theme(style, base_size = 8)

fig <- switch(
  layout,
  "dominant-result" = make_dominant_result_layout(p_distribution, p_effect, p_distribution, p_effect, p_distribution, p_effect),
  make_quantitative_grid(list(p_distribution, p_effect), ncol = 2)
)

source(file.path(skill_dir, "scripts", "export_publication_figures.R"))
export_publication_figures(fig, figures_dir, figure_name, 9, 5, 700, project_dir, skill_dir)