## 柯西分布 | Cauthy Distribution 

15.24。

```{r cauthy-distribution, fig.width=10,fig.height=6,fig.cap="不同参数下的柯西分布"}

cauchy_dist = function(lacation, scale){
  x0 = lacation
  gamma = scale
  rx = seq(-20, 20, length = 1000)
  dx = dcauchy(rx, location = x0, scale = gamma)
  label = paste('x[0] == ', x0, '~', ' gamma== ', gamma)
  ggplot(data.frame(rx, dx), aes(x = rx, y = dx)) +
    geom_line(colour = cols[2], size = 1) + 
    scale_x_continuous(expand = c(0, 0)) +
    scale_y_continuous(expand = c(0, 0.01), limits = c(0, 0.7), breaks = seq(0, 0.7, 0.1)) +
    labs(x = "x", y = "Density") + 
    coord_cartesian(clip = "off") +
    annotate(geom = 'text', x = -19, y = Inf, label = label,
             hjust = 0, vjust = 1, parse = TRUE, size = 4.5) +
    theme_egraphics
}

p1 = cauchy_dist(0, 0.5)
p2 = cauchy_dist(0, 1)
p3 = cauchy_dist(0, 2)
p4 = cauchy_dist(1, 0.5)
p5 = cauchy_dist(2, 1)
p6 = cauchy_dist(3, 2)

fig15.24 = plot_grid(p1,
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

ggsave(plot = fig15.24, "figure_tiff/2-11数据分布/图15.24.pdf",width = 10, height= 6, units="in")
```

