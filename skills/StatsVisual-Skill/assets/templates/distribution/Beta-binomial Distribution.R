## Beta-二项分布 | Beta-binomial Distribution

15.16

```{r beta-bio-distribution, fig.width=10, fig.height=6, fig.cap="不同参数下的Beta-二项分布图"}

betabin_dist = function(n, alpha, beta, cy){
  rx = seq(0, n, 1)
  dx = dbb(rx, n, alpha, beta)
  label = paste('n == ', n, '~', 'alpha == ', alpha, '~', 'beta == ', beta)
  ggplot(data.frame(dx, rx), aes(x = rx, y = dx)) +
    geom_bar(stat = "identity", width = 0.8, 
                   fill = cols[2], alpha = 0.8) + 
    scale_y_continuous(limits = cy, breaks = seq(0, 0.6, 0.2), expand = c(0, 0)) + 
    scale_x_continuous(breaks = seq(0, n ,5), expand = c(0, 0.1)) + 
    coord_cartesian(xlim = c(0, n)) +
    labs(x = "x", y = "Density") + 
    annotate(geom = 'text', x = 1, y = Inf, label = label,
             hjust = 0, vjust = 1, parse = TRUE, size = 3) +
    theme_egraphics
}
p1 = betabin_dist(n = 20, alpha = 0.2, beta = 0.2, cy = c(0, 0.4))
p2 = betabin_dist(n = 20, alpha = 0.2, beta = 2, cy = c(0, 0.6))
p3 = betabin_dist(n = 20, alpha = 2, beta = 0.2, cy = c(0, 0.6))
p4 = betabin_dist(n = 20, alpha = 12, beta = 8, cy = c(0, 0.4))
p5 = betabin_dist(n = 20, alpha = 8, beta = 12, cy = c(0, 0.4))
p6 = betabin_dist(n = 40, alpha = 12, beta = 12, cy = c(0, 0.4))

fig15.16 = 
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

ggsave(plot = fig15.16, "figure_tiff/2-11数据分布/图15.16.pdf",width = 8, height= 6, units="in")

```

