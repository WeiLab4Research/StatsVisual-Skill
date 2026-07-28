## 直方图间距 |Histogram Bins

图8.3。

```{r histogram-bins, fig.width=8, fig.cap = "江苏省13088名青少年体质指数分布直方图"}

# 设置简单函数，设置不同组距进行绘图
histogram_special = function(data, x, bin){
  ggplot(data) +
    geom_histogram(aes_string(x = x),
                   bins = bin,
                   color = gray(1),
                   fill = gray(0.5)) +
    scale_y_continuous(expand = c(0, 0)) +
    labs(x = "BMI", y = "Frequency") +
    theme_egraphics
}

p1 = histogram_special(PE, "bmi", 5)
p2 = histogram_special(PE, "bmi", 10)
p3 = histogram_special(PE, "bmi", 15)
p4 = histogram_special(PE, "bmi", 20)
p5 = histogram_special(PE, "bmi", 35)
p6 = histogram_special(PE, "bmi", 50)

hist_all = 
  plot_grid(p1, p2, p3,
          p4, p5, p6,
          labels = c("A", "B", "C",
                     "D", "E", "F"),
          nrow = 2)

ggsave(plot = hist_all, "figure_tiff/2-04直方图/图8.3.pdf",width= 8, height= 4, units="in")

```

