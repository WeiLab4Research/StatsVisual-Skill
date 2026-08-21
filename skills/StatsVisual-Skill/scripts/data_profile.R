#!/usr/bin/env Rscript

# data_profile.R — 数据画像脚本（只输出 stdout，不产生任何文件）
#
# 用法:
#   Rscript data_profile.R <data_file>
#
# 功能:
#   读取 CSV/TSV/RDS/Excel，分析数据结构、类型、缺失、分布、宽表、
#   双变量关系等，并将 Markdown 数据画像打印到标准输出（stdout）。
#   本脚本不写入任何文件，结果仅供上层流程（如绘图 agent）捕获后拼入提示词。
#
# 依赖: 仅 base R；读取 Excel 需要 readxl（未安装时给出明确报错）。

# ---- 定位 skill 目录并接入专属 R 库（与项目其他脚本一致）----
# 用脚本自身路径反推 skill_dir（而非 getwd()，避免调用目录不确定导致库路径错乱）。
script_arg <- commandArgs(trailingOnly = FALSE)
file_hit <- grep("^--file=", script_arg, value = TRUE)
if (length(file_hit) > 0) {
  script_path <- sub("^--file=", "", file_hit[[1]])
  skill_dir <- normalizePath(file.path(dirname(script_path), ".."), winslash = "/")
  setup_r_library <- file.path(skill_dir, "scripts", "setup_r_library.R")
  if (file.exists(setup_r_library)) {
    source(setup_r_library)
    invisible(suppressWarnings(rmg_prepare_library(skill_dir = skill_dir)))
  }
}

args <- commandArgs(trailingOnly = TRUE)
if (length(args) < 1) {
  stop("Usage: Rscript data_profile.R <data_file>", call. = FALSE)
}
data_file <- args[[1]]

if (!file.exists(data_file)) {
  stop("数据文件不存在: ", data_file, call. = FALSE)
}

# ---- 读取数据 ----
read_data <- function(path) {
  ext <- tolower(tools::file_ext(path))
  if (ext %in% c("csv", "txt")) {
    utils::read.csv(path, stringsAsFactors = FALSE, check.names = FALSE)
  } else if (ext == "tsv") {
    utils::read.delim(path, stringsAsFactors = FALSE, check.names = FALSE)
  } else if (ext == "rds") {
    readRDS(path)
  } else if (ext %in% c("xlsx", "xls")) {
    if (!requireNamespace("readxl", quietly = TRUE)) {
      stop("读取 Excel 需要安装 'readxl' 包。", call. = FALSE)
    }
    readxl::read_excel(path)
  } else {
    stop("不支持的数据格式: ", ext, call. = FALSE)
  }
}

data <- as.data.frame(read_data(data_file), check.names = FALSE)

# ---- 列角色分类（对齐 files.py 的 _column_role）----
classify_col <- function(x, name, row_count) {
  non_missing <- x[!is.na(x)]
  unique_n <- length(unique(non_missing))
  lower_name <- tolower(name)

  if (unique_n <= 1) {
    return("constant")
  }
  id_names <- c("id", "patient_id", "subject_id", "sample_id", "record_id")
  if (lower_name %in% id_names || grepl("_id$", lower_name)) {
    return("possible_identifier/high_cardinality")
  }
  if (inherits(x, c("Date", "POSIXct", "POSIXlt")) ||
      grepl("date|time|year|month|day", lower_name)) {
    return("datetime")
  }
  if (is.logical(x)) {
    return("binary")
  }
  if (is.numeric(x) || is.integer(x)) {
    return("numeric")
  }
  if (row_count >= 20 && unique_n / max(length(non_missing), 1) >= 0.98) {
    return("possible_identifier/high_cardinality")
  }
  if (unique_n <= 50) {
    return("categorical")
  }
  "text/high_cardinality"
}

# ---- 工具函数 ----
safe_cell <- function(value, max_length = 120) {
  vapply(value, function(v) {
    if (length(v) == 0 || is.na(v)) return("")
    text <- gsub("\\|", "\\\\|", as.character(v))
    text <- gsub("\n", " ", text)
    text <- gsub("\r", " ", text)
    if (nchar(text) > max_length) {
      text <- paste0(substr(text, 1, max_length), "...")
    }
    text
  }, character(1), USE.NAMES = FALSE)
}

df_to_md <- function(df) {
  cols <- colnames(df)
  header <- paste0("| ", paste(cols, collapse = " | "), " |")
  sep <- paste0("| ", paste(rep("---", length(cols)), collapse = " | "), " |")
  rows <- character()
  for (i in seq_len(nrow(df))) {
    cells <- vapply(df[i, , drop = FALSE], function(v) {
      s <- if (is.na(v)) "" else as.character(v)
      gsub("\n", " ", s)
    }, character(1))
    rows <- c(rows, paste0("| ", paste(cells, collapse = " | "), " |"))
  }
  c(header, sep, rows)
}

# ---- 常量 ----
PROFILE_TOP_VALUES <- 5
PROFILE_SAMPLE_ROWS <- 5

row_count <- nrow(data)
col_count <- ncol(data)

roles <- vapply(names(data), function(nm) classify_col(data[[nm]], nm, row_count), character(1))
names(roles) <- names(data)

missing_cnt <- vapply(data, function(x) sum(is.na(x)), integer(1))
nonnull_cnt <- vapply(data, function(x) sum(!is.na(x)), integer(1))
unique_n    <- vapply(data, function(x) length(unique(x[!is.na(x)])), integer(1))
missing_pct <- if (row_count > 0) missing_cnt / row_count * 100 else rep(0, length(missing_cnt))

# ---- 组装输出行 ----
lines <- character()

# 文件头
ext <- tolower(tools::file_ext(data_file))
file_type <- if (ext %in% c("xlsx", "xls")) "Excel File" else if (ext == "rds") "RDS File" else "CSV File"
lines <- c(lines,
  paste0(file_type, " (", row_count, " rows x ", col_count, " columns)"),
  "Profile scope: all rows were read and analyzed locally; raw rows are not copied into the model context.",
  "")

# 数据质量
dup_rows <- sum(duplicated(data))
empty_cols <- names(data)[vapply(data, function(x) all(is.na(x)), logical(1))]
constant_cols <- names(data)[roles == "constant"]
id_cols <- names(data)[grepl("identifier", roles)]

lines <- c(lines,
  "## Data quality",
  paste0("- Duplicate rows: ", dup_rows),
  paste0("- Total missing cells: ", sum(missing_cnt)),
  paste0("- Completely empty columns: ", length(empty_cols)),
  paste0("- Constant columns: ", length(constant_cols)),
  paste0("- Possible identifier/high-cardinality columns: ",
         if (length(id_cols) > 0) paste0("`", id_cols, "`", collapse = ", ") else "none"),
  "")

# 列概览
lines <- c(lines,
  "## Columns",
  "| column | dtype | role | non-null | missing | missing % | unique |",
  "| --- | --- | --- | ---: | ---: | ---: | ---: |")

for (nm in names(data)) {
  x <- data[[nm]]
  dtype <- if (is.numeric(x)) "numeric" else if (is.integer(x)) "integer" else
           if (is.logical(x)) "logical" else if (inherits(x, c("Date", "POSIXct", "POSIXlt"))) "datetime" else "character"
  lines <- c(lines, sprintf("| `%s` | %s | %s | %d | %d | %.2f%% | %d |",
    safe_cell(nm), dtype, roles[[nm]], nonnull_cnt[[nm]], missing_cnt[[nm]],
    missing_pct[[nm]], unique_n[[nm]]))
}

# 数值摘要
num_cols <- names(data)[roles == "numeric"]
if (length(num_cols) > 0) {
  lines <- c(lines, "",
    "## Numeric summary (computed from all non-missing values)",
    "| column | count | mean | std | min | 25% | median | 75% | max |",
    "| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |")
  for (nm in num_cols) {
    x <- data[[nm]]
    x <- x[!is.na(x)]
    q <- quantile(x, probs = c(0.25, 0.5, 0.75), na.rm = TRUE)
    lines <- c(lines, sprintf("| `%s` | %d | %.6g | %.6g | %.6g | %.6g | %.6g | %.6g | %.6g |",
      safe_cell(nm), length(x), mean(x), sd(x), min(x), q[1], q[2], q[3], max(x)))
  }
}

# 分类分布
cat_cols <- names(data)[roles %in% c("binary", "categorical")]
if (length(cat_cols) > 0) {
  lines <- c(lines, "",
    "## Categorical distributions (top values; counts use all rows)")
  for (nm in cat_cols) {
    x <- data[[nm]]
    tb <- sort(table(x, useNA = "ifany"), decreasing = TRUE)
    top <- head(tb, PROFILE_TOP_VALUES)
    vals <- paste0(safe_cell(names(top), 80), ": ", as.integer(top), collapse = "; ")
    lines <- c(lines, paste0("- **", safe_cell(nm), "**: ", vals))
  }
}

# 宽表检测（值类列名 + 重复测量分组）
VALUE_LIKE_NAMES <- c(
  "male", "female", "man", "woman", "boy", "girl",
  "yes", "no", "true", "false",
  "control", "treatment", "placebo", "experimental",
  "baseline", "followup", "endpoint", "screening",
  "before", "after", "pre", "post",
  "intervention", "standard", "usual_care",
  "case", "exposed", "unexposed",
  "normal", "abnormal", "positive", "negative",
  "mild", "moderate", "severe",
  "admission", "discharge",
  "week1", "week2", "week4", "week8", "week12",
  "month1", "month3", "month6", "month12",
  "day1", "day3", "day7", "day14", "day30",
  "time1", "time2", "time3", "time4",
  "visit1", "visit2", "visit3", "visit4"
)

wide_by_value <- names(data)[tolower(names(data)) %in% VALUE_LIKE_NAMES]

grouped_pattern <- function(nm) {
  m <- regmatches(nm, regexec("^(.+?)[_-]([^_-]+)$", nm))[[1]]
  if (length(m) == 3 && !grepl("^[0-9]+$", m[3])) m else NULL
}
numbered_pattern <- function(nm) {
  m <- regmatches(nm, regexec("^(.+?)[_-]?[0-9]+$", nm))[[1]]
  if (length(m) == 2 && m[2] != "") m else NULL
}

wide_by_group <- list()
for (nm in names(data)) {
  g <- grouped_pattern(nm)
  if (!is.null(g) && g[2] != "" && g[3] != "") {
    wide_by_group[[g[2]]] <- c(wide_by_group[[g[2]]], nm)
    next
  }
  n <- numbered_pattern(nm)
  if (!is.null(n) && n[2] != "") {
    wide_by_group[[n[2]]] <- c(wide_by_group[[n[2]]], nm)
  }
}

if (length(wide_by_value) > 0 || length(wide_by_group) > 0) {
  lines <- c(lines, "",
    "## Wide-format detection",
    "These columns appear to be values (not variable names). Convert to long format with `pivot_longer()` before plotting.")
  if (length(wide_by_value) > 0) {
    lines <- c(lines, paste0("- **Immediate value-like columns**: ", paste0("`", wide_by_value, "`", collapse = ", "),
      " — these look like categories of a grouping variable."))
  }
  for (prefix in names(wide_by_group)) {
    if (length(wide_by_group[[prefix]]) >= 2) {
      lines <- c(lines, paste0("- **Repeated-measure group '", prefix, "'**: ",
        paste0("`", wide_by_group[[prefix]], "`", collapse = ", "),
        " — consider `pivot_longer(cols = starts_with('", prefix, "'), names_to = 'time', values_to = '", prefix, "')`."))
    }
  }
}

# 双变量关系
cat_cols_binary <- names(data)[roles %in% c("binary", "categorical") & unique_n <= 10]
num_cols_biv <- num_cols

biv_lines <- character()
if (length(cat_cols_binary) >= 2) {
  biv_lines <- c(biv_lines, "### Categorical × Categorical (cross-tabulation)")
  for (i in seq_len(min(length(cat_cols_binary), 4))) {
    for (j in seq_len(min(length(cat_cols_binary), 4))) {
      if (j <= i) next
      ct <- table(data[[cat_cols_binary[i]]], data[[cat_cols_binary[j]]], useNA = "ifany")
      if (nrow(ct) <= 10 && ncol(ct) <= 10) {
        biv_lines <- c(biv_lines, "",
          paste0("**", cat_cols_binary[i], " × ", cat_cols_binary[j], "** (", nrow(ct), " × ", ncol(ct), "):"))
        ct_df <- as.data.frame.matrix(ct)
        ct_df <- cbind(data.frame(row = rownames(ct_df), stringsAsFactors = FALSE), ct_df)
        biv_lines <- c(biv_lines, df_to_md(ct_df))
      }
    }
  }
}
if (length(cat_cols_binary) > 0 && length(num_cols_biv) > 0) {
  biv_lines <- c(biv_lines, "", "### Categorical × Numeric (grouped mean ± SD)")
  for (cat in head(cat_cols_binary, 4)) {
    for (num in head(num_cols_biv, 3)) {
      grouped <- tapply(data[[num]], data[[cat]], function(x) {
        x <- x[!is.na(x)]
        sprintf("%.2f ± %.2f (n=%d)", mean(x), sd(x), length(x))
      })
      grouped <- head(grouped, 10)
      parts <- paste0(safe_cell(names(grouped)), ": ", grouped, collapse = " | ")
      biv_lines <- c(biv_lines, paste0("**", num, " by ", cat, "**: ", parts))
    }
  }
}
if (length(biv_lines) > 2) {
  lines <- c(lines, "", "## Bivariate relationships", biv_lines)
}

# 格式样本
sample_df <- head(data, PROFILE_SAMPLE_ROWS)
for (nm in names(sample_df)) {
  if (grepl("identifier", roles[[nm]])) {
    sample_df[[nm]] <- "[omitted identifier]"
  } else {
    sample_df[[nm]] <- vapply(sample_df[[nm]], safe_cell, character(1))
  }
}
lines <- c(lines, "",
  paste0("## Format sample (first ", min(PROFILE_SAMPLE_ROWS, row_count), " rows; identifiers omitted)"),
  df_to_md(sample_df))

# ---- 输出到 stdout（不产生任何文件）----
cat(paste(lines, collapse = "\n"), "\n")
