## 几何分布 | Geometric Distribution

15.18

```{r geometric-distribution, fig.width=8,fig.height=6,fig.cap="不同参数下的几何分布图"}

geometric_dist = function(p0){
  p = p0
  rx = seq(0, 20, 1)
  dx = dgeom(rx, p)
  label = paste('pi == ', p)
  ggplot(data.frame(rx, dx), aes(rx, dx)) +
    geom_bar(stat = "identity", fill = cols[2], width = 0.8) + 
    scale_y_continuous(expand = c(0, 0), limits = c(0, p), breaks = seq(0, p, length = 5)) +
    scale_x_continuous(expand = c(0, 0)) +
    labs(x = "x", y = "Density") + 
    annotate(geom = 'text', x = 5, y = Inf, label = label,
             hjust = 0, vjust = 1, parse = TRUE, size = 4) +
    theme_egraphics
}

p1 = geometric_dist(0.1)
p2 = geometric_dist(0.2)
p3 = geometric_dist(0.3)
p4 = geometric_dist(0.5)
p5 = geometric_dist(0.7)
p6 = geometric_dist(0.9)

fig15.18 = 
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

ggsave(plot = fig15.18, "figure_tiff/2-11数据分布/图15.18.pdf",width = 8, height= 6, units="in")

```

