## 密度分布向日葵图 | Sunflower Scatter Plot

11.7

```{r scatter-sunflower, fig.width=8, fig.cap="各地区受保人子女数量向日葵图"}

insurance = read.csv("data/0710_insurance.csv")

tiff("figure_tiff/2-07散点图/fig11.7.tiff", width = 8, height = 4, units = "in", res = 300)

par(mar = c(5, 5, 2, 2))
sunflowerplot(insurance[, c("children", "region")],
              cex = 1,
              rotate = T ,
              ylim = c(0, 5),
              col = "gold",
              seg.col = "gold",
              size = 0.2,
              yaxt = "n",
              xlab = "Children",
              ylab = "")
axis(2,
     c(1, 2, 3, 4),
     labels = c("Northeast",
               "Northwest",
               "Southeast",
               "Southwest"),
    las = 2,
    cex.axis = 0.7)

title(ylab = "Region",
      line = 4)

dev.off()

```

