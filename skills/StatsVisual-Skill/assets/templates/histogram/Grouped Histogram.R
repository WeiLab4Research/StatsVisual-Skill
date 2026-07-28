## 分组直方图 | Stratified Histogram

图8.5。
 
```{r histgram-group, fig.cap = "江苏省13088名青少年按学校等级分组身高分布直方图"}

p1 = ggplot(PE) +
  geom_histogram(aes(x = height_cm,
                     y = ..density..,
                     fill = school_grade),
                 bins = 30,
                 color = "white",
                 position = "identity",
                 alpha = 0.5) +
  coord_cartesian(xlim = c(90, 200),
                  ylim = c(0, 0.06)) +
  scale_y_continuous(expand = c(0, 0)) +
  scale_x_continuous(expand = c(0, 0)) +
  scale_fill_nejm() +
  labs(x = "Height (cm)", 
       y = "Density",
       fill = "School Grade") +
  theme_egraphics +
  theme(legend.position = "top")

p2 = ggplot(PE) +
  geom_histogram(aes(x = height_cm,
                     y = after_stat(density),
                     fill = school_grade),
                 bins = 30,
                 color = "white",
                 position = "dodge",
                 alpha = 0.5) +
  coord_cartesian(xlim = c(90, 200),
                  ylim = c(0, 0.06)) +
  scale_y_continuous(expand = c(0, 0)) +
  scale_x_continuous(expand = c(0, 0)) +
  scale_fill_nejm() +
  labs(x = "Height (cm)", 
       y = "Density",
       fill = "School Grade") +
  theme_egraphics +
  theme(legend.position = 'top')

# 设置共用图例和X轴名称
color_all = 
  p1 + p2 +
  plot_layout(nrow = 1, 
              axis_titles = "collect_x",
              guides = "collect") & theme(legend.position = 'top')


ggsave(plot = color_all, "figure_tiff/2-04直方图/图8.5.pdf",width= 6, height= 4, units="in")
```

