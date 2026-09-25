suppressPackageStartupMessages({
  library(readxl)
  library(survival)
  library(ggplot2)
  library(dplyr)
  library(tibble)
})

format_bmj_number <- function(x, digits = 2, trim = FALSE, na_label = "NA") {
  out <- rep(na_label, length(x))
  ok <- !is.na(x)
  if (any(ok)) {
    values <- formatC(round(x[ok], digits = digits), format = "f", digits = digits)
    if (isTRUE(trim)) {
      values <- sub("\\.?0+$", "", values)
      values <- sub("\\.$", "", values)
    }
    out[ok] <- values
  }
  out
}

format_bmj_ci <- function(estimate, lower, upper, digits = 2) {
  paste0(
    format_bmj_number(estimate, digits = digits),
    " (",
    format_bmj_number(lower, digits = digits),
    " to ",
    format_bmj_number(upper, digits = digits),
    ")"
  )
}

dir.create(file.path(project_dir, "figures"), recursive = TRUE, showWarnings = FALSE)
dir.create(file.path(project_dir, "output"), recursive = TRUE, showWarnings = FALSE)

dat <- read_excel(data_file, sheet = "Figure3_Data")
required <- c(
  "USUBJID", "TRT01P", "AVAL", "CNSR", "AGEGR1", "BLECOG", "RSFA", "RSFB",
  "VISCMNY", "LIVERMNY", "LUNGMNY", "ADJTRTFL", "HER2CAT", "TFIMCAT"
)
missing_cols <- setdiff(required, names(dat))
if (length(missing_cols) > 0L) {
  stop("Missing required columns: ", paste(missing_cols, collapse = ", "), call. = FALSE)
}

dat <- dat %>%
  mutate(
    trt = if_else(TRT01P == "Pyrotinib group", 1, 0),
    event = 1 - as.integer(CNSR)
  )

if (any(!dat$CNSR %in% c(0, 1)) || any(dat$event < 0 | dat$event > 1)) {
  stop("CNSR must use 0=event and 1=censored coding.", call. = FALSE)
}

subgroups <- list(
  list(var = "AGEGR1", label = "Age", levels = c("<65 years", ">=65 years"), labels = c("<65 years", "\u226565 years")),
  list(var = "RSFB", label = "Hormone receptor status", levels = c("Negative", "Positive"), labels = c("Negative", "Positive")),
  list(var = "HER2CAT", label = "HER2 status", levels = c("1+/2+", "3+"), labels = c("1+/2+", "3+")),
  list(var = "VISCMNY", label = "Visceral metastasis", levels = c("N", "Y"), labels = c("No", "Yes")),
  list(var = "LIVERMNY", label = "Liver metastasis", levels = c("N", "Y"), labels = c("No", "Yes")),
  list(var = "LUNGMNY", label = "Lung metastasis", levels = c("N", "Y"), labels = c("No", "Yes")),
  list(var = "ADJTRTFL", label = "Prior adjuvant therapy", levels = c("No", "Yes"), labels = c("No", "Yes")),
  list(var = "RSFA", label = "Prior anti-HER2 therapy", levels = c("No", "Yes"), labels = c("No", "Yes")),
  list(var = "BLECOG", label = "ECOG performance status", levels = c("0", "1"), labels = c("0", "1")),
  list(
    var = "TFIMCAT",
    label = "Time from diagnosis to randomization",
    levels = c("X >= 24 months", "12 months <= X < 24 months", NA_character_),
    labels = c("\u226524 months", "12 to <24 months", "Not reported")
  )
)

fit_hr <- function(d, stratified = FALSE) {
  if (nrow(d) < 2L || length(unique(d$trt)) < 2L || sum(d$event) < 2L) {
    return(c(hr = NA_real_, lower = NA_real_, upper = NA_real_, se = NA_real_))
  }
  form <- if (stratified) {
    Surv(AVAL, event) ~ trt + strata(RSFA, RSFB)
  } else {
    Surv(AVAL, event) ~ trt
  }
  fit <- tryCatch(coxph(form, data = d, ties = "efron"), error = function(e) NULL)
  if (is.null(fit) || !"trt" %in% names(coef(fit))) {
    return(c(hr = NA_real_, lower = NA_real_, upper = NA_real_, se = NA_real_))
  }
  b <- unname(coef(fit)["trt"])
  s <- sqrt(unname(vcov(fit)["trt", "trt"]))
  c(hr = exp(b), lower = exp(b - 1.96 * s), upper = exp(b + 1.96 * s), se = s)
}

interaction_p <- function(d, var, levels) {
  keep <- if (anyNA(levels)) !is.na(d[[var]]) else d[[var]] %in% levels
  z <- d[keep, , drop = FALSE]
  lev <- levels[!is.na(levels)]
  z$subgroup_factor <- factor(z[[var]], levels = lev)
  z <- z[!is.na(z$subgroup_factor), , drop = FALSE]
  if (nlevels(droplevels(z$subgroup_factor)) < 2L) return(NA_real_)
  m0 <- tryCatch(coxph(Surv(AVAL, event) ~ trt + subgroup_factor, data = z, ties = "efron"), error = function(e) NULL)
  m1 <- tryCatch(coxph(Surv(AVAL, event) ~ trt * subgroup_factor, data = z, ties = "efron"), error = function(e) NULL)
  if (is.null(m0) || is.null(m1)) return(NA_real_)
  a <- tryCatch(anova(m0, m1, test = "LRT"), error = function(e) NULL)
  if (is.null(a)) return(NA_real_)
  p_col <- grep("P", names(a), value = TRUE)[1]
  if (is.na(p_col)) NA_real_ else as.numeric(a[2, p_col])
}

arm_summary <- function(d) {
  py <- d[d$TRT01P == "Pyrotinib group", , drop = FALSE]
  pl <- d[d$TRT01P == "Placebo group", , drop = FALSE]
  c(
    pyro_events = sum(py$event), pyro_n = nrow(py),
    placebo_events = sum(pl$event), placebo_n = nrow(pl)
  )
}

overall_hr <- fit_hr(dat, stratified = TRUE)
overall_n <- arm_summary(dat)
rows <- list(tibble(
  row_type = "estimate", group = "Overall", label = "Total",
  pyro_events = overall_n[["pyro_events"]], pyro_n = overall_n[["pyro_n"]],
  placebo_events = overall_n[["placebo_events"]], placebo_n = overall_n[["placebo_n"]],
  hr = overall_hr[["hr"]], lower = overall_hr[["lower"]], upper = overall_hr[["upper"]],
  se = overall_hr[["se"]], p_interaction = NA_real_
))

for (sg in subgroups) {
  p_int <- interaction_p(dat, sg$var, sg$levels)
  rows[[length(rows) + 1L]] <- tibble(
    row_type = "header", group = sg$label, label = sg$label,
    pyro_events = NA_real_, pyro_n = NA_real_, placebo_events = NA_real_, placebo_n = NA_real_,
    hr = NA_real_, lower = NA_real_, upper = NA_real_, se = NA_real_, p_interaction = p_int
  )
  for (i in seq_along(sg$levels)) {
    lev <- sg$levels[[i]]
    z <- if (is.na(lev)) {
      dat[is.na(dat[[sg$var]]), , drop = FALSE]
    } else {
      dat[!is.na(dat[[sg$var]]) & dat[[sg$var]] == lev, , drop = FALSE]
    }
    h <- fit_hr(z, stratified = FALSE)
    n <- arm_summary(z)
    rows[[length(rows) + 1L]] <- tibble(
      row_type = "estimate", group = sg$label, label = sg$labels[[i]],
      pyro_events = n[["pyro_events"]], pyro_n = n[["pyro_n"]],
      placebo_events = n[["placebo_events"]], placebo_n = n[["placebo_n"]],
      hr = h[["hr"]], lower = h[["lower"]], upper = h[["upper"]], se = h[["se"]],
      p_interaction = NA_real_
    )
  }
}

plot_df <- bind_rows(rows) %>%
  mutate(
    row_order = seq_len(n()),
    row_id = rev(seq_len(n())),
    count_pyro = if_else(
      row_type == "estimate",
      sprintf("%d/%d (%.1f)", pyro_events, pyro_n, 100 * pyro_events / pyro_n),
      ""
    ),
    count_placebo = if_else(
      row_type == "estimate",
      sprintf("%d/%d (%.1f)", placebo_events, placebo_n, 100 * placebo_events / placebo_n),
      ""
    ),
    hr_text = if_else(row_type == "estimate" & !is.na(hr), format_bmj_ci(hr, lower, upper, 2), ""),
    display_label = if_else(row_type == "estimate" & group != "Overall", paste0("   ", label), label),
    weight = if_else(!is.na(se) & se > 0, 1 / se^2, NA_real_)
  )

group_centres <- plot_df %>%
  filter(row_type == "estimate", group != "Overall") %>%
  group_by(group) %>%
  summarise(p_y = max(row_id), .groups = "drop")

p_df <- plot_df %>%
  filter(row_type == "header") %>%
  select(group, p_interaction) %>%
  left_join(group_centres, by = "group") %>%
  mutate(
    p_text = case_when(
      is.na(p_interaction) ~ "",
      p_interaction < 0.001 ~ "<0.001",
      p_interaction < 0.01 ~ formatC(p_interaction, format = "f", digits = 3),
      TRUE ~ formatC(p_interaction, format = "f", digits = 2)
    )
  )

write.csv(plot_df, file.path(project_dir, "output", "subgroup_estimates_bmj.csv"), row.names = FALSE, na = "")

forest_x0 <- 0.485
forest_x1 <- 0.690
x_limits_hr <- c(0.10, 2.00)
map_hr <- function(x) {
  forest_x0 + (x - x_limits_hr[[1]]) /
    (x_limits_hr[[2]] - x_limits_hr[[1]]) * (forest_x1 - forest_x0)
}

est_df <- plot_df %>%
  filter(row_type == "estimate", !is.na(hr)) %>%
  mutate(
    x_est = map_hr(pmin(pmax(hr, x_limits_hr[[1]]), x_limits_hr[[2]])),
    x_low = map_hr(pmin(pmax(lower, x_limits_hr[[1]]), x_limits_hr[[2]])),
    x_high = map_hr(pmin(pmax(upper, x_limits_hr[[1]]), x_limits_hr[[2]])),
    lower_clipped = lower < x_limits_hr[[1]],
    upper_clipped = upper > x_limits_hr[[2]],
    marker_size = if_else(
      group == "Overall",
      5.4,
      scales::rescale(sqrt(weight), to = c(2.4, 4.0))
    )
  )

point_df <- est_df %>%
  filter(hr >= x_limits_hr[[1]], hr <= x_limits_hr[[2]])

x_desc <- 0.015
x_pyro <- 0.205
x_placebo <- 0.365
x_hr_text <- 0.705
x_hr_header <- 0.772
x_p <- 0.910
y_header <- max(plot_df$row_id) + 3.25
y_subheader <- max(plot_df$row_id) + 1.70
y_rule <- max(plot_df$row_id) + 0.75
y_axis <- 0.20
y_bottom <- y_axis - 1.85
ticks <- c(0.10, 0.50, 1.00, 1.50, 2.00)
tick_x <- map_hr(ticks)
tick_df <- tibble(x = tick_x, xend = tick_x, y = y_axis, yend = y_axis - 0.18)
font_family <- "Arial"
text_size_mm <- 10 / ggplot2::.pt
accent_blue <- "#2F6FA5"
plot_df <- plot_df %>%
  mutate(label_x = x_desc)

p <- ggplot() +
  annotation_custom(
    grid::roundrectGrob(
      r = grid::unit(0.018, "snpc"),
      gp = grid::gpar(fill = "white", col = "#A7A9AC", lwd = 0.8)
    ),
    xmin = forest_x0, xmax = forest_x1, ymin = y_axis, ymax = max(plot_df$row_id) + 0.50
  ) +
  annotate("segment", x = 0.002, xend = 0.948, y = y_rule, yend = y_rule, linewidth = 0.50, colour = "#A7A9AC") +
  annotate("segment", x = 0.105, xend = 0.450, y = y_header - 0.82, yend = y_header - 0.82, linewidth = 0.48, colour = "#303030") +
  annotate("segment", x = forest_x0, xend = forest_x1, y = y_axis, yend = y_axis, linewidth = 0.28) +
  annotate("segment", x = map_hr(1), xend = map_hr(1), y = y_axis, yend = max(plot_df$row_id) + 0.50, linewidth = 0.32, colour = "#9A9A9A") +
  geom_segment(
    data = est_df,
    aes(x = x_low, xend = x_high, y = row_id, yend = row_id),
    linewidth = 0.85, colour = accent_blue
  ) +
  geom_segment(
    data = est_df %>% filter(lower_clipped),
    aes(x = forest_x0 + 0.012, xend = forest_x0, y = row_id, yend = row_id),
    inherit.aes = FALSE,
    linewidth = 0.85, colour = accent_blue,
    arrow = arrow(length = grid::unit(0.07, "inches"), type = "closed")
  ) +
  geom_segment(
    data = est_df %>% filter(upper_clipped),
    aes(x = forest_x1 - 0.012, xend = forest_x1, y = row_id, yend = row_id),
    inherit.aes = FALSE,
    linewidth = 0.85, colour = accent_blue,
    arrow = arrow(length = grid::unit(0.07, "inches"), type = "closed")
  ) +
  geom_point(data = point_df, aes(x = x_est, y = row_id, size = marker_size), shape = 23, fill = accent_blue, colour = "white", stroke = 0.35) +
  scale_size_identity() +
  geom_text(
    data = plot_df,
    aes(x = label_x, y = row_id, label = display_label, fontface = ifelse(row_type == "header" | group == "Overall", "bold", "plain")),
    hjust = 0, family = font_family, size = text_size_mm
  ) +
  geom_text(data = plot_df, aes(y = row_id, label = count_pyro), x = x_pyro, hjust = 0.5, family = font_family, size = text_size_mm) +
  geom_text(data = plot_df, aes(y = row_id, label = count_placebo), x = x_placebo, hjust = 0.5, family = font_family, size = text_size_mm) +
  geom_text(data = plot_df, aes(y = row_id, label = hr_text), x = x_hr_text, hjust = 0, family = font_family, size = text_size_mm) +
  geom_text(data = p_df, aes(y = p_y, label = p_text), x = x_p, hjust = 0.5, family = font_family, size = text_size_mm) +
  annotate("text", x = mean(c(x_pyro, x_placebo)), y = y_header, label = "No. of patients with PFS event/\nNo. of patients (%)", family = font_family, fontface = "bold", size = text_size_mm, lineheight = 0.95) +
  annotate("text", x = x_pyro, y = y_subheader, label = "Pyrotinib group", family = font_family, fontface = "bold", size = text_size_mm) +
  annotate("text", x = x_placebo, y = y_subheader, label = "Placebo group", family = font_family, fontface = "bold", size = text_size_mm) +
  annotate("text", x = mean(c(forest_x0, forest_x1)), y = y_subheader, label = "Hazard ratio\n(95% CI)", family = font_family, fontface = "bold", size = text_size_mm, lineheight = 0.92) +
  annotate("text", x = x_hr_header, y = y_subheader, label = "Hazard ratio\n(95% CI)", family = font_family, fontface = "bold", size = text_size_mm, lineheight = 0.92) +
  annotate("text", x = x_p, y = y_subheader, label = "P value for\ninteraction", family = font_family, fontface = "bold", size = text_size_mm, lineheight = 0.92) +
  geom_segment(data = tick_df, aes(x = x, xend = xend, y = y, yend = yend), linewidth = 0.28) +
  annotate("text", x = tick_x, y = y_axis - 0.38, label = format_bmj_number(ticks, digits = 2, trim = TRUE), family = font_family, size = text_size_mm) +
  annotate("text", x = forest_x0, y = y_axis - 1.12, label = "Pyrotinib\nbetter", family = font_family, fontface = "bold", size = text_size_mm, lineheight = 0.92) +
  annotate("text", x = forest_x1, y = y_axis - 1.12, label = "Placebo\nbetter", family = font_family, fontface = "bold", size = text_size_mm, lineheight = 0.92) +
  scale_x_continuous(expand = expansion(mult = 0, add = 0)) +
  scale_y_continuous(expand = expansion(mult = 0, add = 0)) +
  coord_cartesian(xlim = c(0, 0.950), ylim = c(y_bottom, y_header + 0.75), clip = "off") +
  theme_void(base_family = font_family) +
  theme(
    plot.background = element_rect(fill = "white", colour = NA),
    panel.background = element_rect(fill = "white", colour = NA),
    plot.margin = margin(6, 6, 6, 6)
  )

plot_rds <- file.path(project_dir, "output", paste0(figure_name, ".rds"))
saveRDS(p, plot_rds)

fig_dir <- file.path(project_dir, "figures")
width_in <- 12.4
height_in <- 11.8

ggsave(file.path(fig_dir, paste0(figure_name, ".pdf")), p, width = width_in, height = height_in, units = "in", device = cairo_pdf, bg = "white")
ggsave(file.path(fig_dir, paste0(figure_name, ".svg")), p, width = width_in, height = height_in, units = "in", device = svglite::svglite, bg = "white")
ragg::agg_tiff(file.path(fig_dir, paste0(figure_name, "_700dpi.tiff")), width = width_in, height = height_in, units = "in", res = 700, compression = "lzw", background = "white")
print(p)
dev.off()
ragg::agg_png(file.path(fig_dir, paste0(figure_name, "_300dpi.png")), width = width_in, height = height_in, units = "in", res = 300, background = "white")
print(p)
dev.off()