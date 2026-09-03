## 负二项分布 | Negative Binomial Distribution

15.20
```{r negative-binomial,fig.width=10,fig.height=6, fig.cap="不同参数下负二项分布图"}

negativebin_dist = function(N, n, pi){
  rx = seq(0, N, 1)
  dx = dnbinom(rx, n, pi)
  label = paste('n == ', n, '~', 'pi == ', pi)
  ggplot(data.frame(rx, dx), aes(x = rx, y = dx)) +
    geom_bar(stat = "identity", width = 0.8, 
             fill = cols[2], alpha = 0.8) + 
    scale_y_continuous(expand = c(0, 0), limits = c(0, ceiling(max(dx)*10)/10), 
                       breaks = seq(0, 1.00, 0.05)) + 
    scale_x_continuous(expand = c(0, 0.1), breaks = seq(0, N, n)) +
    coord_cartesian(xlim = c(0, N)) +
    labs(x = "x", y = "Density") + 
    annotate(geom = 'text', x = 1, y = Inf, label = label,
             hjust = 0, vjust = 1, parse = TRUE, size = 4) +
    theme_egraphics
}
p1 = negativebin_dist(N = 25, n = 5, pi = 0.2)
p2 = negativebin_dist(N = 25, n = 5, pi = 0.5)
p3 = negativebin_dist(N = 25, n = 5, pi = 0.8)
p4 = negativebin_dist(N = 60, n = 10, pi = 0.5)
p5 = negativebin_dist(N = 60, n = 20, pi = 0.5)
p6 = negativebin_dist(N = 60, n = 30, pi = 0.5)

fig15.20 = 
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

ggsave(plot = fig15.20, "figure_tiff/2-11数据分布/图15.20.pdf",width = 10, height= 6, units="in")

```

