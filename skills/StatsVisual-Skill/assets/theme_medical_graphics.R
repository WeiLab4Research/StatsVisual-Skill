`%||%` <- function(x, y) {
  if (is.null(x)) y else x
}

theme_registry <- file.path(dirname(sys.frame(1)$ofile %||% getwd()), "styles", "theme_registry.R")
if (!file.exists(theme_registry)) {
  find_skill <- function() {
    env <- Sys.getenv("R_MEDICAL_GRAPHICS_SKILL", unset = NA_character_)
    if (!is.na(env) && nzchar(env) && file.exists(file.path(env, "SKILL.md"))) return(env)
    for (base in unique(c(getwd(), dirname(getwd())))) {
      sd <- file.path(base, "skills")
      if (dir.exists(sd)) {
        for (d in list.dirs(sd, full.names = TRUE, recursive = FALSE)) {
          if (file.exists(file.path(d, "SKILL.md"))) return(d)
        }
      }
    }
    stop("Cannot find the skill directory.")
  }
  theme_registry <- file.path(find_skill(), "assets", "styles", "theme_registry.R")
}
source(theme_registry, local = FALSE)

theme_medical_graphics <- function(base_size = NULL, base_family = "", style = "general") {
  if (is.null(base_size)) {
    base_size <- rmg_style_base_size(style)
  }
  rmg_theme(style = style, base_size = base_size, base_family = base_family)
}

medical_palette <- function(n, style = "general") {
  rmg_palette(n = n, style = style)
}