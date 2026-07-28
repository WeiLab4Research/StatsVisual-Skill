## 对称直方图 | Shadow Histogram

图8.6。

```{r histogram-shadow, fig.cap = "江苏省13088名青少年按学校等级分组身高对称直方图"}

shad_hist = 
  ggplot() +
  # 提取男生子集，并对频率密度进行负数变化
  geom_histogram(data = subset(PE, PE$gender == "Male"),
                 aes(height_cm,
                     y = -after_stat(density),
                     fill = school_grade),
                 bins = 30,
                 position = "identity",
                 color = "white",
                 alpha = 0.5) +
  # 提取女生子集，
  geom_histogram(data = subset(PE, PE$gender == "Female"),
                 aes(x = height_cm,
                     y = after_stat(density),
                     fill = school_grade),
                 bins = 30,
                 position = "identity",
                 color = "white",
                 alpha = 0.5) +
  # 增加特定标签说明
  annotate(geom = "text", 
           x = c(186, 187),
           y = c(0.01,-0.015),
           label = c("Girls", "Boys")) +
  coord_cartesian(xlim = c(90, 200),
                  ylim = c(-0.08, 0.08)) +
  # 修改y轴标签内容
  scale_y_continuous(expand = c(0, 0), 
                     labels = c(0.08, 0.04, 0, 0.04, 0.08)) +
  scale_x_continuous(expand = c(0, 0)) +
  labs(x = "Height(cm)", 
       y = "Density", 
       fill = "School Grade") +
  scale_fill_nejm() +
  theme_egraphics +
  theme(legend.position = "top")

ggsave(plot = shad_hist, "figure_tiff/2-04直方图/图8.6.pdf",width= 6, height= 4, units="in")
```
 
