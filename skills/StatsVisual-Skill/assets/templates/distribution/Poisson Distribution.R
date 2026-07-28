## Poisson分布 | Poisson Distribution

15.15

```{r poisson-distribution,fig.width=8,fig.height=6, fig.cap="不同lambda下泊松分布图"}

poisson_dist = function(lambda0, cy){
  lambda = lambda0
  rx = seq(0, 20, 1)
  dx = dpois(rx, lambda)
  label = paste('lambda == ',lambda)
  ggplot(data.frame(rx, dx), aes(x = rx, y = dx)) +
    geom_bar(stat = "identity", width = 0.8, 
             fill = cols[2], alpha = 0.8) + 
    scale_y_continuous(expand = c(0, 0), limits = c(0, 0.6), breaks = seq(0, 0.6, 0.2)) + 
    scale_x_continuous(breaks = seq(0, 20, 4), expand = c(0, 0.1)) + 
    coord_cartesian(xlim = c(0, 20)) + 
    labs(x = "x", y = "Density") + 
    annotate(geom = 'text', x = 1, y = Inf, label = label,
             hjust = 0, vjust = 1, parse = TRUE, size = 4) +
    theme_egraphics
}
p1 = poisson_dist(lambda0 = 0.6, cy = c(0, 0.6))
p2 = poisson_dist(lambda0 = 1, cy = c(0, 0.6))
p3 = poisson_dist(lambda0 = 1.5, cy = c(0, 0.6))
p4 = poisson_dist(lambda0 = 2, cy = c(0, 0.4))
p5 = poisson_dist(lambda0 = 4, cy = c(0, 0.4))
p6 = poisson_dist(lambda0 = 8, cy = c(0, 0.4))

fig15.15 = plot_grid(p1,
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

ggsave(plot = fig15.15, "figure_tiff/2-11数据分布/图15.15.pdf",width = 8, height= 6, units="in")
```

