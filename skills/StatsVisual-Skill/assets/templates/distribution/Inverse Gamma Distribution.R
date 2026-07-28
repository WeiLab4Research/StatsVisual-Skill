## 逆Gamma分布 | Inverse Gamma Distribution

15.12。

```{r inverse-gamma-distribution,fig.width=10,fig.height=6, fig.cap="不同参数下的逆Gamma分布"}

Igamma_dist = function(alpha0, beta0){
  alpha = alpha0
  beta = beta0
  rx = seq(0, 8, length = 500)
  dx = dgamma(1/rx, alpha, beta)/(rx*rx)
  label = paste('a == ', alpha, '~', ' b== ', beta)
  ggplot(data.frame(rx, dx), aes(x = rx, y = dx)) +
    geom_line(colour = cols[2], size = 1) + 
    scale_y_continuous(expand = c(0, 0), limits = c(0, 4), breaks = seq(0, 4, 1)) + 
    scale_x_continuous(expand = c(0, 0), limits = c(0, 8), breaks = seq(0, 8, 2)) +
    labs(x = "x", y = "Density") + 
    annotate(geom = 'text', x = 1, y = Inf, label = label,
             hjust = 0, vjust = 1, parse = TRUE, size = 4) +
    theme_egraphics
}
p1 = Igamma_dist(alpha0 = 0.1, beta0 = 0.05)
p2 = Igamma_dist(alpha0 = 0.1, beta0 = 0.1)
p3 = Igamma_dist(alpha0 = 1, beta0 = 1)
p4 = Igamma_dist(alpha0 = 1, beta0 = 2)
p5 = Igamma_dist(alpha0 = 4, beta0 = 1)
p6 = Igamma_dist(alpha0 = 20, beta0 = 20)

fig15.12 = 
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

ggsave(plot = fig15.12, "figure_tiff/2-11数据分布/图15.12.pdf",width = 10, height= 6, units="in")

```

