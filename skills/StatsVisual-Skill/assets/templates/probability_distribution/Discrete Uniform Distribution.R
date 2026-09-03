## 离散均匀分布 | Discrete Uniform Distribution

15.9。

```{r discrete-uniform,fig.width=10,fig.height=6, fig.cap="离散均匀分布图"}

DisUniform_dist = function(n1, n2){
  rx = seq(n1, n2, 1)
  dx = 1/(n2-n1+1)
  label = paste('n[1] == ', n1,'~~','n[2] == ', n2)
  ggplot(data.frame(rx, dx), aes(x = rx, y = dx)) + 
    geom_linerange(min = 0, max = dx, position = "identity",
                   size=0.8, colour = cols[2], alpha = 0.8) + 
    scale_y_continuous(expand = c(0, 0), limits = c(0, 0.8), 
                       breaks = seq(0, 0.8, 0.2)) + 
    labs(x = "x", y = "Density") +
    annotate(geom = 'text', x = 1, y = Inf, label = label,
             hjust = 0, vjust = 1, parse = TRUE, size = 4) +
    theme_egraphics
}

p1 = DisUniform_dist(n1 = 1, n2 = 4)
p2 = DisUniform_dist(n1 = 2, n2 = 4)
p3 = DisUniform_dist(n1 = 2, n2 = 9)
p4 = DisUniform_dist(n1 = 5, n2 = 9)

fig15.9 = 
  plot_grid(p1,
          p2,
          p3,
          p4,
          nrow = 2,
          ncol = 2,
          labels = c("A","B","C","D"),
          label_size = 11)

ggsave(plot = fig15.9, "figure_tiff/2-11数据分布/图15.9.pdf",width = 10, height= 6, units="in")
```

