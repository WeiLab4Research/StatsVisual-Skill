## t分布 | Student's Distribution

15.4。

```{r t-distribution, fig.width=10,fig.height=6,fig.cap="不同自由度情况下的t分布"}

student_dist = function(v){
  df = v 
  rx = seq(-4, 4, length = 200)
  dx = dt(rx, df)
  label = paste('df == ', df)
  ggplot(data.frame(rx, dx), aes(rx, dx)) +
    geom_line(color = cols[2]) + 
    scale_y_continuous(expand = c(0, 0),limits = c(0, 0.5)) +
    scale_x_continuous(expand = c(0, 0), limits = c(-4, 4)) +
    labs(x = "x", y = "Density") + 
    annotate(geom = 'text', x = -3, y = Inf, label = label,
             hjust = 0, vjust = 1, parse = TRUE, size = 4) +
    theme_egraphics
}

#different df
p1 = student_dist(1)
p2 = student_dist(2)
p3 = student_dist(5)
p4 = student_dist(10)
p5 = student_dist(50)
p6 = student_dist(100)

fig15.4 = 
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

ggsave(plot = fig15.4, "figure_tiff/2-11数据分布/图15.4.pdf",width = 10, height= 6, units="in")

```

