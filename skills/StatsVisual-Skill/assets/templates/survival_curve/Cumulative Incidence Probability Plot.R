#!/usr/bin/env Rscript

# Rebuild the supplied cumulative-incidence figure from OP-Trial-Dataset.
# The reference figure's HR/P annotation is preserved in one export for visual
# fidelity. A second export reports the unadjusted Cox model from this workbook.

invisible(try(Sys.setlocale('LC_CTYPE', 'Chinese_China.utf8'), silent = TRUE))

suppressPackageStartupMessages({
  library(readxl)
  library(survival)
  library(grid)
  library(svglite)
  library(ragg)
})

args <- commandArgs(trailingOnly = FALSE)
script_arg <- sub('^--file=', '', args[grepl('^--file=', args)][1])
script_dir <- dirname(normalizePath(script_arg, winslash = '/', mustWork = TRUE))
out_dir <- file.path(script_dir, 'figures')
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

input <- 'E:/桌面/StatsVisual论文/StatsVisual_中华流投稿材料/OP-Trial-Dataset_单Sheet合并.xlsx'
if (!file.exists(input)) stop('Input workbook was not found: ', input)

# These columns are H=Group, K=time (months), L=status (1=event).
d <- readxl::read_excel(
  input, range = readxl::cell_cols('H:L'),
  col_types = c('text', 'skip', 'skip', 'numeric', 'numeric'),
  .name_repair = 'minimal'
)
d <- as.data.frame(d)
stopifnot(identical(names(d), c('Group', 'time', 'status')))
stopifnot(nrow(d) == 685L, !anyNA(d), all(d$Group %in% c('RVP', 'LBBP')))
stopifnot(all(d$status %in% c(0, 1)), all(d$time >= 0))
d$Group <- factor(d$Group, levels = c('RVP', 'LBBP'))

fit <- survival::survfit(survival::Surv(time, status) ~ Group, data = d,
                         conf.type = 'log')
cox <- survival::coxph(survival::Surv(time, status) ~ Group, data = d)
cox_summary <- summary(cox)
cox_hr <- unname(cox_summary$conf.int[1, 'exp(coef)'])
cox_lo <- unname(cox_summary$conf.int[1, 'lower .95'])
cox_hi <- unname(cox_summary$conf.int[1, 'upper .95'])
cox_p <- unname(cox_summary$coefficients[1, 'Pr(>|z|)'])

risk_times <- seq(0, 60, by = 12)
risk_fit <- summary(fit, times = risk_times, extend = TRUE)
risk <- matrix(risk_fit$n.risk, nrow = 2, byrow = TRUE)
stopifnot(identical(as.integer(risk[1, ]), c(343L, 317L, 235L, 137L, 44L, 0L)))
stopifnot(identical(as.integer(risk[2, ]), c(342L, 311L, 236L, 138L, 44L, 1L)))
inc48 <- 100 * (1 - summary(fit, times = 48)$surv)
stopifnot(identical(round(inc48, 1), c(19.2, 8.5)))

# Exact colors sampled from the user's latest reference crop. The bands use
# 12% alpha, which reproduces the pale orange/blue and gray overlap.
orange <- '#D55E00'
blue <- '#0072B2'
ink <- '#1B1919'
orange_band <- grDevices::adjustcolor(orange, alpha.f = 0.12)
blue_band <- grDevices::adjustcolor(blue, alpha.f = 0.12)

W <- 930
H <- 762
ux <- function(x) unit(x / W, 'npc')
uy <- function(y) unit(1 - y / H, 'npc')
seg <- function(x0, y0, x1, y1, col = ink, lwd = 1.5, lty = 1) {
  grid.segments(ux(x0), uy(y0), ux(x1), uy(y1),
                gp = gpar(col = col, lwd = lwd, lty = lty))
}
txt <- function(label, x, y, size = 18, col = ink, face = 'plain',
                just = 'centre', rot = 0) {
  grid.text(label, ux(x), uy(y), just = just, rot = rot,
            gp = gpar(fontfamily = 'Arial', fontsize = size,
                      fontface = face, col = col))
}

make_curve <- function(name) {
  n <- unname(fit$strata)
  ix <- if (name == 'RVP') seq_len(n[1]) else n[1] + seq_len(n[2])
  z <- data.frame(time = fit$time[ix],
                  incidence = 100 * (1 - fit$surv[ix]),
                  lower = 100 * (1 - fit$upper[ix]),
                  upper = 100 * (1 - fit$lower[ix]))
  z <- z[z$time <= 60, , drop = FALSE]
  rbind(data.frame(time = 0, incidence = 0, lower = 0, upper = 0), z,
        data.frame(time = 60, incidence = tail(z$incidence, 1),
                   lower = tail(z$lower, 1), upper = tail(z$upper, 1)))
}

curves <- list(RVP = make_curve('RVP'), LBBP = make_curve('LBBP'))

step_coords <- function(t, v) {
  # Right-continuous Kaplan-Meier stairs, including horizontal ends.
  x <- c(t[1], as.vector(rbind(t[-1], t[-1])))
  y <- c(v[1], as.vector(rbind(head(v, -1), tail(v, -1))))
  list(x = x, y = y)
}

at_times <- function(z, t) {
  ix <- findInterval(t, z$time)
  z$incidence[pmax(ix, 1)]
}

draw_series <- function(x0, x1, y0, y1, ymax) {
  xmap <- function(t) x0 + (x1 - x0) * t / 60
  ymap <- function(v) y0 - (y0 - y1) * v / ymax

  # Bands first, then curves and censor marks. RVP is below LBBP.
  for (name in c('RVP', 'LBBP')) {
    z <- curves[[name]]
    a <- step_coords(z$time, z$upper)
    b <- step_coords(z$time, z$lower)
    fill <- if (name == 'RVP') orange_band else blue_band
    grid.polygon(ux(c(xmap(a$x), rev(xmap(b$x)))),
                 uy(c(ymap(a$y), rev(ymap(b$y)))),
                 gp = gpar(fill = fill, col = NA))
  }
  for (name in c('RVP', 'LBBP')) {
    z <- curves[[name]]
    a <- step_coords(z$time, z$incidence)
    line_col <- if (name == 'RVP') orange else blue
    grid.lines(ux(xmap(a$x)), uy(ymap(a$y)),
               gp = gpar(col = line_col, lwd = 2.0))
    cens <- d$time[d$Group == name & d$status == 0 & d$time <= 60]
    yc <- ymap(at_times(z, cens))
    xc <- xmap(cens)
    seg(xc - 2.8, yc, xc + 2.8, yc, col = line_col, lwd = 1.25)
    seg(xc, yc - 4.4, xc, yc + 4.4, col = line_col, lwd = 1.25)
  }
}

draw_figure <- function(annotation) {
  grid.newpage()
  grid.rect(gp = gpar(fill = 'white', col = NA))

  # Main plot: full 0-100% ordinate, with data visible in the bottom third.
  draw_series(256, 900, 477, 23, 100)
  seg(256, 23, 256, 477)
  seg(256, 477, 900, 477)
  for (v in seq(0, 100, 10)) {
    yy <- 477 - 454 * v / 100
    seg(241, yy, 256, yy, lwd = 1.4)
    txt(as.character(v), 236, yy, size = 18.5, just = 'right')
  }
  txt('Cumulative Incidence (%)', 153, 249, size = 20.5,
      face = 'bold', rot = 90)

  # Enlarged 0-30% inset.
  draw_series(384, 900, 309, 23, 30)
  seg(384, 23, 384, 309)
  seg(384, 309, 900, 309)
  for (v in seq(0, 30, 5)) {
    yy <- 309 - 286 * v / 30
    seg(371, yy, 384, yy, lwd = 1.4)
    txt(as.character(v), 366, yy, size = 17.5, just = 'right')
  }
  for (v in risk_times) {
    xx <- 384 + 516 * v / 60
    seg(xx, 309, xx, 320, lwd = 1.4)
    txt(as.character(v), xx, 341, size = 17.5)
  }

  txt(annotation[1], 398, 37, size = 18.3, just = 'left')
  txt(annotation[2], 398, 68, size = 18.3, just = 'left')
  txt('Right ventricular', 575, 161, size = 17.3,
      col = orange, face = 'bold')
  txt('pacing', 544, 193, size = 17.3,
      col = orange, face = 'bold')
  txt('Left bundle-branch pacing', 598, 290, size = 17.1,
      col = blue, face = 'bold', just = 'left')
  txt('19.2', 791, 99, size = 17.5, col = orange)
  txt('8.5', 804, 255, size = 17.5, col = blue)

  for (v in risk_times) {
    xx <- 256 + 644 * v / 60
    seg(xx, 477, xx, 490, lwd = 1.4)
    txt(as.character(v), xx, 512, size = 17.5)
  }
  txt('Months', 578, 558, size = 19.5, face = 'bold')

  # Risk counts are calculated from the workbook, rather than typed in.
  txt('No. at Risk', 21, 610, size = 19.5,
      face = 'bold', just = 'left')
  txt('Right ventricular', 21, 645, size = 17.2, just = 'left')
  txt('pacing', 49, 680, size = 17.2, just = 'left')
  txt('Left bundle-', 21, 711, size = 17.2, just = 'left')
  txt('branch pacing', 49, 743, size = 17.2, just = 'left')
  for (i in seq_along(risk_times)) {
    xx <- 256 + 644 * risk_times[i] / 60
    txt(as.character(risk[1, i]), xx, 645, size = 17.2)
    txt(as.character(risk[2, i]), xx, 710, size = 17.2)
  }
}

export_plot <- function(name, annotation) {
  base <- file.path(out_dir, name)
  svg_file <- paste0(base, '.svg')
  pdf_file <- paste0(base, '.pdf')
  png_file <- paste0(base, '.png')
  tiff_file <- paste0(base, '_700dpi.tiff')

  svglite::svglite(svg_file, width = W / 96, height = H / 96,
                   bg = 'white')
  draw_figure(annotation)
  dev.off()

  grDevices::cairo_pdf(pdf_file, width = W / 96, height = H / 96,
                       bg = 'white', family = 'Arial')
  draw_figure(annotation)
  dev.off()

  ragg::agg_png(png_file, width = W, height = H, units = 'px',
                res = 96, background = 'white')
  draw_figure(annotation)
  dev.off()

  ragg::agg_tiff(tiff_file, width = W / 96, height = H / 96,
                 units = 'in', res = 700, compression = 'lzw',
                 background = 'white')
  draw_figure(annotation)
  dev.off()
  invisible(base)
}

reference_annotation <- c(
  'Hazard ratio, 0.41 (95% CI, 0.23–0.75)',
  'P=0.003'
)
calculated_annotation <- c(
  sprintf('Hazard ratio, %.2f (95%% CI, %.2f–%.2f)', cox_hr, cox_lo, cox_hi),
  sprintf('P=%.3f', cox_p)
)

export_plot('op_trial_reference_colors_reference_annotation', reference_annotation)
export_plot('op_trial_reference_colors_recalculated_annotation', calculated_annotation)

writeLines(c(
  sprintf('Source: %s', input),
  'Outcome: time/status (identical to time_prim/status_prim in the workbook)',
  'Cumulative incidence: 100 * [1 - Kaplan-Meier survival]',
  'Pointwise 95% CI: survival::survfit conf.type="log", transformed to incidence',
  sprintf('48-month incidence: RVP %.4f%%; LBBP %.4f%%', inc48[1], inc48[2]),
  sprintf('Unadjusted Cox HR (LBBP vs RVP): %.6f (95%% CI %.6f–%.6f), Wald P=%.6f',
          cox_hr, cox_lo, cox_hi, cox_p),
  'The reference image prints HR 0.41 (95% CI 0.23–0.75), P=0.003.',
  'That reference annotation cannot be reproduced by the unadjusted model from this workbook.'
), file.path(out_dir, 'analysis_check.txt'), useBytes = TRUE)

cat('Exported plots to: ', out_dir, '\n', sep = '')
cat('Unadjusted HR: ', format(round(cox_hr, 4)),
    ' [', format(round(cox_lo, 4)), ', ', format(round(cox_hi, 4)),
    ']; P=', format(round(cox_p, 6)), '\n', sep = '')
