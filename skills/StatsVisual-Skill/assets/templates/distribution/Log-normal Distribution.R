## 对数正态分布 | Logarithmic Normal Distribution

15.2

```{r log-normal-distribution, fig.width=8,fig.height=6,fig.cap="不同参数下对数正态分布图"}

Lognormal_dist = function(mu0,sigma0){
  mu = mu0
  sigma = sigma0
  rx = seq(0, 10, length = 1000)
  dx = dlnorm(rx, mu, sigma)
  label = paste('mu == ', mu, '~', 'sigma == ', sigma)
  ggplot(data.frame(rx, dx), aes(x = rx, y = dx)) +
    geom_line(color = cols[2], size = 1) + 
    scale_y_continuous(expand = c(0, 0), limits = c(0, 1), breaks = seq(0, 1, 0.2)) + 
    scale_x_continuous(expand = c(0, 0), limits = c(0, 10), breaks = seq(0, 10, 2)) + 
    coord_cartesian(clip = "off") +
    labs(x= "x", y= "Density") + 
    annotate(geom = 'text', x = 1, y = Inf, label = label,
             hjust = 0, vjust = 1, parse = TRUE, size = 4) +
    theme_egraphics
}
p1 = Lognormal_dist(mu0 = 0, sigma0 = 0.5)
p2 = Lognormal_dist(mu0 = 0, sigma0 = 1)
p3 = Lognormal_dist(mu0= 0.5, sigma0 = 1)
p4 = Lognormal_dist(mu0 = 1, sigma0 = 1)
p5 = Lognormal_dist(mu0 = 1, sigma0 = 2)
p6 = Lognormal_dist(mu0 = 2, sigma0 = 1)

fig15.2 = 
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

ggsave(plot = fig15.2, "figure_tiff/2-11数据分布/图15.2.pdf",width = 8, height= 6, units="in")

```

