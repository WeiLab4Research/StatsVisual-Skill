## 伯努利分布 | Bernoulli Distribution

15.13。

```{r bernoulli-ditribution,fig.width=8,fig.height=6, fig.cap="不同p的伯努利分布图"}

Bernoulli_dist = function(p){
  rx = c(0, 1)
  dx = c(p, 1-p)
  label = paste('p == ', p)
  ggplot(data.frame(rx, dx), aes(x = rx, y = dx)) + 
    geom_linerange(min = 0, max = dx, position = "identity",
                   size = 0.8, colour = cols[2], alpha = 0.8) + 
    scale_y_continuous(expand = c(0, 0), limits = c(0, 1), seq(0, 1, 0.2)) + 
    scale_x_continuous(expand = c(0, 0.4), limits = c(0, 1), breaks = c(0, 1)) + 
    labs(x = "x", y = "Density") + 
    annotate(geom = 'text', x = 0.05, y = Inf, label = label,
             hjust = 0, vjust = 1, parse = TRUE, size = 4) +
    theme_egraphics
}

p1 = Bernoulli_dist(p = 0.1)
p2 = Bernoulli_dist(p = 0.3)
p3 = Bernoulli_dist(p = 0.5)
p4 = Bernoulli_dist(p = 0.8)

fig15.13 = 
  plot_grid(p1,
          p2,
          p3,
          p4,
          nrow = 2,
          ncol = 2,
          labels = c("A","B","C","D"),
          label_size = 11)

ggsave(plot = fig15.13, "figure_tiff/2-11数据分布/图15.13.pdf",width = 8, height= 6, units="in")
```

