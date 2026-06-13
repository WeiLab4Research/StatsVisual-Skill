read_rmg_renviron_lib <- function() {
  renviron <- file.path(path.expand("~"), ".Renviron")
  if (!file.exists(renviron)) return(NA_character_)
  lines <- readLines(renviron, warn = FALSE)
  hit <- grep("^R_MEDICAL_GRAPHICS_LIB=", lines, value = TRUE)
  if (length(hit) == 0) return(NA_character_)
  sub("^R_MEDICAL_GRAPHICS_LIB=", "", hit[[length(hit)]])
}

rmg_repo_root <- function(skill_dir = NULL) {
  if (!is.null(skill_dir) && nzchar(skill_dir)) {
    return(normalizePath(file.path(skill_dir, "..", ".."), winslash = "/", mustWork = FALSE))
  }
  normalizePath(getwd(), winslash = "/", mustWork = FALSE)
}

rmg_library_candidates <- function(project_dir = NULL, skill_dir = NULL) {
  repo_root <- rmg_repo_root(skill_dir)
  configured <- Sys.getenv("R_MEDICAL_GRAPHICS_LIB", unset = NA_character_)
  if (is.na(configured) || !nzchar(configured)) configured <- read_rmg_renviron_lib()
  project_lib <- if (!is.null(project_dir) && nzchar(project_dir)) file.path(project_dir, "R-library") else NA_character_
  candidates <- c(
    file.path(repo_root, ".r-medical-graphics-library"),
    project_lib,
    configured,
    file.path(Sys.getenv("LOCALAPPDATA", unset = ""), "R", "r-medical-graphics-library")
  )
  unique(candidates[!is.na(candidates) & nzchar(candidates)])
}

rmg_prepare_library <- function(project_dir = NULL, skill_dir = NULL) {
  candidates <- rmg_library_candidates(project_dir = project_dir, skill_dir = skill_dir)

  existing <- candidates[dir.exists(candidates)]
  if (length(existing) > 0) {
    .libPaths(unique(c(normalizePath(existing, winslash = "/", mustWork = TRUE), .libPaths())))
  }

  for (candidate in candidates) {
    suppressWarnings(dir.create(candidate, showWarnings = FALSE, recursive = TRUE))
    if (!dir.exists(candidate)) next
    test_file <- file.path(candidate, ".write-test")
    can_write <- suppressWarnings(tryCatch({
      writeLines("ok", test_file)
      unlink(test_file)
      TRUE
    }, error = function(e) FALSE))
    if (can_write) {
      lib <- normalizePath(candidate, winslash = "/", mustWork = TRUE)
      .libPaths(unique(c(lib, .libPaths())))
      return(lib)
    }
  }

  stop("Cannot create a writable R package library. Tried: ", paste(candidates, collapse = ", "), call. = FALSE)
}

rmg_ensure_packages <- function(pkgs, project_dir = NULL, skill_dir = NULL, repos = NULL) {
  lib <- rmg_prepare_library(project_dir = project_dir, skill_dir = skill_dir)
  missing <- pkgs[!vapply(pkgs, requireNamespace, logical(1), quietly = TRUE)]
  if (length(missing) == 0) return(invisible(lib))

  if (is.null(repos)) {
    repos <- Sys.getenv("R_MEDICAL_GRAPHICS_CRAN_REPOS", unset = "https://cloud.r-project.org")
  }
  repos <- unique(unlist(strsplit(repos, ",", fixed = TRUE)))
  repos <- trimws(repos[nzchar(repos)])
  if (length(repos) == 0) repos <- "https://cloud.r-project.org"

  last_error <- NULL
  for (repo in repos) {
    ok <- tryCatch({
      install.packages(missing, lib = lib, repos = repo, dependencies = c("Depends", "Imports", "LinkingTo"))
      TRUE
    }, error = function(e) {
      last_error <<- conditionMessage(e)
      FALSE
    })
    still_missing <- pkgs[!vapply(pkgs, requireNamespace, logical(1), quietly = TRUE)]
    if (ok && length(still_missing) == 0) return(invisible(lib))
    missing <- still_missing
  }

  stop(
    "Failed to install required packages: ", paste(missing, collapse = ", "),
    if (!is.null(last_error)) paste0(". Last error: ", last_error) else "",
    call. = FALSE
  )
}
