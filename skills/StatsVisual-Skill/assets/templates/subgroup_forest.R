################################################################################
# Lancet-style forest plot for dt4.csv
# Pure-grid implementation: every element is drawn with grid primitives
# at explicit npc coordinates, guaranteeing perfect alignment.
#
# Layout (top to bottom):
#   1. Main title
#   2. Column header row (Subgroup/level | N | HR axis header | HR text | P int.)
#   3. Full-width horizontal rule
#   4. Body rows (Overall + 9 subgroups with levels and spacers)
#   5. Footer
################################################################################

suppressPackageStartupMessages({
  library(ggplot2)
  library(dplyr)
  library(forcats)
  library(stringr)
  library(readr)
  library(grid)
})

source("E:/桌面/skill/R-plot-skill/skills/r-medical-graphics/assets/styles/theme_registry.R")

# ---------- Format helpers (Lancet: midline decimal, en-dash) ----------
fmt_num <- function(x, digits = 2) {
  out <- rep("", length(x))
  ok <- !is.na(x)
  out[ok] <- formatC(round(x[ok], digits), format = "f", digits = digits)
  gsub(".", "\u00b7", out, fixed = TRUE)
}

fmt_ci <- function(est, low, high, digits = 2) {
  paste0(
    fmt_num(est, digits), " (",
    fmt_num(low, digits), "\u2013", fmt_num(high, digits), ")"
  )
}

fmt_p <- function(p, threshold = 0.001) {
  ifelse(is.na(p), "",
         ifelse(p < threshold,
                paste0("<\u00b7", sprintf("%03d", round(threshold * 1000))),
                formatC(round(p, 2), format = "f", digits = 2)))
}

# ---------- Paths ----------
project_dir <- "E:/桌面/测试结果1/F"
fig_dir     <- file.path(project_dir, "figures")
out_dir     <- file.path(project_dir, "output")
R_dir       <- file.path(project_dir, "R")
dir.create(fig_dir, showWarnings = FALSE, recursive = TRUE)
dir.create(out_dir, showWarnings = FALSE, recursive = TRUE)
dir.create(R_dir,   showWarnings = FALSE, recursive = TRUE)

data_path <- file.path(project_dir, "data/dt4.csv")

# ---------- Read & prepare ----------
raw <- read_csv(data_path, locale = locale(encoding = "GBK"),
                show_col_types = FALSE, progress = FALSE)

subgroup_order <- c("Overall", setdiff(unique(raw$subgroup_variable), "Overall"))

# ---------- Build row coordinate system ----------
# Each row occupies ROW_STEP physical units in the y direction.
# Spacers are smaller.
ROW_STEP  <- 1.0   # main row height
SPAC_STEP <- 0.4   # gap between subgroups
HDR_STEP  <- 1.0   # subgroup header (same as a data row)

row_records <- list()
y_counter <- 0

for (g in subgroup_order) {
  gdf <- raw %>% filter(subgroup_variable == g)

  if (g == "Overall") {
    for (i in seq_len(nrow(gdf))) {
      y_counter <- y_counter + ROW_STEP
      row_records[[length(row_records) + 1]] <- data.frame(
        row_kind = "data",
        y = y_counter,
        subgroup_variable = g, subgroup_level = gdf$subgroup_level[i],
        is_header = FALSE,
        est = gdf$hazard_ratio[i], lo = gdf$ci_low[i], hi = gdf$ci_high[i],
        n_pat = gdf$no_of_patients[i], p_int = NA_real_,
        stringsAsFactors = FALSE
      )
    }
    y_counter <- y_counter + SPAC_STEP
  } else {
    y_counter <- y_counter + HDR_STEP
    row_records[[length(row_records) + 1]] <- data.frame(
      row_kind = "header",
      y = y_counter,
      subgroup_variable = g, subgroup_level = NA_character_,
      is_header = TRUE,
      est = NA_real_, lo = NA_real_, hi = NA_real_,
      n_pat = NA_real_, p_int = gdf$p_for_interaction[1],
      stringsAsFactors = FALSE
    )
    for (i in seq_len(nrow(gdf))) {
      y_counter <- y_counter + ROW_STEP
      row_records[[length(row_records) + 1]] <- data.frame(
        row_kind = "data",
        y = y_counter,
        subgroup_variable = g, subgroup_level = gdf$subgroup_level[i],
        is_header = FALSE,
        est = gdf$hazard_ratio[i], lo = gdf$ci_low[i], hi = gdf$ci_high[i],
        n_pat = gdf$no_of_patients[i], p_int = NA_real_,
        stringsAsFactors = FALSE
      )
    }
    y_counter <- y_counter + SPAC_STEP
  }
}

plot_df <- bind_rows(row_records)
y_max <- max(plot_df$y)

# Display labels
plot_df$label <- ifelse(
  is.na(plot_df$is_header), "",
  ifelse(plot_df$is_header,
         plot_df$subgroup_variable,
         ifelse(plot_df$subgroup_level == "Overall",
                plot_df$subgroup_level,
                paste0("  ", plot_df$subgroup_level)))
)

plot_df$n_text    <- ifelse(is.na(plot_df$n_pat), "", formatC(plot_df$n_pat, big.mark = ",", format = "d"))
plot_df$ci_text   <- ifelse(is.na(plot_df$est), "", fmt_ci(plot_df$est, plot_df$lo, plot_df$hi, digits = 2))
plot_df$pint_text <- ifelse(is.na(plot_df$p_int), "", fmt_p(plot_df$p_int))

# Marker sizes (white squares sized by sqrt of n)
n_max_n <- max(plot_df$n_pat, na.rm = TRUE)
plot_df$pt_size <- ifelse(is.na(plot_df$n_pat), NA_real_,
                          1.6 + 3.2 * sqrt(plot_df$n_pat / n_max_n))

# ---------- Draw the figure with pure grid primitives ----------
# X coordinates of column LEFT edges (in npc, where npc 0=left, 1=right of body panel)
# Column widths (in fractions of figure width)
X_LABEL_LEFT  <- 0.000   # left edge of label column
X_N_LEFT      <- 0.300   # N column starts
X_FOREST_LEFT <- 0.370   # forest axis starts
X_HR_LEFT     <- 0.760   # HR text column starts
X_P_LEFT      <- 0.910   # P int. column starts
X_RIGHT       <- 1.000   # right edge

# Forest axis range: linear HR scale 0 to 2.5 maps to
# (X_FOREST_LEFT, X_HR_LEFT). This gives a closed axis with equal
# spacing between consecutive tick values, so 0 and 2.5 are at the two
# ends.
forest_x_min <- 0
forest_x_max <- 2.5
forest_x_range <- forest_x_max - forest_x_min  # 2.5

# Convert an HR value to npc x
hr_to_npc <- function(hr) {
  X_FOREST_LEFT + (hr - forest_x_min) / forest_x_range *
    (X_HR_LEFT - X_FOREST_LEFT)
}

# Tick positions (closed axis endpoints included)
hr_ticks <- c(0, 0.5, 1.0, 1.5, 2.0, 2.5)

draw_full_figure <- function(plot_df, fig_w_in = 11.0, fig_h_in = 9.0) {
  # Vertical layout (inches)
  h_title  <- 0.45
  h_header <- 0.30
  h_rule   <- 0.05
  h_body   <- 7.20
  h_footer <- 0.20
  total_h  <- h_title + h_header + h_rule + h_body + h_footer
  if (abs(total_h - fig_h_in) > 0.01) h_body <- h_body + (fig_h_in - total_h)

  grid.newpage()
  pushViewport(viewport(
    layout = grid.layout(
      nrow = 5, ncol = 1,
      widths  = unit(fig_w_in, "inches"),
      heights = unit(c(h_title, h_header, h_rule, h_body, h_footer), "inches")
    ),
    gp = gpar(fill = "white")
  ))

  # ---- Row 1: main title ----
  pushViewport(viewport(layout.pos.row = 1, layout.pos.col = 1))
  grid.rect(gp = gpar(fill = "white", col = NA))
  grid.text(
    "Time to first all-cause shock: subgroup analysis of ATP plus shock vs shock only",
    x = unit(0.0, "npc"), y = unit(0.5, "npc"),
    just = c("left", "center"),
    gp = gpar(fontface = "bold", fontsize = 11, col = "grey10",
              fontfamily = "sans")
  )
  popViewport()

  # ---- Row 2: column headers ----
  pushViewport(viewport(layout.pos.row = 2, layout.pos.col = 1))
  grid.rect(gp = gpar(fill = "white", col = NA))
  headers <- list(
    list(x = X_LABEL_LEFT + 0.005, just = "left",   label = "Subgroup / level"),
    list(x = X_N_LEFT,             just = "center", label = "N"),
    list(x = (X_FOREST_LEFT + X_HR_LEFT) / 2, just = "center", label = "Hazard ratio (95% CI)"),
    list(x = X_HR_LEFT + 0.005,    just = "left",   label = "HR (95% CI)"),
    list(x = X_P_LEFT,             just = "left",   label = "P int.")
  )
  for (h in headers) {
    grid.text(h$label,
              x = unit(h$x, "npc"), y = unit(0.5, "npc"),
              just = c(h$just, "center"),
              gp = gpar(fontface = "bold", fontsize = 9, col = "grey10",
                        fontfamily = "sans"))
  }
  popViewport()

  # ---- Row 3: full-width horizontal rule (bold) ----
  pushViewport(viewport(layout.pos.row = 3, layout.pos.col = 1))
  grid.rect(gp = gpar(fill = "white", col = NA))
  grid.lines(
    x = unit(c(0.005, 0.995), "npc"),
    y = unit(0.5, "npc"),
    gp = gpar(lwd = 2.0, col = "grey10")
  )
  popViewport()

  # ---- Row 4: body (forest + table cells) ----
  pushViewport(viewport(layout.pos.row = 4, layout.pos.col = 1))
  grid.rect(gp = gpar(fill = "white", col = NA))

  # Convert data y to npc y (top = 0.95, bottom = 0.12).
  # Reserve the bottom 12% of the body for the forest axis line and tick labels.
  y_to_npc <- function(y) 0.95 - 0.83 * (y - 1) / (y_max - 1)

  # Forest axis baseline (bottom of the body)
  forest_x_left_npc  <- X_FOREST_LEFT
  forest_x_right_npc <- X_HR_LEFT

  # Vertical reference line at HR = 1
  ref_x_npc <- hr_to_npc(1)
  grid.lines(
    x = unit(c(ref_x_npc, ref_x_npc), "npc"),
    y = unit(c(0.0, 1.0), "npc"),
    gp = gpar(lty = "dashed", lwd = 0.6, col = "grey30")
  )

  # Draw each data row
  for (i in seq_len(nrow(plot_df))) {
    if (is.na(plot_df$is_header[i])) next  # spacer
    y_npc <- y_to_npc(plot_df$y[i])

    if (plot_df$is_header[i]) {
      # Bold subgroup header — only label + P int. text
      grid.text(plot_df$subgroup_variable[i],
                x = unit(X_LABEL_LEFT + 0.005, "npc"),
                y = unit(y_npc, "npc"),
                just = c("left", "center"),
                gp = gpar(fontface = "bold", fontsize = 9.5, col = "grey10",
                          fontfamily = "sans"))
      if (nzchar(plot_df$pint_text[i])) {
        grid.text(plot_df$pint_text[i],
                  x = unit(X_P_LEFT, "npc"),
                  y = unit(y_npc, "npc"),
                  just = c("left", "center"),
                  gp = gpar(fontface = "plain", fontsize = 9, col = "grey10",
                            fontfamily = "sans"))
      }
    } else {
      # Data row
      # Label
      is_overall <- !is.na(plot_df$subgroup_level[i]) &&
        plot_df$subgroup_level[i] == "Overall"
      grid.text(plot_df$label[i],
                x = unit(X_LABEL_LEFT + 0.005, "npc"),
                y = unit(y_npc, "npc"),
                just = c("left", "center"),
                gp = gpar(
                  fontface = if (is_overall) "bold" else "plain",
                  fontsize = if (is_overall) 9.5 else 8.5,
                  col = "grey10",
                  fontfamily = "sans"
                ))
      # N
      grid.text(plot_df$n_text[i],
                x = unit(X_N_LEFT, "npc"),
                y = unit(y_npc, "npc"),
                just = c("center", "center"),
                gp = gpar(fontface = "plain", fontsize = 8.5, col = "grey10",
                          fontfamily = "sans"))
      # CI whisker — clip the CI endpoints to the closed forest axis x
      # range [0, 2.5] so that very wide CIs do not extend beyond the
      # axis endpoints. Use 0.001 (just inside 0) for the lower clip
      # because log10(0) = -Inf, and 2.5 for the upper clip.
      lo_clip <- max(plot_df$lo[i], 0.001)
      hi_clip <- min(plot_df$hi[i], 2.5)
      x_lo_npc <- hr_to_npc(lo_clip)
      x_hi_npc <- hr_to_npc(hi_clip)
      x_est_npc <- hr_to_npc(plot_df$est[i])
      grid.lines(
        x = unit(c(x_lo_npc, x_hi_npc), "npc"),
        y = unit(c(y_npc, y_npc), "npc"),
        gp = gpar(lwd = 0.55, col = "black")
      )
      # Square marker — use physical units (inches) so the marker is a
      # TRUE square regardless of figure aspect ratio. pt_size ranges
      # roughly 1.6..4.8, which we map to 0.06"..0.18".
      sz_in <- 0.04 + 0.025 * (plot_df$pt_size[i] - 1.6)  # 1.6→0.04, 4.8→0.14
      grid.rect(
        x = unit(x_est_npc, "npc"),
        y = unit(y_npc, "npc"),
        width  = unit(sz_in, "inches"),
        height = unit(sz_in, "inches"),
        just = "center",
        gp = gpar(fill = "black", col = "black", lwd = 0.7)
      )
      # HR (95% CI) text
      grid.text(plot_df$ci_text[i],
                x = unit(X_HR_LEFT + 0.005, "npc"),
                y = unit(y_npc, "npc"),
                just = c("left", "center"),
                gp = gpar(fontface = "plain", fontsize = 8.5, col = "grey10",
                          fontfamily = "sans"))
    }
  }

  # Forest axis line at the bottom of the data area (just above tick labels)
  axis_y_npc <- 0.10
  grid.lines(
    x = unit(c(forest_x_left_npc, forest_x_right_npc), "npc"),
    y = unit(c(axis_y_npc, axis_y_npc), "npc"),
    gp = gpar(lwd = 0.55, col = "grey10")
  )

  # Forest axis ticks + numeric labels below the axis
  tick_labels <- c("0", "0\u00b75", "1\u00b70", "1\u00b75", "2\u00b70", "2\u00b75")
  for (k in seq_along(hr_ticks)) {
    x_npc <- hr_to_npc(hr_ticks[k])
    # Tick mark (short vertical line). End caps (k=1 and k=length) are
    # slightly longer so the axis looks closed, but kept short overall.
    tick_h <- if (k == 1 || k == length(hr_ticks)) 0.015 else 0.008
    grid.lines(
      x = unit(c(x_npc, x_npc), "npc"),
      y = unit(c(axis_y_npc, axis_y_npc - tick_h), "npc"),
      gp = gpar(lwd = 0.5, col = "grey10")
    )
    # Tick label below the tick — include all ticks including 0 and 2.5
    grid.text(
      tick_labels[k],
      x = unit(x_npc, "npc"),
      y = unit(axis_y_npc - 0.035, "npc"),
      just = c("center", "top"),
      gp = gpar(fontface = "plain", fontsize = 8.5, col = "grey10",
                fontfamily = "sans")
    )
  }

  # Direction annotation under the axis:
  #   "← Favours ATP + shock"   on the left half
  #   "Favours shock only →"    on the right half
  dir_y_npc <- axis_y_npc - 0.075
  left_mid  <- (X_FOREST_LEFT + hr_to_npc(1)) / 2
  right_mid <- (hr_to_npc(1) + X_HR_LEFT) / 2
  grid.text(
    "\u2190  Favours ATP + shock",
    x = unit(left_mid, "npc"),
    y = unit(dir_y_npc, "npc"),
    just = c("center", "top"),
    gp = gpar(fontface = "plain", fontsize = 8.5, col = "grey30",
              fontfamily = "sans")
  )
  grid.text(
    "Favours shock only  \u2192",
    x = unit(right_mid, "npc"),
    y = unit(dir_y_npc, "npc"),
    just = c("center", "top"),
    gp = gpar(fontface = "plain", fontsize = 8.5, col = "grey30",
              fontfamily = "sans")
  )

  popViewport()

  # ---- Row 5: footer (notes removed per user request) ----
  pushViewport(viewport(layout.pos.row = 5, layout.pos.col = 1))
  grid.rect(gp = gpar(fill = "white", col = NA))
  popViewport()
}

# Save RDS
saveRDS(plot_df, file.path(R_dir, "plot_df.rds"))

# ---- Export figures ----
FIG_W <- 11.0; FIG_H <- 9.0
cairo_pdf(file.path(fig_dir, "forest_lancet.pdf"), width = FIG_W, height = FIG_H, onefile = TRUE)
draw_full_figure(plot_df, fig_w_in = FIG_W, fig_h_in = FIG_H)
dev.off()

svglite::svglite(file.path(fig_dir, "forest_lancet.svg"), width = FIG_W, height = FIG_H)
draw_full_figure(plot_df, fig_w_in = FIG_W, fig_h_in = FIG_H)
dev.off()

tiff(file.path(fig_dir, "forest_lancet_700dpi.tiff"),
     width = FIG_W, height = FIG_H, units = "in", res = 700, compression = "lzw")
draw_full_figure(plot_df, fig_w_in = FIG_W, fig_h_in = FIG_H)
dev.off()

png_path <- file.path(fig_dir, "forest_lancet_web.png")
export_png <- function(path, res) {
  png(path, width = FIG_W, height = FIG_H, units = "in", res = res, type = "cairo-png")
  draw_full_figure(plot_df, fig_w_in = FIG_W, fig_h_in = FIG_H)
  dev.off()
}
export_png(png_path, 200)
if (file.info(png_path)$size / 1024 > 950) export_png(png_path, 140)
if (file.info(png_path)$size / 1024 > 950) export_png(png_path, 110)

writeLines(capture.output(sessionInfo()), file.path(out_dir, "session_info.txt"))

cat("\n--- Output files ---\n")
for (f in list.files(fig_dir, full.names = TRUE)) {
  cat(sprintf("  %s   %.1f KB\n", basename(f), file.info(f)$size / 1024))
}
cat("\nDONE\n")
