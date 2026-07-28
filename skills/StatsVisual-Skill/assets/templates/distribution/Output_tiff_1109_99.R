## Logistic分布 | Logistic Distribution

15.26。

```{r logistic-distribution, fig.width=6,fig.height=6,fig.cap="不同参数下的logistic分布图"}

logistic_dist = function(mu, s){
  rx = seq(-20, 20, length = 1000)
  dx = dlogis(rx, location = mu, scale = s)
  label = paste('mu == ', mu, '~', ' s== ', s)
  ggplot(data.frame(rx, dx), aes(x = rx, y = dx)) +
    geom_line(colour = cols[2], size = 1) + 
    scale_x_continuous(expand = c(0, 0)) +
    scale_y_continuous(expand = c(0, 0), limits = c(0, 0.25)) +
    labs(x = "x", y = "Density") + 
    coord_cartesian(clip = "off") +
    annotate(geom = 'text', x = -19, y = Inf, label = label,
             hjust = 0, vjust = 1, parse = TRUE, size = 4) +
    theme_egraphics
}

p1 = logistic_dist(mu = 0, s = 1)
p2 = logistic_dist(mu = 1, s = 1)
p3 = logistic_dist(mu = 2, s = 4)
p4 = logistic_dist(mu = 2, s = 6)
p5 = logistic_dist(mu = 6, s = 3)
p6 = logistic_dist(mu = 9, s = 3)

fig15.26 = plot_grid(p1,
          p2,
          p3,
          p4,
          p5,
          p6,
          nrow = 3,
          ncol = 2,
          labels = c("A", "B", "C",
                     "D", "E", "F"),
          label_size = 11)

ggsave(plot = fig15.26, "figure_tiff/2-11数据分布/图15.26.pdf",width = 6, height= 6, units="in")

```

# 曲线平滑 | Curve Smooth

