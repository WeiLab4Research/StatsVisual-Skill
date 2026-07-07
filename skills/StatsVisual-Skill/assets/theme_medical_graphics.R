`%||%` <- function(x, y) {
  if (is.null(x)) y else x
}

theme_registry <- file.path(dirname(sys.frame(1)$ofile %||% getwd()), "styles", "theme_registry.R")
if (!file.exists(theme_registry)) {
  theme_registry <- file.path(getwd(), "skills", "r-medical-graphics", "assets", "styles", "theme_registry.R")
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
