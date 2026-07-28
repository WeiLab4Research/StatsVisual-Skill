## 热图聚类图 | Clustered Heatmap

12.4。

```{r clustered-heatmap, fig.width = 8, fig.height = 8, fig.cap="脐带血清56个元素暴露水平相关性热图"}

# 读取数据
ds_clustered = read.csv("data/0800_clustered.csv",row.names=1, sep=",")
bk = c(seq(-0.5, 0, 0.01), seq(0, 1, 0.01))

tiff("figure_tiff/2-08热图/图12.4.tiff", width = 12, height = 12, units = "in", res = 300)
pheatmap(ds_clustered,
         annotation_legend = TRUE,
         show_rownames = T,
         show_colnames = T,
         fontsize_number = 7,
         color = c(colorRampPalette(colors = c("darkblue",
                                               "white"))(length(bk)/3),
                   colorRampPalette(colors = c("white",
                                               "red"))(length(bk)/3 * 2)))

dev.off()
```

