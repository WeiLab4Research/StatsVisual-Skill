#!/usr/bin/env Rscript
# ==============================================================================
# Kaplan-Meier Survival Curve - Lancet Style
# Following r-medical-graphics skill standard workflow
# Data: E:/桌面/dt2.csv (Colon cancer survival data)
# Output: E:/桌面/测试结果1/KM/
# Style: Lancet
# Reference: references/survival-curve.md, references/styles/lancet.md
# ==============================================================================

# ------------------------------------------------------------------------------
# Setup: Find skill directory and source library bootstrap
# ------------------------------------------------------------------------------
skill_dir <- "E:/桌面/skill/R-plot-skill/skills/r-medical-graphics"
project_dir <- "E:/桌面/测试结果1/KM"
figure_name <- "km_survival_lancet"
style <- "lancet"

source(file.path(skill_dir, "scripts", "setup_r_library.R"), local = TRUE)

# Ensure required packages are installed
rmg_ensure_packages(
  c("survival", "survminer", "ggplot2", "dplyr", "ggsci", "ragg", "svglite"),
  project_dir = project_dir,
  skill_dir = skill_dir
)

# Load theme system
source(file.path(skill_dir, "assets", "theme_medical_graphics.R"), local = TRUE)
style <- rmg_normalize_style(style)

# Load libraries
library(survival)
library(survminer)
library(ggplot2)
library(dplyr)

cat("=== Skill-based KM Survival Curve Generation ===\n")
cat(sprintf("Style: %s\n", rmg_style_label(style)))
cat(sprintf("Skill directory: %s\n", skill_dir))
cat(sprintf("Project directory: %s\n\n", project_dir))

# ------------------------------------------------------------------------------
# Prepare directories
# ------------------------------------------------------------------------------
figures_dir <- file.path(project_dir, "figures")
output_dir <- file.path(project_dir, "output")
data_dir <- file.path(project_dir, "data")
dir.create(figures_dir, showWarnings = FALSE, recursive = TRUE)
dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)
dir.create(data_dir, showWarnings = FALSE, recursive = TRUE)

# ------------------------------------------------------------------------------
# Load and validate data
# ------------------------------------------------------------------------------
data_file <- "E:/桌面/dt2.csv"
data_raw <- read.csv(data_file, stringsAsFactors = FALSE, check.names = FALSE)

# Copy data to project directory
file.copy(data_file, file.path(data_dir, "dt2.csv"), overwrite = TRUE)

cat(sprintf("Data loaded: %d rows, %d columns\n", nrow(data_raw), ncol(data_raw)))

# Validate required columns for survival analysis
required_cols <- c("time_years", "event_death", "rx")
missing_cols <- setdiff(required_cols, names(data_raw))
if (length(missing_cols) > 0) {
  stop("Missing required columns for survival analysis: ", paste(missing_cols, collapse = ", "), call. = FALSE)
}

# Clean data
data_clean <- data_raw %>%
  filter(!is.na(time_years) & !is.na(event_death) & !is.na(rx)) %>%
  mutate(
    rx = factor(rx, levels = c("Obs", "Lev", "Lev+5FU")),
    event_death = as.numeric(event_death)
  )

cat(sprintf("Clean data: %d rows (after removing NAs)\n\n", nrow(data_clean)))

# Print group summary using Lancet numeric formatting
cat("--- Group Summary ---\n")
summary_table <- data_clean %>%
  group_by(rx) %>%
  summarise(
    n = n(),
    events = sum(event_death),
    median_time = median(time_years),
    .groups = "drop"
  )
print(summary_table)
cat("\n")

# ------------------------------------------------------------------------------
# Fit survival model and perform log-rank test
# ------------------------------------------------------------------------------
fit <- survfit(Surv(time_years, event_death) ~ rx, data = data_clean)

# Log-rank test for group comparison
surv_diff <- survdiff(Surv(time_years, event_death) ~ rx, data = data_clean)
p_value <- 1 - pchisq(surv_diff$chisq, df = length(surv_diff$n) - 1)

# Use Lancet-style P-value formatting
p_formatted <- rmg_format_p(p_value, style = "lancet")
cat(sprintf("Log-rank test P-value: %s\n\n", p_formatted))

# ------------------------------------------------------------------------------
# Build KM plot with Lancet theme from skill
# ------------------------------------------------------------------------------
cat("Building Lancet-style KM survival curve...\n")

# Get Lancet palette and line defaults from skill theme system
n_groups <- nlevels(data_clean$rx)
lancet_colors <- rmg_palette(n_groups, "lancet")
line_defaults <- rmg_line_defaults("lancet")

# Generate the main survival plot with ggsurvplot
# Standardized format consistent with NEJM/JAMA/BMJ (only color differs)
p_km <- ggsurvplot(
  fit,
  data = data_clean,
  
  # Color palette from skill theme system (use palette parameter for strata)
  palette = lancet_colors,
  
  # Confidence interval settings per survival-curve.md
  conf.int = TRUE,
  conf.int.alpha = 0.15,
  
  # Risk table - standardized format: black text, no group names (use legend instead)
  risk.table = TRUE,
  risk.table.col = "black",
  risk.table.height = 0.18,
  risk.table.y.text = FALSE,
  
  # Axes and labels - standardized with other journal styles
  xlab = "Time (years)",
  ylab = "Overall Survival",
  
  # Legend placement - bottom, consistent with other styles
  legend.title = "Treatment Group",
  legend.labs = c("Observation", "Levamisole", "Lev + 5-FU"),
  legend.position = "bottom",
  
  # P-value display - compact format
  pval = TRUE,
  pval.method = TRUE,
  pval.method.title = "Log-rank ",
  pval.size = 4,
  
  # Censoring marks
  censor = TRUE,
  censor.shape = "|",
  censor.size = 4,
  
  # Line appearance - consistent with other styles
  size = 0.85,
  
  # Break time points for x-axis
  break.x.by = 2,
  
  # Apply theme - same structure as other journal styles
  ggtheme = theme_classic(base_size = 10) +
    theme(
      plot.title = element_text(face = "bold", hjust = 0, color = "black", size = rel(1.05)),
      plot.subtitle = element_text(color = "black", size = rel(0.9)),
      axis.title = element_text(face = "bold", color = "black"),
      axis.title.x = element_text(margin = margin(t = 7)),
      axis.title.y = element_text(margin = margin(r = 7)),
      axis.text = element_text(color = "black"),
      axis.line = element_line(linewidth = 0.55, colour = "black"),
      axis.ticks = element_line(linewidth = 0.45, colour = "black"),
      axis.ticks.length = unit(0.13, "cm"),
      legend.title = element_text(face = "bold", color = "black"),
      legend.text = element_text(color = "black"),
      legend.background = element_blank(),
      legend.box.background = element_blank(),
      legend.key = element_blank(),
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      plot.margin = margin(6, 7, 6, 7)
    ),
  
  # Font settings - standardized with other journal styles
  font.main = 12,
  font.submain = 10,
  font.x = 11,
  font.y = 11,
  font.tickslab = 10,
  font.legend = 10
)

# Add title in Lancet style - bold, left-aligned per lancet.md
p_km$plot <- p_km$plot +
  labs(
    title = "Kaplan-Meier Survival Analysis by Treatment Group"
  )

# Customize risk table - standardized with other journal styles
p_km$table <- p_km$table +
  theme(
    axis.text.x = element_text(size = 10, color = "black"),
    axis.title.x = element_blank()
  )

# Save plot object and export
# For ggsurvplot objects, use direct export approach
rds_file <- file.path(output_dir, paste0(figure_name, ".rds"))

# Direct export for ggsurvplot (combined plot + risk table)
pdf_file <- file.path(figures_dir, paste0(figure_name, ".pdf"))
tiff_file <- file.path(figures_dir, paste0(figure_name, "_700dpi.tiff"))
png_file <- file.path(figures_dir, paste0(figure_name, "_web.png"))
svg_file <- file.path(figures_dir, paste0(figure_name, ".svg"))

# Combine KM plot with risk table using arrange_ggsurvplots
p_combined <- arrange_ggsurvplots(
  list(p_km),
  ncol = 1,
  nrow = 1,
  height = 0.65
)

# Export to PDF (vector)
ggsave(pdf_file, plot = p_combined[[1]], width = 7, height = 7, units = "in", device = cairo_pdf)
cat(sprintf("PDF saved: %s\n", pdf_file))

# Export to SVG (editable vector) - requires svglite
if (requireNamespace("svglite", quietly = TRUE)) {
  ggsave(svg_file, plot = p_combined[[1]], width = 7, height = 7, units = "in", device = svglite::svglite)
  cat(sprintf("SVG saved: %s\n", svg_file))
}

# Export to TIFF (print, 300 dpi) - requires ragg
if (requireNamespace("ragg", quietly = TRUE)) {
  ggsave(tiff_file, plot = p_combined[[1]], width = 7, height = 7, units = "in", dpi = 300, device = ragg::agg_tiff)
  cat(sprintf("TIFF saved: %s\n", tiff_file))
}

# Export to PNG (web, <1MB) - requires ragg
if (requireNamespace("ragg", quietly = TRUE)) {
  ggsave(png_file, plot = p_combined[[1]], width = 7, height = 7, units = "in", dpi = 300, device = ragg::agg_png)
  
  # Ensure web image is under 1MB
  limit <- 1024 * 1024
  if (file.info(png_file)$size > limit) {
    ggsave(png_file, plot = p_combined[[1]], width = 5, height = 5, units = "in", dpi = 300, device = ragg::agg_png)
  }
  cat(sprintf("Web PNG saved: %s (%.0f KB)\n", png_file, file.info(png_file)$size / 1024))
}

cat("\nExport completed successfully!\n")
cat("\n=== Lancet-style KM curve generation complete ===\n")
cat("Output location:", figures_dir, "\n")