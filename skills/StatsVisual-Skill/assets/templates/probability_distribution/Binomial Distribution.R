## 二项分布 | Binomial Distribution

15.14

```{r binomial-distribution,fig.width=10,fig.height=6, fig.cap="不同情况下二项分布图"}

binomial_dist = function(n, pi, cy){
  rx = seq(0, n, 1)
  dx = dbinom(rx, n, pi)
  step = 5
  if(n>=50) {step = 20}
  label = paste('n==',n,'~', 'pi == ',pi)
  ggplot(data.frame(rx, dx), aes(x = rx, y = dx)) +
    geom_bar(stat = "identity", width = 0.8,
             fill = cols[2], alpha = 0.8) + 
    scale_x_continuous(breaks= seq(0, 25, 5),expand = c(0, 0.1)) +
    scale_y_continuous(expand = c(0, 0), limits = cy, breaks = seq(0, 0.6, 0.1)) +
    coord_cartesian(xlim = c(0, 25)) + 
    labs(x = "x", y= "Density") + 
    annotate(geom = 'text', x = 1, y = Inf, label = label,
             hjust = 0, vjust = 1, parse = TRUE, size = 4) +
    theme_egraphics
}
p1 = binomial_dist(n = 20, pi = 0.05, cy = c(0, 0.6))
p2 = binomial_dist(n = 20, pi = 0.1, cy = c(0, 0.6))
p3 = binomial_dist(n = 20, pi = 0.5, cy = c(0, 0.6))
p4 = binomial_dist(n = 20, pi = 0.1, cy = c(0, 0.4))
p5 = binomial_dist(n = 40, pi = 0.1, cy = c(0, 0.4))
p6 = binomial_dist(n = 100, pi = 0.1, cy = c(0, 0.4))

fig15.14 = 
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

ggsave(plot = fig15.14, "figure_tiff/2-11数据分布/图15.14.pdf",width = 10, height= 6, units="in")

```

