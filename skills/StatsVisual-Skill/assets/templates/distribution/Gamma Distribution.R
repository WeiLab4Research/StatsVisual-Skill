## Gamma分布 | Gamma Dsitribution

15.10。

```{r gamma-distribution,fig.width=10,fig.height=6, fig.cap="不同参数下Gamma分布图"}

gamma_dist = function(alpha0, beta0, ybreaks0){
  alpha = alpha0
  beta = beta0
  rx = seq(0, 8, length = 500)
  dx = dgamma(rx, alpha, beta)
  label = paste('a == ', alpha, '~', ' b== ', beta)
  ggplot(data.frame(rx, dx), aes(x = rx, y = dx)) +
    geom_line(colour = cols[2], size = 1) + 
    scale_y_continuous(expand = c(0, 0), limits = c(0, 3), breaks = seq(0, 3, 0.5)) + 
    scale_x_continuous(expand = c(0, 0.1), limits = c(0, 8), breaks = seq(0, 8, 2)) + 
    labs(x = "x", y = "Density") + 
    annotate(geom = 'text', x = 2, y = Inf, label = label,
             hjust = 0, vjust = 1, parse = TRUE, size = 3) +
    theme_egraphics
}
p1 = gamma_dist(alpha0 = 0.05, beta0 = 0.1)
p2 = gamma_dist(alpha0 = 0.1, beta0 = 0.1)
p3 = gamma_dist(alpha0 = 1, beta0 = 1)
p4 = gamma_dist(alpha0 = 4, beta0 = 1)
p5 = gamma_dist(alpha0 = 20, beta0 = 5)
p6 = gamma_dist(alpha0 = 20, beta0 = 20)

fig15.10 = 
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

ggsave(plot = fig15.10, "figure_tiff/2-11数据分布/图15.10.pdf",width = 10, height= 6, units="in")
```

