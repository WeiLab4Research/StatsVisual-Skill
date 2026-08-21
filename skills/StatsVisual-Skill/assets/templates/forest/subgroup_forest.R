# CHART_TYPE: Subgroup forest plot (HR with 95% CI)
suppressMessages({
  library(survival)
  library(ggplot2)
})

df <- readxl::read_excel("/app/user_data/user_5/project_21/data/Figure3.xlsx")

# ---- event indicator + arm ----
df$event <- as.integer(df$CNSR == 0)
df$Arm <- ifelse(grepl("Pyrotinib", df$TRT01P, ignore.case = TRUE), "Pyrotinib", "Placebo")
df$Arm <- factor(df$Arm, levels = c("Pyrotinib", "Placebo"))
df$Arm <- relevel(df$Arm, ref = "Placebo")   # HR = Pyrotinib vs Placebo

subgroups <- list(
  "Age" = "AGEGR1",
  "Hormone receptor status" = "RSFB",
  "HER2 status" = "HER2CAT",
  "Visceral metastasis" = "VISCMNY",
  "Liver metastasis" = "LIVERMNY",
  "Lung metastasis" = "LUNGMNY",
  "Prior adjuvant therapy" = "ADJTRTFL",
  "Time from diagnosis to randomization" = "TFIMCAT",
  "ECOG performance status" = "BLECOG",
  "Prior anti-HER2 therapy" = "RSFA"
)

clean_level <- function(x) {
  x <- as.character(x)
  x[is.na(x) | trimws(x) == ""] <- "Not reported"
  x[x == "Y"] <- "Yes"; x[x == "N"] <- "No"
  x
}

# ---- Cox HR for a subset ----
get_hr <- function(sub) {
  fit <- tryCatch(coxph(Surv(AVAL, event) ~ Arm, data = sub), error = function(e) NULL)
  if (is.null(fit)) {
    return(data.frame(hr = NA_real_, lo = NA_real_, hi = NA_real_,
                      p = NA_real_, n = nrow(sub), events = sum(sub$event)))
  }
  s <- summary(fit)
  i <- grep("^Arm", rownames(s$coefficients))
  if (length(i) == 0) {
    return(data.frame(hr = NA_real_, lo = NA_real_, hi = NA_real_,
                      p = NA_real_, n = nrow(sub), events = sum(sub$event)))
  }
  ci <- suppressMessages(confint(fit))
  data.frame(hr  = as.numeric(exp(coef(fit)[i[1]])),
             lo  = as.numeric(exp(ci[i[1], 1])),
             hi  = as.numeric(exp(ci[i[1], 2])),
             p   = as.numeric(s$coefficients[i[1], "Pr(>|z|)"]),
             n   = nrow(sub),
             events = sum(sub$event))
}

# ---- interaction P via manual likelihood-ratio test ----
get_pint <- function(d, cl) {
  d$v <- cl
  m0 <- tryCatch(coxph(Surv(AVAL, event) ~ Arm + v, data = d), error = function(e) NULL)
  m1 <- tryCatch(coxph(Surv(AVAL, event) ~ Arm * v, data = d), error = function(e) NULL)
  if (is.null(m0) || is.null(m1)) return(NA_real_)
  lr_stat <- -2 * (as.numeric(m0$loglik[2]) - as.numeric(m1$loglik[2]))
  df_diff <- length(coef(m1)) - length(coef(m0))
  if (!is.finite(lr_stat) || df_diff < 1) return(NA_real_)
  as.numeric(pchisq(lr_stat, df_diff, lower.tail = FALSE))
}

# ---- Lancet format helpers (midline decimal, en-dash) ----
fmt_num <- function(x, digits = 2) {
  out <- rep("", length(x))
  ok <- !is.na(x) & is.finite(x)
  out[ok] <- gsub("\\.", "\u00b7", formatC(round(x[ok], digits), format = "f", digits = digits))
  out
}
fmt_ci <- function(est, lo, hi) {
  ifelse(is.na(est), "", paste0(fmt_num(est), " (", fmt_num(lo), "\u2013", fmt_num(hi), ")"))
}
fmt_p <- function(p) {
  ifelse(is.na(p), "",
         ifelse(p < 0.001, "<0\u00b7001",
                ifelse(p < 0.01, fmt_num(p, 3), fmt_num(p, 2))))
}

# ---- build rows ----
L <- list()
add_row <- function(label, n_text, hr, lo, hi, is_header, is_overall, pint) {
  L[[length(L) + 1]] <<- data.frame(
    label = label, n_text = n_text, hr = as.numeric(hr), lo = as.numeric(lo), hi = as.numeric(hi),
    ci_text = fmt_ci(hr, lo, hi),
    is_header = is_header, is_overall = is_overall,
    pint_text = if (is_header) fmt_p(pint) else "",
    stringsAsFactors = FALSE)
}

ov <- get_hr(df)
add_row("Overall", as.character(ov$n), ov$hr, ov$lo, ov$hi, FALSE, TRUE, NA)
cat(sprintf("Overall HR = %.3f (95%% CI %.3f-%.3f), P = %.4f, n = %d, events = %d\n",
            ov$hr, ov$lo, ov$hi, ov$p, ov$n, ov$events))

for (sname in names(subgroups)) {
  var <- subgroups[[sname]]
  cl <- clean_level(df[[var]])
  lvls <- sort(unique(cl))
  if ("Not reported" %in% lvls) lvls <- c(setdiff(lvls, "Not reported"), "Not reported")
  pint <- get_pint(df, cl)
  add_row(sname, "", NA, NA, NA, TRUE, FALSE, pint)
  for (lv in lvls) {
    sub <- df[cl == lv, , drop = FALSE]
    r <- get_hr(sub)
    add_row(paste0("   ", lv), as.character(r$n), r$hr, r$lo, r$hi, FALSE, FALSE, NA)
  }
}

plot_df <- do.call(rbind, L)
plot_df$y <- -seq_len(nrow(plot_df))
plot_df$fontface <- ifelse(plot_df$is_header | plot_df$is_overall, "bold", "plain")

cat(sprintf("\nHR range across rows: %.3f to %.3f; CI range: %.3f to %.3f\n",
            min(plot_df$hr, na.rm = TRUE), max(plot_df$hr, na.rm = TRUE),
            min(plot_df$lo, na.rm = TRUE), max(plot_df$hi, na.rm = TRUE)))

# ---- layout (LINEAR HR scale 0-1.5; compact equal column gaps) ----
# Forest area (0 -> 1.5) is made the dominant width; text columns are packed
# tightly and equally spaced using their real text widths (~11pt Arial).
X_LABEL  <- -1.75     # subgroup names (hjust = 0)
X_N      <- -0.35     # No. of patients (centered)
X_FOR_L  <-  0.0      # HR = 0 (forest axis left end)
X_FOR_R  <-  1.5      # HR = 1.5 (forest axis right end)
X_NULL   <-  1.0      # HR = 1 (null line)
X_HR_C   <-  1.90     # HR (95% CI) numeric column (centered)
X_P      <-  2.52     # P for interaction (centered)
XLIM_L   <- -1.90
XLIM_R   <-  2.85

SZ <- 3.87            # 3.87 mm ~= 11 pt (Arial); all text uses this size

n_rows <- nrow(plot_df)
header_y  <- 0.75
rule_y    <- 0.15
axis_y    <- -(n_rows + 0.55)
tick_y    <- -(n_rows + 0.85)
fav_y     <- -(n_rows + 2.0)

ci_df <- plot_df[!is.na(plot_df$hr), ]

ticks <- c(0, 0.5, 1.0, 1.5)
tick_df <- data.frame(x = ticks,
                      lab = c("0", "0\u00b75", "1\u00b70", "1\u00b75"))

cat(sprintf("Layout: forest physical width ~ %.1f in; total span %.2f units\n",
            1.5 / (XLIM_R - XLIM_L) * 14, XLIM_R - XLIM_L))

p <- ggplot(plot_df, aes(y = y)) +
  # null line (HR = 1) confined to forest rows
  annotate("segment", x = X_NULL, xend = X_NULL, y = -0.6, yend = -(n_rows + 0.25),
           linetype = "dashed", color = "black", linewidth = 0.6) +
  # CI bars + point estimates (linear HR scale)
  geom_segment(data = ci_df,
               aes(x = lo, xend = hi, y = y, yend = y),
               color = "black", linewidth = 0.6) +
  geom_point(data = ci_df, aes(x = hr), shape = 15, size = 3.4, color = "black") +
  # text columns (all 11pt)
  geom_text(aes(x = X_LABEL, label = label, fontface = fontface),
            hjust = 0, size = SZ) +
  geom_text(data = plot_df[!plot_df$is_header, ],
            aes(x = X_N, label = n_text), hjust = 0.5, size = SZ) +
  geom_text(data = plot_df[!plot_df$is_header, ],
            aes(x = X_HR_C, label = ci_text), hjust = 0.5, size = SZ) +
  geom_text(data = plot_df[plot_df$is_header & nzchar(plot_df$pint_text), ],
            aes(x = X_P, label = pint_text), hjust = 0.5, size = SZ) +
  # headers
  annotate("text", x = X_LABEL, y = header_y, label = "Subgroup",
           hjust = 0, fontface = "bold", size = SZ) +
  annotate("text", x = X_N, y = header_y, label = "No. of patients",
           hjust = 0.5, fontface = "bold", size = SZ) +
  annotate("text", x = (X_FOR_L + X_FOR_R) / 2, y = header_y,
           label = "Hazard ratio (95% CI)", hjust = 0.5, fontface = "bold", size = SZ) +
  annotate("text", x = X_HR_C, y = header_y, label = "HR (95% CI)",
           hjust = 0.5, fontface = "bold", size = SZ) +
  annotate("text", x = X_P, y = header_y, label = "P for interaction",
           hjust = 0.5, fontface = "bold", size = SZ) +
  # header rule
  annotate("segment", x = X_LABEL, xend = X_P + 0.25, y = rule_y, yend = rule_y,
           color = "black", linewidth = 0.5) +
  # forest axis (linear 0 to 1.5)
  annotate("segment", x = X_FOR_L, xend = X_FOR_R, y = axis_y, yend = axis_y,
           color = "black", linewidth = 0.5) +
  geom_segment(data = tick_df, aes(x = x, xend = x, y = axis_y, yend = axis_y - 0.12),
               color = "black", linewidth = 0.4) +
  geom_text(data = tick_df, aes(x = x, y = tick_y, label = lab),
            size = SZ, vjust = 1) +
  # favours labels anchored on opposite sides of the null line (no overlap)
  annotate("text", x = X_NULL - 0.10, y = fav_y,
           label = "\u2190  Favours Pyrotinib", size = SZ, color = "grey30", hjust = 1) +
  annotate("text", x = X_NULL + 0.10, y = fav_y,
           label = "Favours Placebo  \u2192", size = SZ, color = "grey30", hjust = 0) +
  coord_cartesian(xlim = c(XLIM_L, XLIM_R),
                  ylim = c(-(n_rows + 2.5), 1.5), clip = "off") +
  theme_void(base_family = "Arial") +
  theme(plot.background = element_rect(fill = "white", color = NA),
        panel.background = element_rect(fill = "white", color = NA))

figure_width  <- 14
figure_height <- 1.8 + n_rows * 0.28
figure_dpi    <- 300

final_plot <- p
print(final_plot)
