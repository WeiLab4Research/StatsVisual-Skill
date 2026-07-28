## 碎石图 | Scree Plot

6.3。

```{r scree-plot, fig.cap="学生碎石图"}

# 读取数据
ds_intelligence = read.csv("data/0200_pca_intelligence.csv")
# 主成分分析
results = prcomp(ds_intelligence, scale = TRUE)
# 汇总结果
var_explained_df = data.frame(PC = paste0("PC", 1:ncol(ds_intelligence)),
                              var_explained = (results$sdev)^2)

fig6.3 = 
  ggplot(var_explained_df,
       aes(x = PC, 
       y = var_explained,
       group = 1)) +
  geom_line(size = 0.8) +
  geom_point(size = 3,
             shape = 21,
             color = "black",
             fill = "white") +
  scale_x_discrete(expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0), 
                     limits = c(0, 6)) +
  coord_cartesian(clip = "off") +
  labs(x = "PC", 
       y = "Variance") +
  theme_egraphics

ggsave(plot = fig6.3, "figure_tiff/2-02线图/图6.3.pdf",width= 6, height= 4, units="in")

```

