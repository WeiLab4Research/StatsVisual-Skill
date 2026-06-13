#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly = TRUE)
if (length(args) < 1) {
  stop("Usage: Rscript inspect_data_for_charts.R <data_file> <output_md>", call. = FALSE)
}

if (length(args) < 2) {
  stop("A project-local output path is required, for example <project_dir>/output/data_profile.md.", call. = FALSE)
}

data_file <- args[[1]]
output_md <- args[[2]]

read_data <- function(path) {
  ext <- tolower(tools::file_ext(path))
  if (ext %in% c("csv", "txt")) {
    utils::read.csv(path, stringsAsFactors = FALSE, check.names = FALSE)
  } else if (ext %in% c("tsv")) {
    utils::read.delim(path, stringsAsFactors = FALSE, check.names = FALSE)
  } else if (ext == "rds") {
    readRDS(path)
  } else if (ext %in% c("xlsx", "xls")) {
    if (!requireNamespace("readxl", quietly = TRUE)) {
      stop("Package 'readxl' is required to inspect Excel files.", call. = FALSE)
    }
    readxl::read_excel(path)
  } else {
    stop("Unsupported data format: ", ext, call. = FALSE)
  }
}

classify_col <- function(x, name) {
  non_missing <- x[!is.na(x)]
  unique_n <- length(unique(non_missing))
  lower_name <- tolower(name)
  if (inherits(x, c("Date", "POSIXct", "POSIXlt")) || grepl("date|time|year|month|day", lower_name)) {
    return("time/date")
  }
  if (is.numeric(x) || is.integer(x)) {
    if (unique_n <= 10) return("numeric categorical")
    return("continuous")
  }
  if (is.logical(x)) return("binary")
  if (unique_n <= 20) return("categorical")
  "text/id"
}

data <- as.data.frame(read_data(data_file))
dir.create(dirname(output_md), showWarnings = FALSE, recursive = TRUE)

types <- vapply(names(data), function(nm) classify_col(data[[nm]], nm), character(1))
missing_pct <- vapply(data, function(x) mean(is.na(x)) * 100, numeric(1))
unique_n <- vapply(data, function(x) length(unique(x[!is.na(x)])), integer(1))

continuous <- names(types)[types == "continuous"]
categorical <- names(types)[types %in% c("categorical", "binary", "numeric categorical")]
time_cols <- names(types)[types == "time/date"]
event_cols <- names(data)[grepl("event|status|death|censor|outcome", tolower(names(data)))]

suggestions <- character()
choice_menu <- character()
book_basis <- character()
multi_panel_notes <- character()
add_choice <- function(title, book, why, best_for, style, limits) {
  c(
    paste0("### ", title),
    "",
    paste0("- Book basis: ", book),
    paste0("- Why it fits: ", why),
    paste0("- Best for: ", best_for),
    paste0("- Style promise: ", style),
    paste0("- Limitation: ", limits),
    "- Expected outputs: PDF, SVG, 700 dpi TIFF, web PNG under 1 MB",
    ""
  )
}
if (all(c("b", "se", "pval") %in% names(data)) && any(grepl("method", names(data), ignore.case = TRUE))) {
  suggestions <- c(suggestions, "MR forest plot or method-sensitivity plot")
  book_basis <- c(book_basis, "Book-derived families: forest/coefficient plot and volcano-style screening; see `chart-index.md`, `forest-plot.md`, and `scatter-plot.md`.")
  choice_menu <- c(
    choice_menu,
    add_choice(
      "Recommended: MR forest plot with 95% CI",
      "`forest-plot.md` effect-size/CI family",
      "`b` and `se` provide effect size and uncertainty; `exposure` provides row labels.",
      "primary MR results and manuscript figures.",
      "white background, clear CI intervals, reference line, restrained highlight colors.",
      "shows estimate uncertainty; does not by itself prove biological mechanism."
    ),
    add_choice(
      "Method-sensitivity plot",
      "`forest-plot.md` effect-size/CI family with method comparison",
      "`method`, `b`, and `se/pval` allow comparison across MR estimators.",
      "robustness/sensitivity panels.",
      "gray context points plus highlighted summary, compact legend.",
      "method disagreement should be interpreted with MR assumptions, not as a visual vote."
    ),
    add_choice(
      "Volcano-style MR result plot",
      "`scatter-plot.md` effect-size/P-value screening family",
      "`b` is the signed effect axis and `pval` maps to `-log10(P)`.",
      "screening many exposures for large-effect/small-P candidates.",
      "gray background points, red/blue highlighted candidates, threshold lines with labels, sparse `ggrepel` labels.",
      "a volcano plot is for screening and display; it is not standalone causal evidence."
    )
  )
  multi_panel_notes <- c(
    multi_panel_notes,
    "Optional multi-panel figure: Main message: MR effects are supported by estimate size, method robustness, and screening context. Panels: A: MR forest plot with 95% CI; B: method-sensitivity plot; C: volcano-style screening plot. Support logic: primary estimate plus robustness plus high-throughput context. Use when: reporting primary MR results. Limitation: MR assumptions and heterogeneity still need textual/statistical support."
  )
}
if (length(continuous) >= 2) {
  suggestions <- c(suggestions, "Scatter plot with optional regression or smooth curve")
  book_basis <- c(book_basis, "Book-derived family: scatter/association chart; see `chart-index.md` and `scatter-plot.md`.")
  choice_menu <- c(choice_menu, add_choice(
    "Scatter plot with regression/smooth",
    "`scatter-plot.md` scatter/association family",
    "two or more continuous variables can show association or dose-response.",
    "biomarker relationships and model trend display.",
    "transparent points for density, fitted line only when it answers the question.",
    "association plots do not establish causality without study design/model support."
  ))
  if (length(categorical) >= 1) {
    multi_panel_notes <- c(
      multi_panel_notes,
      "Optional multi-panel figure: Main message: the association is interpretable alongside group distributions. Panels: A: grouped distribution for the key continuous outcome; B: scatter/regression or smooth curve; C: effect-size or subgroup summary if a research grouping variable is selected. Support logic: distribution plus association plus subgroup/effect context. Use when: both comparison and association matter. Limitation: causal interpretation depends on study design/model support."
    )
  } else {
    multi_panel_notes <- c(
      multi_panel_notes,
      "Optional multi-panel figure: Main message: the continuous association remains interpretable after checking distribution/model context. Panels: A: scatter/regression plot; B: residual or distribution check; C: density or marginal distribution panel. Support logic: relationship plus assumption context. Use when: model fit or nonlinearity may be questioned. Limitation: this needs a chosen model or smoothing rule."
    )
  }
}
if (length(continuous) >= 1 && length(categorical) >= 1) {
  suggestions <- c(suggestions, "Boxplot/violin with jittered points by group")
  book_basis <- c(book_basis, "Book-derived family: distribution chart; see `chart-index.md`, `box-plot.md`, and `histogram.md`.")
  choice_menu <- c(choice_menu, add_choice(
    "Boxplot or violin plot with jittered points",
    "`box-plot.md` grouped distribution family",
    "a continuous outcome and categorical group can show spread, skewness, and outliers.",
    "continuous outcomes by group.",
    "show raw points when readable; use median/IQR or density shape instead of summary-only bars.",
    "do not hide sample size or distribution behind a mean-only bar."
  ))
  multi_panel_notes <- c(
    multi_panel_notes,
    "Optional multi-panel figure: Main message: groups differ in both observed distribution and estimated effect size. Panels: A: box/violin plot with raw points; B: mean/median difference or model-adjusted effect with confidence interval; C: subgroup or sensitivity panel if another grouping variable is meaningful. Support logic: raw distribution plus manuscript-ready effect estimate. Use when: the paper needs both visual distribution and inferential summary. Limitation: CI/test/model definition must be chosen."
  )
}
if (length(categorical) >= 2) {
  suggestions <- c(suggestions, "Grouped or stacked bar chart for counts/proportions")
  book_basis <- c(book_basis, "Book-derived family: bar chart; see `chart-index.md` and `bar-chart.md`.")
  choice_menu <- c(choice_menu, add_choice(
    "Grouped or stacked bar chart",
    "`bar-chart.md` bar chart family",
    "two categorical variables can show counts, rates, or composition.",
    "categorical comparisons.",
    "label denominators or percentages; keep grouping limited.",
    "bars are for summarized categorical quantities, not raw continuous distributions."
  ))
  multi_panel_notes <- c(
    multi_panel_notes,
    "Optional multi-panel figure: Main message: categorical differences are supported by counts, denominators, and subgroup/composition context. Panels: A: counts or proportions by group; B: denominator-aware percentage summary; C: subgroup or composition panel when categories have a meaningful hierarchy. Support logic: absolute counts plus normalized rates plus subgroup structure. Use when: rates could be misleading without denominators. Limitation: small cells may require collapsing or exact methods."
  )
}
if (length(time_cols) >= 1 && length(continuous) >= 1) {
  suggestions <- c(suggestions, "Line chart or step chart over time")
  book_basis <- c(book_basis, "Book-derived family: line/time-series chart; see `chart-index.md` and `line-chart.md`.")
  choice_menu <- c(choice_menu, add_choice(
    "Line or step chart",
    "`line-chart.md` line/time-series family",
    "time/date and numeric values can show ordered change.",
    "time series or longitudinal summaries.",
    "use points for sparse observations and steps for discrete jumps.",
    "do not imply continuity when measurement times are sparse or irregular."
  ))
  multi_panel_notes <- c(
    multi_panel_notes,
    "Optional multi-panel figure: Main message: longitudinal change is supported by trend and endpoint/effect evidence. Panels: A: longitudinal trend; B: group difference or model-estimated effect; C: response, safety, or distribution summary at a clinically important time point. Support logic: trajectory plus effect estimate plus clinical endpoint context. Use when: time course and endpoint evidence both matter. Limitation: repeated-measure structure and irregular timing must be handled explicitly."
  )
}
if (length(time_cols) >= 1 && length(event_cols) >= 1) {
  suggestions <- c(suggestions, "Kaplan-Meier or cumulative hazard curve if time-to-event assumptions hold")
  book_basis <- c(book_basis, "Book-derived family: survival graphics; see `chart-index.md` and `survival-curve.md`.")
  choice_menu <- c(choice_menu, add_choice(
    "Kaplan-Meier or cumulative hazard curve",
    "`survival-curve.md` survival family",
    "time and event/status columns suggest a time-to-event structure.",
    "survival analysis with censoring.",
    "clear time units, event definition, compact strata, risk table when useful.",
    "event coding must be verified before plotting; late tails with few at risk should not be overread."
  ))
  multi_panel_notes <- c(
    multi_panel_notes,
    "Optional multi-panel figure: Main message: survival differences are supported by time-to-event curves, risk-set context, and adjusted effects. Panels: A: Kaplan-Meier or cumulative hazard curve; B: number-at-risk table or compact risk summary; C: Cox forest plot or adjusted effect estimate after event coding is verified. Support logic: survival pattern plus risk-set transparency plus adjusted estimate. Use when: survival curve alone is not enough for the manuscript. Limitation: event/censor coding and Cox covariates must be verified."
  )
}
if (length(continuous) >= 5 && nrow(data) >= 3) {
  suggestions <- c(suggestions, "Heatmap or correlation heatmap for selected numeric variables")
  book_basis <- c(book_basis, "Book-derived family: heatmap; see `chart-index.md` and `heatmap.md`.")
  choice_menu <- c(choice_menu, add_choice(
    "Heatmap or correlation heatmap",
    "`heatmap.md` matrix-summary family",
    "many numeric variables can be summarized as a matrix or correlation structure.",
    "biomarker panels, feature patterns, or correlation exploration.",
    "declare scaling, clustering, color midpoint, and annotation choices.",
    "cluster/color patterns are exploratory and depend on transformation/scaling choices."
  ))
  multi_panel_notes <- c(
    multi_panel_notes,
    "Optional multi-panel figure: Main message: high-dimensional patterns are supported by focused feature-level validation. Panels: A: heatmap or correlation heatmap; B: highlighted-feature distribution or scatter plot; C: validation or model-adjusted effect panel for selected features. Support logic: overview pattern plus selected-feature evidence plus validation/model context. Use when: a heatmap alone would be too exploratory. Limitation: scaling, clustering, and feature-selection rules must be declared."
  )
}
if (length(suggestions) == 0) {
  suggestions <- "Need research question or clearer variable roles before recommending a chart"
  book_basis <- "No book-derived family matched confidently yet."
  choice_menu <- "- **Need clarification**: I need the outcome, grouping variable, or research question before recommending a chart."
  multi_panel_notes <- "Multi-panel not recommended: I need the outcome, grouping variable, or research question before deciding whether panels would add complementary support."
}
choice_menu <- unique(choice_menu)
heads <- grep("^### ", choice_menu)
if (length(heads) > 3) {
  keep_start <- heads[1:3]
  keep_end <- heads[2:4] - 1
  keep <- unlist(Map(seq, keep_start, keep_end))
  choice_menu <- choice_menu[keep]
}
multi_panel_notes <- unique(multi_panel_notes)
if (length(multi_panel_notes) > 3) {
  multi_panel_notes <- multi_panel_notes[seq_len(3)]
}

lines <- c(
  "# Data Profile",
  "",
  paste0("- File: `", normalizePath(data_file, winslash = "/", mustWork = FALSE), "`"),
  paste0("- Rows: ", nrow(data)),
  paste0("- Columns: ", ncol(data)),
  "",
  "## Columns",
  "",
  "| Column | Type | Missing % | Unique values |",
  "| --- | --- | ---: | ---: |"
)

for (nm in names(data)) {
  lines <- c(lines, sprintf("| `%s` | %s | %.1f | %s |", nm, types[[nm]], missing_pct[[nm]], unique_n[[nm]]))
}

lines <- c(
  lines,
  "",
  "## Candidate Charts",
  "",
  paste0("- ", unique(suggestions)),
  "",
  "## Book Basis",
  "",
  paste0("- ", unique(book_basis)),
  "",
  "## Multi-panel Option",
  "",
  paste0("- ", multi_panel_notes),
  "",
  "## Chart Choice Menu",
  "",
  choice_menu,
  "",
  "## Style Options",
  "",
  "- 通用风格 general（默认）：来源于《统计图形艺术》的医学统计绘图规则。",
  "- Nature 风格 nature：适合 Nature-family / 高影响力期刊图，强调证据层级、低饱和统一色系、可编辑 SVG 和紧凑多面板布局。",
  "- Lancet 风格 lancet：适合 The Lancet / 临床流行病学图，强调强可读性、可编辑矢量图、实线对比编码、临床表格与效应量对齐。",
  "- NEJM 风格 nejm：适合 NEJM 临床试验/肿瘤/生存曲线与表格式森林图，强调白底、粗黑坐标轴、直接标注、风险表和浅灰表格行带。",
  "",
  "请选择：图表方案 + 风格。",
  "如果只选择图表，我将默认使用通用风格。",
  "",
  "## Stop Here",
  "",
  "Ask the user to choose one single-figure option or the multi-panel option, and ask for a style choice, before writing plotting code. General requests such as 'plot my data', 'draw figures', 'visualize it', '帮我画图', '给我的数据画图', '直接画', or '自动选择' do not authorize skipping this recommendation stage.",
  "",
  "Do not write or copy R plotting scripts, install plotting packages, export figures, validate figures, or choose a figure automatically until the user replies with a concrete chart choice. If the user chooses a chart but omits style, use `general`."
)

writeLines(lines, output_md)
cat(paste(lines, collapse = "\n"), "\n")
