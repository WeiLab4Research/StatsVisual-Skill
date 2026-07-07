#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly = TRUE)
if (length(args) < 1) {
  stop("Usage: Rscript create_plot_project.R <project_dir>. A per-request project directory is required.", call. = FALSE)
}

project_dir <- args[[1]]
if (normalizePath(project_dir, winslash = "/", mustWork = FALSE) == normalizePath(".", winslash = "/", mustWork = TRUE)) {
  stop("Refusing to use the current working directory as the project root. Create or specify a per-request project directory.", call. = FALSE)
}

project_dir <- normalizePath(project_dir, winslash = "/", mustWork = FALSE)

dirs <- file.path(project_dir, c("data", "R", "output", "figures"))
created <- vapply(dirs, function(path) {
  dir.create(path, showWarnings = FALSE, recursive = TRUE) || dir.exists(path)
}, logical(1))
if (!all(created)) {
  stop("Could not create project directories: ", paste(dirs[!created], collapse = ", "), call. = FALSE)
}

message("Created plot project:")
for (dir in dirs) {
  message(" - ", dir)
}
