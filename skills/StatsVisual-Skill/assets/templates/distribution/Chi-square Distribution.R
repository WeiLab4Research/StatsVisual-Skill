## 卡方分布 | Chi-square Distribution

15.6。

```{r chisquare-distribution, fig.width=10,fig.height=6,fig.cap="不同自由度下卡方分布"}

chisq_dist = function(v){
  df = v 
  rx = seq(0, 40, length = 400)
  dx = dchisq(rx, df)
  label = paste('df == ', df)
  ggplot(data.frame(rx, dx), aes(rx, dx)) +
    geom_line(color = cols[2]) + 
    scale_y_continuous(expand = c(0, 0),limits = c(0, 0.5)) +
    scale_x_continuous(expand = c(0, 0)) +
    labs(x= "x", y = "Density") + 
    annotate(geom = "text", x = 1, y = Inf, label = label,
             hjust = 0, vjust = 1, parse = TRUE, size = 4) +
    theme_egraphics
}

p1 = chisq_dist(1)
p2 = chisq_dist(2)
p3 = chisq_dist(4)
p4 = chisq_dist(6)
p5 = chisq_dist(11)
p6 = chisq_dist(50)

fig15.6 = 
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

ggsave(plot = fig15.6, "figure_tiff/2-11数据分布/图15.6.pdf",width = 10, height= 6, units="in")
```

