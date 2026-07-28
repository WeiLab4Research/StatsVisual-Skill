## 基础热图 | Basic Heatmap

12.2。

```{r basic-heatmap, fig.width = 8, fig.height = 8, fig.cap="脐带血清56个元素暴露水平相关性热图"}

# 加载本章节所需程序包
library(ggpubr)
library(ggsci)
library(stringr)
library(pheatmap)
library(ggalluvial)
library(RColorBrewer)
library(ggvenn)
library(UpSetR)

# 设置图形基本背景
theme_egraphics = 
  theme_pubr() + 
  theme(axis.title.y = element_text(margin = margin(t = 0, r = 10, 
                                                    b = 0, l = 0)),
        axis.title.x = element_text(margin = margin(t = 10, r = 0, 
                                                    b = 0, l = 0)),
        axis.title = element_text(size = 13, face = "bold"),
        axis.line = element_line(linewidth = 0.6, color = "black"),
        axis.ticks = element_line(size = 0.3),
        axis.ticks.length = unit(.15, "cm"),
        axis.text  = element_text(size = 10),
        plot.margin = margin(.5, .5, .5, .5, "cm"))

# 读取数据
element = read.csv(file ="data/0800_basic_heatmap.csv")

fig12.2 = 
  ggplot(element, aes(X, Y, fill = Correlation)) +
  geom_tile(color = "white", linetype = 1) +
  scale_x_discrete(labels = function(x) str_wrap(x, width = 25)) +
  scale_fill_gradient2(low = "darkblue", 
                       mid = "white", 
                       high = "red") +
  labs(x = "", 
       y= "", 
       fill = "Correlation") +
  coord_fixed() +
  theme_egraphics +
  theme(legend.position = "right",
        axis.text.x = element_text(angle = 90),
        axis.text = element_text(size = 8))

ggsave(plot = fig12.2, "figure_tiff/2-08热图/图12.2.pdf",width= 8, height= 8, units="in")
```

12.3。

```{r LDheatmap, fig.width = 8, fig.height = 8, fig.cap="LD热图"}
# 加载本章节所需程序包
library(LDheatmap)
data("CEUSNP")
data("CEUDist")
# 设置调色
red.colors =  colorRampPalette(
  rev(c("#FF6E00", "#FFFFEA", "#2400D8")), 
  space = "rgb")
# 绘图，一行三列，拼合
library(grid)

tiff("figure_tiff/2-08热图/fig12.3.tiff", width = 12, height = 12, units = "in", res = 300)
grid.newpage()
pushViewport(viewport(layout = grid.layout(1, 3)))
pushViewport(viewport(layout.pos.col = 1))
LDheatmap(CEUSNP, 
          genetic.distances = CEUDist, 
          color = grey.colors(20), 
          title = 'Pairwise LD', 
          flip = FALSE, 
          newpage = FALSE)
popViewport()
pushViewport(viewport(layout.pos.col = 2))
LDheatmap(CEUSNP, 
          genetic.distances = CEUDist, 
          color = red.colors(20), 
          title = 'Pairwise LD', 
          flip = FALSE, 
          newpage = FALSE)
popViewport()
pushViewport(viewport(layout.pos.col = 3))
LDheatmap(CEUSNP, 
          genetic.distances = CEUDist, 
          color = red.colors(20), 
          SNP.name = c("rs2283092", "rs6979287"), 
          flip = FALSE, 
          newpage = FALSE)
# 修改SNP标签大小
grid.edit(gPath("ldheatmap", "geneMap","SNPnames"), gp = gpar(cex=1))
# 修改标题颜色
grid.edit(gPath("ldheatmap", "heatMap", "title"), 
          gp = gpar(col = "red"),redraw = FALSE)

dev.off()


```

