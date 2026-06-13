#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly = TRUE)
if (length(args) < 1) {
  stop("Usage: Rscript install_required_packages.R <pkg1> [pkg2 ...]. Use BIOC::<pkg> for Bioconductor packages.", call. = FALSE)
}

cran_repos <- Sys.getenv("R_MEDICAL_GRAPHICS_CRAN_REPOS", unset = "https://cloud.r-project.org")
script_path <- sub("^--file=", "", grep("^--file=", commandArgs(FALSE), value = TRUE)[1])
script_dir <- if (!is.na(script_path) && nzchar(script_path)) dirname(normalizePath(script_path, winslash = "/", mustWork = TRUE)) else getwd()
skill_dir <- normalizePath(file.path(script_dir, ".."), winslash = "/", mustWork = TRUE)
source(file.path(skill_dir, "scripts", "setup_r_library.R"), local = TRUE)
target_lib <- rmg_prepare_library(skill_dir = skill_dir)

install_cran <- function(pkgs) {
  missing <- pkgs[!vapply(pkgs, requireNamespace, logical(1), quietly = TRUE)]
  if (length(missing) > 0) {
    install.packages(missing, lib = target_lib, repos = cran_repos, dependencies = c("Depends", "Imports", "LinkingTo"))
  }
  still_missing <- pkgs[!vapply(pkgs, requireNamespace, logical(1), quietly = TRUE)]
  if (length(still_missing) > 0) {
    stop("Failed to install CRAN packages: ", paste(still_missing, collapse = ", "), call. = FALSE)
  }
}

install_bioc <- function(pkgs) {
  if (!requireNamespace("BiocManager", quietly = TRUE)) {
    install.packages("BiocManager", lib = target_lib, repos = cran_repos, dependencies = c("Depends", "Imports", "LinkingTo"))
  }
  if (!requireNamespace("BiocManager", quietly = TRUE)) {
    stop("Failed to install BiocManager.", call. = FALSE)
  }
  missing <- pkgs[!vapply(pkgs, requireNamespace, logical(1), quietly = TRUE)]
  if (length(missing) > 0) {
    BiocManager::install(missing, lib = target_lib, ask = FALSE, update = FALSE)
  }
  still_missing <- pkgs[!vapply(pkgs, requireNamespace, logical(1), quietly = TRUE)]
  if (length(still_missing) > 0) {
    stop("Failed to install Bioconductor packages: ", paste(still_missing, collapse = ", "), call. = FALSE)
  }
}

bioc <- sub("^BIOC::", "", args[grepl("^BIOC::", args)])
cran <- args[!grepl("^BIOC::", args)]

if (length(cran) > 0) install_cran(unique(cran))
if (length(bioc) > 0) install_bioc(unique(bioc))

message("All required packages are installed: ", paste(args, collapse = ", "))
message("User-level R library: ", target_lib)
