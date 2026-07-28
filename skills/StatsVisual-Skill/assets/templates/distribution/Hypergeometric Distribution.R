## 超几何分布 | Hypergeometric Distribution

15.19
```{r hypergeometric-distribution, fig.width=10,fig.height=6,fig.cap="不同参数下超几何分布图"}

hypergeometric_dist = function(N, M, n, letter0, cx, bx){
  rx = seq(0, n, 1)
  dx = dhyper(rx, N, M, n)
  label = paste('n == ', n, '~', 'N == ', N, '~', 'M == ', M)
  ggplot(data.frame(rx, dx), aes(x = rx, y = dx)) +
    geom_bar(stat = "identity", width = 0.8, 
             fill = cols[2], alpha = 0.8) + 
    scale_y_continuous(expand = c(0, 0), limits = c(0.00, ceiling(max(dx)*10)/10), 
                       breaks = seq(0.00, 1.00, 0.05)) + 
    scale_x_continuous(expand = c(0, 0.1), breaks = bx) + 
    coord_cartesian(xlim = cx) +
    labs(x = "x", y = "Density") + 
    annotate(geom = 'text', x = 1, y = Inf, label = label,
             hjust = 0, vjust = 1, parse = TRUE, size = 3) +
    theme_egraphics
}

p1 = hypergeometric_dist(N = 10, M = 10, n = 5, cx = c(0, 20), bx = seq(0, 20, 5))
p2 = hypergeometric_dist(N = 10, M = 10, n = 10, letter0 = "b", cx = c(0, 20), bx = seq(0, 20, 5))
p3 = hypergeometric_dist(N = 10, M = 10, n = 15, letter0 = "c", cx = c(0, 20), bx = seq(0, 20, 5))
p4 = hypergeometric_dist(N = 20, M = 10, n = 10, letter0 = "d", cx = c(0, 30), bx = seq(0, 30, 5))
p5 = hypergeometric_dist(N = 20, M = 10, n = 15, letter0 = "e", cx = c(0, 30), bx = seq(0, 30, 5))
p6 = hypergeometric_dist(N = 20, M = 10, n = 25, letter0 = "f", cx = c(0, 30), bx = seq(0, 30, 5))

fig15.19 = 
  plot_grid(p1,
          p2,
          p3,
          p4,
          p5,
          p6,
          nrow = 2,
          ncol = 3,
          labels = c("A", "B", "C",
                     "D", "E", "F"),
          label_size = 11)

ggsave(plot = fig15.19, "figure_tiff/2-11数据分布/图15.19.pdf",width = 10, height= 6, units="in")

```

