## Beta分布 | Beta Distribution

15.7。

```{r beta-distribution, fig.width=10,fig.height=6,fig.cap="不同参数下Beta分布"}

beta_dist = function(alpha0, beta0, cl0, ybreaks0){
  alpha = alpha0;beta = beta0;cl = cl0;ybreaks = ybreaks0;
  rx = seq(0.01, 0.99, length = 500)
  dx = dbeta(rx, alpha, beta)
  label = paste('a == ', alpha, '~', ' b== ', beta)
  ggplot(data.frame(rx, dx), aes(x = rx, y = dx)) +
    geom_line(color = cols[2], size = 1) + 
    scale_y_continuous(expand = c(0, 0), limits = cl, breaks = ybreaks) + 
    scale_x_continuous(expand = c(0, 0), limits = c(0, 1), breaks = seq(0, 1, 0.2)) + 
    labs(x = "x", y = "Density") + 
    annotate(geom = 'text', x = 0.1, y = Inf, label = label,
             hjust = 0, vjust = 1, parse = TRUE, size = 4) +
    theme_egraphics
}
p1 = beta_dist(alpha0 = 0.5, beta0 = 0.5, cl0 = c(0, 5), ybreaks0 = c(0, 1, 2, 3, 4, 5))
p2 = beta_dist(alpha0 = 1, beta0 = 1, cl0 = c(0, 5), ybreaks0 = c(0, 1, 2, 3, 4, 5))
p3 = beta_dist(alpha0 = 5, beta0 = 1, cl0 = c(0, 5), ybreaks0 = c(0, 1, 2, 3, 4, 5))
p4 = beta_dist(alpha0 = 5, beta0 = 5, cl0 = c(0, 6), ybreaks0 = c(0, 1, 2, 3, 4, 5, 6))
p5 = beta_dist(alpha0 = 15, beta0 = 5, cl0 = c(0, 6), ybreaks0 = c(0, 1, 2, 3, 4, 5, 6))
p6 = beta_dist(alpha0 = 150, beta0 = 50, cl0 = c(0, 16), ybreaks0 = c(0, 2, 4, 6, 8, 10, 12, 14, 16))

fig15.7 = 
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

ggsave(plot = fig15.7, "figure_tiff/2-11数据分布/图15.7.pdf",width = 10, height= 6, units="in")
```

