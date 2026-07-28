## F分布 | F-distribution

15.5。

```{r F-distribution,fig.width=10,fig.height=6, fig.cap = "不同自由度下的F分布"}

F_dist = function(v1, v2){
  df1 = v1
  df2 = v2
  rx = seq(0, 6, length = 100)
  dx = df(rx, df1, df2)
  label = paste('df1 == ', df1, '~','df2==', df2)
  ggplot(data.frame(rx, dx), aes(rx, dx)) +
    geom_line(color = cols[2]) + 
    scale_y_continuous(expand = c(0, 0),limits = c(0, 1), breaks = seq(0, 1, 0.25)) +
    scale_x_continuous(expand = c(0, 0)) +
    labs(x = "x", y = "Density") + 
    annotate(geom = 'text', x = 0.5, y = Inf, label = label,
             hjust = 0, vjust = 1, parse = TRUE, size = 3) +
    theme_egraphics
}

p1 = F_dist(5, 5)
p2 = F_dist(5, 10)
p3 = F_dist(10, 5)
p4 = F_dist(10, 25)
p5 = F_dist(15, 10)
p6 = F_dist(15, 25)

fig15.5 = 
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

ggsave(plot = fig15.5, "figure_tiff/2-11数据分布/图15.5.pdf",width = 10, height= 6, units="in")

```

