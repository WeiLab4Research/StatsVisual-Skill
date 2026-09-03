## Weibull分布 | Weibull Distribution

15.25
```{r Weibull-distribution, fig.width=10,fig.height=6,fig.cap="不同参数下的Weibull分布"}

weibull_dist = function(alpha0, beta0){
  alpha = alpha0
  beta = beta0
  rx = seq(0, 8, length = 500)
  dx = dweibull(rx, alpha, beta)
  label = paste('a == ', alpha, '~', ' b== ', beta)
  ggplot(data.frame(rx, dx), aes(x = rx, y = dx)) +
    geom_line(colour = cols[2], size = 1) + 
    scale_y_continuous(expand = c(0, 0), limits = c(0, 1.5), breaks = seq(0, 1.5, 0.5)) + 
    scale_x_continuous(expand = c(0, 0), limits = c(0,8), breaks = seq(0, 8, 2)) + 
    labs(x = "x", y = "Density") + 
    annotate(geom = 'text', x = 1, y = Inf, label = label,
             hjust = 0, vjust = 1, parse = TRUE, size = 4) +
    theme_egraphics
}
p1 = weibull_dist (alpha0 = 0.5, beta0 = 1) 
p2 = weibull_dist (alpha0 = 1, beta0 = 1)
p3 = weibull_dist (alpha0 = 2, beta0 = 1)
p4 = weibull_dist (alpha0 = 2, beta0 = 2)
p5 = weibull_dist (alpha0 = 2, beta0 = 4)
p6 = weibull_dist (alpha0 = 4, beta0 = 4)

fig15.25 = plot_grid(p1,
          p2,
          p3,
          p4,
          p5,
          p6,
          nrow = 2,
          ncol = 3,
          labels = c("A", "B", "C",
                     "D", "E", "F"))

ggsave(plot = fig15.25, "figure_tiff/2-11数据分布/图15.25.pdf",width = 10, height= 6, units="in")

```

