## 桑基图 | Sanky Plot
input <- "E:/桌面/测试数据/fig5_sankey_source_target_value.csv"
output_dir <- "E:/桌面/测试数据/测试结果"
output <- file.path(output_dir, "fig5_sankey_300dpi_R_Arial.png")

links <- read.csv(input, stringsAsFactors = FALSE, fileEncoding = "UTF-8-BOM")
links$value <- as.numeric(links$value)

nodes <- sort(unique(c(links$source, links$target)))
incoming <- split(links$source, links$target)
outgoing <- split(links$target, links$source)
roots <- setdiff(nodes, names(incoming))

layer <- setNames(rep(NA_integer_, length(nodes)), nodes)
layer[roots] <- 0L
queue <- roots
while (length(queue) > 0) {
  node <- queue[1]
  queue <- queue[-1]
  for (target in outgoing[[node]]) {
    next_layer <- layer[[node]] + 1L
    if (is.na(layer[[target]]) || next_layer > layer[[target]]) {
      layer[[target]] <- next_layer
      queue <- c(queue, target)
    }
  }
}

in_total <- tapply(links$value, links$target, sum)
out_total <- tapply(links$value, links$source, sum)
node_value <- setNames(numeric(length(nodes)), nodes)
for (node in nodes) {
  in_value <- if (node %in% names(in_total)) in_total[[node]] else 0
  out_value <- if (node %in% names(out_total)) out_total[[node]] else 0
  node_value[[node]] <- max(in_value, out_value)
}

preferred <- list(
  c("Mothers", "Neonates"),
  c("Citrobacter sp", "Enterobacter sp", "Escherichia sp", "Klebsiella sp", "Other Enterobacterales"),
  c("CTX-M-14", "CTX-M-15", "CTX-M-24", "CTX-M-27", "CTX-M-55", "Other genes", "SHV-2a"),
  c("Cambodia", "Madagascar")
)

layer_ids <- sort(unique(layer))
max_layer_total <- max(vapply(layer_ids, function(l) sum(node_value[layer == l]), numeric(1)))
gap <- max_layer_total * 0.045
layer_block_height <- vapply(layer_ids, function(l) {
  layer_nodes <- nodes[layer == l]
  sum(node_value[layer_nodes]) + gap * (length(layer_nodes) - 1)
}, numeric(1))
y_extent <- max(layer_block_height) + gap * 10
global_center <- y_extent / 2

pos <- data.frame(node = nodes, layer = as.integer(layer[nodes]), value = node_value[nodes],
                  y0 = NA_real_, y1 = NA_real_, stringsAsFactors = FALSE)

for (l in layer_ids) {
  layer_nodes <- nodes[layer == l]
  order_ref <- preferred[[l + 1]]
  layer_nodes <- layer_nodes[order(match(layer_nodes, order_ref), layer_nodes, na.last = TRUE)]
  total <- sum(node_value[layer_nodes])
  block_height <- total + gap * (length(layer_nodes) - 1)
  y <- global_center - block_height / 2
  for (node in layer_nodes) {
    idx <- match(node, pos$node)
    pos$y0[idx] <- y
    pos$y1[idx] <- y + node_value[[node]]
    y <- y + node_value[[node]] + gap
  }
}

palette <- c(
  "Mothers" = "#4C78A8", "Neonates" = "#F58518",
  "Citrobacter sp" = "#54A24B", "Enterobacter sp" = "#E45756",
  "Escherichia sp" = "#72B7B2", "Klebsiella sp" = "#B279A2",
  "Other Enterobacterales" = "#9D755D", "CTX-M-14" = "#59A14F",
  "CTX-M-15" = "#EDC948", "CTX-M-24" = "#FF9DA7",
  "CTX-M-27" = "#76B7B2", "CTX-M-55" = "#AF7AA1",
  "Other genes" = "#BAB0AC", "SHV-2a" = "#E15759",
  "Cambodia" = "#2F4B7C", "Madagascar" = "#A05195"
)

alpha_col <- function(col, alpha = 0.42) {
  rgb_col <- grDevices::col2rgb(col) / 255
  grDevices::rgb(rgb_col[1], rgb_col[2], rgb_col[3], alpha = alpha)
}

draw_ribbon <- function(x0, x1, y0a, y0b, y1a, y1b, col) {
  dx <- (x1 - x0) * 0.52
  top <- graphics::xspline(c(x0, x0 + dx, x1 - dx, x1),
                           c(y0a, y0a, y1a, y1a), shape = 1, draw = FALSE)
  bottom <- graphics::xspline(c(x1, x1 - dx, x0 + dx, x0),
                              c(y1b, y1b, y0b, y0b), shape = 1, draw = FALSE)
  polygon(c(top$x, bottom$x), c(top$y, bottom$y), col = alpha_col(col), border = NA)
}

dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
png(output, width = 3600, height = 2400, res = 300, type = "cairo", family = "Arial")
par(mar = c(2.8, 4.1, 1.1, 4.1), xaxs = "i", yaxs = "i", family = "Arial")
plot.new()
plot.window(xlim = c(-0.10, 1.10), ylim = c(y_extent, -y_extent * 0.17))

x_by_layer <- setNames(seq(0, 1, length.out = length(layer_ids)), layer_ids)
node_w <- 0.032
source_offset <- setNames(numeric(length(nodes)), nodes)
target_offset <- setNames(numeric(length(nodes)), nodes)

for (i in seq_len(nrow(links))) {
  source <- links$source[i]
  target <- links$target[i]
  value <- links$value[i]
  s <- pos[pos$node == source, ]
  t <- pos[pos$node == target, ]
  x0 <- x_by_layer[as.character(s$layer)] + node_w / 2
  x1 <- x_by_layer[as.character(t$layer)] - node_w / 2
  sy0 <- s$y0 + source_offset[[source]]
  sy1 <- sy0 + value
  ty0 <- t$y0 + target_offset[[target]]
  ty1 <- ty0 + value
  draw_ribbon(x0, x1, sy0, sy1, ty0, ty1, palette[[source]])
  source_offset[[source]] <- source_offset[[source]] + value
  target_offset[[target]] <- target_offset[[target]] + value
}

for (i in seq_len(nrow(pos))) {
  node <- pos$node[i]
  x <- x_by_layer[as.character(pos$layer[i])] - node_w / 2
  rect(x, pos$y0[i], x + node_w, pos$y1[i], col = palette[[node]], border = "white", lwd = 0.7)
  if (pos$layer[i] == max(layer_ids)) {
    text_x <- x - 0.014
    adj <- 1
  } else {
    text_x <- x + node_w + 0.014
    adj <- 0
  }
  label <- paste0(node, "\n", round(pos$value[i]))
  text(text_x, mean(c(pos$y0[i], pos$y1[i])), label, adj = c(adj, 0.5),
       cex = 0.82, col = "#222222", family = "Arial", xpd = NA)
}

headers <- c("Source", "Enterobacterales genus", "Resistance gene", "Country")
text(as.numeric(x_by_layer), y_extent * 0.045, headers, cex = 1.02, font = 2,
     col = "#222222", family = "Arial", xpd = NA)

dev.off()
cat(output, "\n")
