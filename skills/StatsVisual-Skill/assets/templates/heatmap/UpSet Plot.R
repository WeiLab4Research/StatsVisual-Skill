## 强化韦恩图 | Upset Plot

12.11。

```{r upset-covid, fig.width=10, fig.height=8, fig.cap="儿童新冠肺炎后遗症持续存在情况"}

# 读入数据
nCov = read.csv("data/0800_veen.csv")

tiff("figure_tiff/2-08热图/fig12.11.tiff", width = 10, height = 8, units = "in", res = 300)
  upset(nCov, 
      # 显示数据集的所有数据
      nsets = 9,    
      nintersects = 50,
      order.by = "freq",
      mb.ratio = c(0.5, 0.5),
      point.size = 4,
      text.scale = 1.3,
      main.bar.color = "#21538BFF",
      sets.bar.color = "#21538BFF",
      matrix.color = "#21538BFF")
dev.off()

```

