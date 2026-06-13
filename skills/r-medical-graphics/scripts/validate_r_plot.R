#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly = TRUE)
if (length(args) < 1) {
  stop("Usage: Rscript validate_r_plot.R <script_or_figures_dir>", call. = FALSE)
}

target <- args[[1]]

if (file.exists(target) && grepl("\\.[rR]$", target)) {
  status <- system2("Rscript", target)
  if (!identical(status, 0L)) {
    stop("R script failed: ", target, call. = FALSE)
  }
  message("Script ran successfully: ", target)
  quit(status = 0)
}

figures_dir <- target
if (!dir.exists(figures_dir)) {
  stop("Target is neither an R script nor a directory: ", target, call. = FALSE)
}

files <- list.files(figures_dir, full.names = TRUE)
pdfs <- files[grepl("\\.pdf$", files, ignore.case = TRUE)]
svgs <- files[grepl("\\.svg$", files, ignore.case = TRUE)]
tiffs <- files[grepl("\\.tiff?$", files, ignore.case = TRUE)]
web <- files[grepl("_web\\.(png|jpg|jpeg)$", files, ignore.case = TRUE)]

problems <- character()
check_nonempty <- function(paths, label) {
  if (length(paths) == 0) return(paste("Missing", label))
  empty <- paths[file.info(paths)$size <= 0]
  if (length(empty) > 0) paste("Empty", label, paste(basename(empty), collapse = ", ")) else character()
}

problems <- c(problems, check_nonempty(pdfs, "PDF"))
problems <- c(problems, check_nonempty(svgs, "SVG"))
problems <- c(problems, check_nonempty(tiffs, "TIFF"))
problems <- c(problems, check_nonempty(web, "web image"))

svg_without_text <- svgs[file.exists(svgs) & !vapply(svgs, function(path) {
  any(grepl("<text|<tspan", readLines(path, warn = FALSE), fixed = FALSE))
}, logical(1))]
if (length(svg_without_text) > 0) {
  problems <- c(problems, paste("SVG may not contain editable text:", paste(basename(svg_without_text), collapse = ", ")))
}

large_web <- web[file.info(web)$size > 1024 * 1024]
if (length(large_web) > 0) {
  problems <- c(problems, paste("Web image over 1 MB:", paste(basename(large_web), collapse = ", ")))
}

if (length(problems) > 0) {
  stop(paste(problems, collapse = "\n"), call. = FALSE)
}

message("Figure validation passed for: ", normalizePath(figures_dir, winslash = "/", mustWork = FALSE))
