#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly = TRUE)
include_optional <- "--include-optional" %in% args
required <- args[args != "--include-optional"]
if (length(required) == 0) {
  required <- c(
    "ggplot2", "ragg", "dplyr", "tidyr", "readr", "readxl", "tibble", "purrr",
    "scales", "forcats", "stringr", "lubridate",
    "patchwork", "cowplot", "ggpubr", "ggrepel",
    "RColorBrewer", "viridis", "viridisLite", "ggsci",
    "ggridges", "ggbeeswarm", "ggdist", "ggpointdensity", "GGally", "ggExtra",
    "pheatmap", "corrplot", "forestplot", "broom",
    "survival", "survminer", "ggsurvfit",
    "ggtern", "svglite", "magick", "showtext", "sysfonts"
  )
}
optional <- c("ComplexHeatmap", "circlize")
if (include_optional) required <- unique(c(required, optional))

read_renviron_lib <- function() {
  renviron <- file.path(path.expand("~"), ".Renviron")
  if (!file.exists(renviron)) return(NA_character_)
  lines <- readLines(renviron, warn = FALSE)
  hit <- grep("^R_MEDICAL_GRAPHICS_LIB=", lines, value = TRUE)
  if (length(hit) == 0) return(NA_character_)
  sub("^R_MEDICAL_GRAPHICS_LIB=", "", hit[[length(hit)]])
}

script_path <- sub("^--file=", "", grep("^--file=", commandArgs(FALSE), value = TRUE)[1])
script_dir <- if (!is.na(script_path) && nzchar(script_path)) dirname(normalizePath(script_path, winslash = "/", mustWork = FALSE)) else getwd()
repo_root <- normalizePath(file.path(script_dir, "..", "..", ".."), winslash = "/", mustWork = FALSE)

configured_lib <- Sys.getenv("R_MEDICAL_GRAPHICS_LIB", unset = NA_character_)
if (is.na(configured_lib) || !nzchar(configured_lib)) {
  configured_lib <- read_renviron_lib()
}
candidates <- c(
  configured_lib,
  file.path(repo_root, ".r-medical-graphics-library"),
  file.path(Sys.getenv("LOCALAPPDATA", unset = ""), "R", "r-medical-graphics-library"),
  file.path(getwd(), ".r-medical-graphics-library")
)
candidates <- unique(candidates[!is.na(candidates) & nzchar(candidates)])
existing <- candidates[dir.exists(candidates)]
if (length(existing) > 0) {
  .libPaths(unique(c(normalizePath(existing, winslash = "/", mustWork = TRUE), .libPaths())))
}

cat("R executable:", R.home("bin"), "\n")
cat("R version:", paste(R.version$major, R.version$minor, sep = "."), "\n")
cat("R_MEDICAL_GRAPHICS_LIB:", ifelse(is.na(configured_lib) || !nzchar(configured_lib), "<unset>", configured_lib), "\n")
cat("Candidate libraries:\n")
cat(paste0(" - ", candidates), sep = "\n")
cat("\n")
cat(".libPaths():\n")
cat(paste0(" - ", .libPaths()), sep = "\n")
cat("\n\n")

installed <- vapply(required, requireNamespace, logical(1), quietly = TRUE)
for (pkg in required) {
  status <- if (installed[[pkg]]) "OK" else "MISSING"
  version <- if (installed[[pkg]]) as.character(utils::packageVersion(pkg)) else ""
  cat(sprintf("%-12s %s %s\n", pkg, status, version))
}

if (!all(installed)) {
  missing <- names(installed)[!installed]
  stop("Missing packages: ", paste(missing, collapse = ", "), call. = FALSE)
}

cat("\nAll required packages are available.\n")
if (!include_optional) {
  opt_installed <- vapply(optional, requireNamespace, logical(1), quietly = TRUE)
  cat("\nOptional Bioconductor packages:\n")
  for (pkg in optional) {
    status <- if (opt_installed[[pkg]]) "OK" else "MISSING"
    version <- if (opt_installed[[pkg]]) as.character(utils::packageVersion(pkg)) else ""
    cat(sprintf("%-16s %s %s\n", pkg, status, version))
  }
  cat("Use --include-optional to require optional packages in this check.\n")
}
