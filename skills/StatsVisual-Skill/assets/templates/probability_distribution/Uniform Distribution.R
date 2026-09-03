## 均匀分布 | Uniform Distribution

15.8

```{r uniform-distribution,fig.width=10, fig.height=4,,fig.cap="不同参数下的均匀分布图"}

uniform_dist = function(alpha0, beta0,letter0){
  alpha = alpha0
  beta = beta0
  rx = runif(100, alpha, beta)
  dx = dunif(rx,alpha,beta)
  label = paste('a == ', alpha, '~', ' b== ', beta)
  ggplot(data.frame(rx, dx), aes(x = rx, y = dx)) +
    geom_line(color = cols[2], size = 1) + 
    scale_y_continuous(expand = c(0, 0.01), limits = c(0, 1), breaks = seq(0, 1, 0.2)) + 
    scale_x_continuous(expand = c(0, 0), limits = c(0, 5), breaks = seq(0, 5, 1)) + 
    labs(x = "x", y = "Density") + 
    annotate(geom = 'text', x = 2, y = Inf, label = label,
             hjust = 0, vjust = 1, parse = TRUE, size = 4) +
    theme_egraphics
}

p1 = uniform_dist(alpha0 = 0, beta0 = 1, letter0 = "a")
p2 = uniform_dist(alpha0 = 2, beta0 = 5, letter0 = "b")
p3 = uniform_dist(alpha0 = 3, beta0 = 5, letter0 = "c")

fig15.8 = plot_grid(p1,
          p2,
          p3,
          nrow = 1,
          ncol = 3,
          labels = c("A", "B", "C"),
          label_size = 11)

ggsave(plot = fig15.8, "figure_tiff/2-11数据分布/图15.8.pdf",width = 10, height= 4, units="in")
```

