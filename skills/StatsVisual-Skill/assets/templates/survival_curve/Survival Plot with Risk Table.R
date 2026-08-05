## 生存曲线风险人群数

library(survival)
library(ggplot2)
library(cowplot)
library(grid)

configs <- list(
  list(
    id = "figure4b_os",
    figure_name = "nejm_dlbcl_2018_figure4b_os_km",
    data_path = "E:/桌面/NEJM_DLBCL_2018_Figure4B_OS.csv",
    groups = c("EZB", "BN2", "MCD", "N1"),
    ylab = "Overall Survival (%)",
    labels = data.frame(
      strata = c("EZB", "BN2", "MCD", "N1"),
      x = c(1.95, 2.75, 9.55, 8.50),
      y = c(82, 65, 10, 22),
      label = c("EZB", "BN2", "MCD", "N1"),
      hjust = c(0, 0, 0, 0),
      label_color = "#111111"
    )
  ),
  list(
    id = "figure4c_abc_pfs",
    figure_name = "nejm_dlbcl_2018_figure4c_abc_pfs_km",
    data_path = "E:/桌面/NEJM_DLBCL_2018_Figure4C_ABC_PFS.csv",
    groups = c("Other ABC", "BN2", "MCD", "N1"),
    ylab = "Progression-free Survival (%)",
    labels = data.frame(
      strata = c("Other ABC", "BN2", "MCD", "N1"),
      x = c(9.75, 9.75, 9.75, 5.72),
      y = c(40.2, 57.8, 14.4, 4.0),
      label = c("Other ABC", "BN2", "MCD", "N1"),
      hjust = c(1, 1, 1, 0),
      label_color = "#111111"
    )
  ),
  list(
    id = "figure4d_abc_os",
    figure_name = "nejm_dlbcl_2018_figure4d_abc_os_km",
    data_path = "E:/桌面/NEJM_DLBCL_2018_Figure4D_ABC_OS.csv",
    groups = c("Other ABC", "BN2", "MCD", "N1"),
    ylab = "Overall Survival (%)",
    labels = data.frame(
      strata = c("Other ABC", "BN2", "MCD", "N1"),
      x = c(9.45, 9.45, 9.45, 5.80),
      y = c(45.9, 71.2, 17.0, 4.0),
      label = c("Other ABC", "BN2", "MCD", "N1"),
      hjust = c(1, 1, 1, 0),
      label_color = "#111111"
    )
  )
)

colors_all <- c(
  "EZB" = "#0072B5",
  "BN2" = "#BC3C29",
  "MCD" = "#E18727",
  "N1" = "#20854E",
  "Other ABC" = "#7876B1"
)
shapes_all <- c(
  "EZB" = 16,
  "BN2" = 17,
  "MCD" = 15,
  "N1" = 18,
  "Other ABC" = 16
)

plot_one <- function(cfg) {
  project_dir <- file.path(root_dir, cfg$id)
  dir.create(project_dir, recursive = TRUE, showWarnings = FALSE)
  dir.create(file.path(project_dir, "R"), recursive = TRUE, showWarnings = FALSE)
  dir.create(file.path(project_dir, "data"), recursive = TRUE, showWarnings = FALSE)
  dir.create(file.path(project_dir, "figures"), recursive = TRUE, showWarnings = FALSE)
  
  df <- read.csv(cfg$data_path, stringsAsFactors = FALSE)
  required_cols <- c("time_years", "event", "group")
  if (!all(required_cols %in% names(df))) {
    stop("Input data must contain columns: ", paste(required_cols, collapse = ", "))
  }
  
  plot_df <- df[, required_cols]
  plot_df$time_years <- as.numeric(plot_df$time_years)
  plot_df$event <- as.integer(plot_df$event)
  plot_df$group <- factor(plot_df$group, levels = cfg$groups)
  plot_df <- plot_df[complete.cases(plot_df), ]
  if (any(plot_df$time_years < 0)) stop("Follow-up time must be non-negative.")
  if (!all(plot_df$event %in% c(0L, 1L))) stop("event must be coded 1=event, 0=censored.")
  
  file.copy(cfg$data_path, file.path(project_dir, "data", basename(cfg$data_path)), overwrite = TRUE)
  
  x_min <- 0
  x_max <- 10
  time_breaks <- seq(x_min, x_max, by = 2)
  group_levels <- cfg$groups
  family_base <- "Arial"
  axis_tick_pt <- 9.5
  axis_title_pt <- 10.5
  risk_tick_size <- axis_tick_pt / 2.845276
  risk_title_size <- axis_title_pt / 2.845276
  risk_label_x <- x_min - 0.20 * (x_max - x_min)
  
  fit <- survfit(Surv(time_years, event) ~ group, data = plot_df)
  fit_summary <- summary(fit)
  surv_df <- data.frame(
    strata = sub("^group=", "", fit_summary$strata),
    time = fit_summary$time,
    surv = fit_summary$surv * 100,
    n.risk = fit_summary$n.risk,
    n.event = fit_summary$n.event,
    n.censor = fit_summary$n.censor
  )
  start_rows <- data.frame(
    strata = group_levels,
    time = 0,
    surv = 100,
    n.risk = as.numeric(table(plot_df$group)[group_levels]),
    n.event = 0,
    n.censor = 0
  )
  surv_df <- rbind(start_rows, surv_df)
  surv_df$strata <- factor(surv_df$strata, levels = group_levels)
  surv_df <- subset(surv_df, time <= x_max)
  extension_rows <- do.call(rbind, lapply(group_levels, function(g) {
    group_df <- surv_df[as.character(surv_df$strata) == g, , drop = FALSE]
    group_df <- group_df[order(group_df$time), , drop = FALSE]
    if (nrow(group_df) == 0) return(NULL)
    last_row <- group_df[nrow(group_df), , drop = FALSE]
    if (last_row$time >= x_max || last_row$surv <= 0) return(NULL)
    last_row$time <- x_max
    last_row$n.event <- 0
    last_row$n.censor <- 0
    last_row
  }))
  if (!is.null(extension_rows)) {
    surv_df <- rbind(surv_df, extension_rows)
  }
  surv_df <- surv_df[order(as.numeric(surv_df$strata), surv_df$time), , drop = FALSE]
  
  risk_summary <- summary(fit, times = time_breaks, extend = TRUE)
  risk_df <- data.frame(
    strata = sub("^group=", "", risk_summary$strata),
    time = risk_summary$time,
    n.risk = risk_summary$n.risk
  )
  risk_df$strata <- factor(risk_df$strata, levels = group_levels)
  row_y <- setNames(seq(0.67, 0.31, length.out = length(group_levels)), group_levels)
  risk_df$row_y <- row_y[as.character(risk_df$strata)]
  
  label_df <- cfg$labels
  label_df$strata <- factor(label_df$strata, levels = group_levels)
  if (!"hjust" %in% names(label_df)) label_df$hjust <- 0
  if (!"label_color" %in% names(label_df)) label_df$label_color <- NA_character_
  colored_label_df <- subset(label_df, is.na(label_color))
  black_label_df <- subset(label_df, !is.na(label_color))
  
  main_plot <- ggplot(surv_df, aes(x = time, y = surv, color = strata)) +
    geom_step(linewidth = 0.9, lineend = "butt", direction = "hv") +
    geom_text(
      data = colored_label_df,
      aes(x = x, y = y, label = label, hjust = hjust, color = strata),
      size = 3.5,
      family = family_base,
      show.legend = FALSE
    ) +
    geom_text(
      data = black_label_df,
      aes(x = x, y = y, label = label, hjust = hjust),
      color = "#111111",
      size = 3.5,
      family = family_base,
      show.legend = FALSE
    ) +
    scale_color_manual(values = colors_all[group_levels], guide = "none") +
    scale_x_continuous(breaks = time_breaks, limits = c(x_min, x_max), expand = expansion(mult = c(0, 0))) +
    scale_y_continuous(breaks = seq(0, 100, 20), limits = c(0, 100), expand = expansion(mult = c(0, 0.01))) +
    coord_cartesian(clip = "off") +
    labs(x = "Years", y = cfg$ylab) +
    theme_classic(base_family = family_base, base_size = 10.5) +
    theme(
      axis.title = element_text(face = "bold", color = "#111111", size = axis_title_pt),
      axis.text = element_text(color = "#222222", size = axis_tick_pt),
      axis.line = element_line(color = "#111111", linewidth = 0.6),
      axis.ticks = element_line(color = "#111111", linewidth = 0.55),
      axis.ticks.length = unit(4, "pt"),
      panel.grid = element_blank(),
      plot.margin = margin(5, 22, 0, 11)
    )
  
  risk_plot <- ggplot(risk_df, aes(x = time, y = row_y)) +
    geom_text(aes(label = n.risk), size = risk_tick_size, family = family_base, color = "#222222") +
    annotate("text", x = risk_label_x, y = 0.82, label = "No. at Risk", hjust = 0, fontface = "bold", size = risk_title_size, family = family_base) +
    scale_x_continuous(breaks = time_breaks, expand = expansion(mult = c(0, 0))) +
    scale_y_continuous(limits = c(0.24, 0.90), expand = c(0, 0)) +
    coord_cartesian(xlim = c(x_min, x_max), clip = "off") +
    theme_void(base_family = family_base, base_size = 10) +
    theme(plot.margin = margin(0, 22, 2, 92))
  
  for (g in group_levels) {
    risk_plot <- risk_plot +
      annotate("text", x = risk_label_x, y = row_y[g], label = g, hjust = 0, size = risk_tick_size, family = family_base)
  }
  
  combined <- cowplot::plot_grid(
    main_plot,
    risk_plot,
    ncol = 1,
    align = "v",
    axis = "lr",
    rel_heights = c(0.82, 0.18)
  )
  
  fig_dir <- file.path(project_dir, "figures")
  pdf_file <- file.path(fig_dir, paste0(cfg$figure_name, ".pdf"))
  svg_file <- file.path(fig_dir, paste0(cfg$figure_name, ".svg"))
  tiff_file <- file.path(fig_dir, paste0(cfg$figure_name, "_700dpi.tiff"))
  png_file <- file.path(fig_dir, paste0(cfg$figure_name, "_web.png"))
  
  ggsave(pdf_file, plot = combined, width = 6, height = 4.2, units = "in", device = cairo_pdf, bg = "white")
  svglite::svglite(svg_file, width = 6, height = 4.2, bg = "white")
  print(combined)
  dev.off()
  ragg::agg_tiff(tiff_file, width = 6, height = 4.2, units = "in", res = 700, background = "white", compression = "lzw")
  print(combined)
  dev.off()
  ragg::agg_png(png_file, width = 6, height = 4.2, units = "in", res = 300, background = "white")
  print(combined)
  dev.off()