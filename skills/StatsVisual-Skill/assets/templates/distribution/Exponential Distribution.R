## 指数分布 | Exponential Distribution

15.11

```{r exponential-distribution,fig.width=10,fig.height=6, fig.cap="不同参数下的指数分布"}

Exp_dist = function(lambda0){
  lambda = lambda0
  rx = seq(0, 8, length = 500)
  dx = dexp(rx, lambda)
  label = paste('lambda == ', lambda)
  ggplot(data.frame(rx, dx), aes(x = rx, y = dx)) +
    geom_line(color = cols[2], size = 1) + 
    scale_y_continuous(expand = c(0, 0), limits = c(0, 1), breaks = seq(0, 1, 0.2)) + 
    scale_x_continuous(expand = c(0, 0), limits = c(0, 10), breaks = seq(0, 10, 2)) + 
    coord_cartesian(clip = "off") +
    labs(x = "x", y = "Density") + 
    annotate(geom = 'text', x = 2, y = Inf, label = label,
             hjust = 0, vjust = 1, parse = TRUE, size = 4) +
    theme_egraphics
}
p1 = Exp_dist(lambda0 = 0)
p2 = Exp_dist(lambda0 = 1)
p3 = Exp_dist(lambda0 = 2)
p4 = Exp_dist(lambda0 = 3)
p5 = Exp_dist(lambda0 = 4)
p6 = Exp_dist(lambda0 = 5)

fig15.11 =
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

ggsave(plot = fig15.11, "figure_tiff/2-11数据分布/图15.11.pdf",width = 10, height= 6, units="in")
```

