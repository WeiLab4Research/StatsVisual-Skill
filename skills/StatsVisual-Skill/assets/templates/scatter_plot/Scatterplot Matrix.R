## 散点图矩阵 | Scatterplot Matrix

11.3

```{r scatter-matrix, fig.height = 6, fig.cap = "企鹅喙长度、宽度、短翼长度、体重散点图矩阵"}

# 读取数据
penguin = read.csv("data/0710_penguin.csv")

fig11.3 = 
  ggpairs(penguin,
        columns = c("bill_length_mm",
                    "bill_depth_mm",
                    "flipper_length_mm",
                    "body_mass_g"),
        columnLabels = c("Bill Length(mm)",
                         "Bill Depth(mm)",
                         "Flipper Length(mm)",
                         "Body Mass(g)"),
        lower = list(continuous = wrap("points",
                                       alpha = 0.5,
                                       color = "#0072B5FF",
                                       size = 1)),
        diag = list(continuous = wrap("barDiag", 
                                      color = "white", 
                                      fill = "#E18727FF")),
        upper = list(continuous = wrap("smooth", 
                                       size = 1, 
                                       color = "#20854EFF"))) 

ggsave(plot = fig11.3, "figure_tiff/2-07散点图/图11.3.pdf",width= 6, height= 6, units="in")

```

