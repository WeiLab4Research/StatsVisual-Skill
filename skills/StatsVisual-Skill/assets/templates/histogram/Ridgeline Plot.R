## 峰峦图 | Ridges Plot

8.9。

```{r line-ridges, fig.cap = "江苏省13088名青少年按学校等级分组身高分布峰峦图"}

ridge_hist = 
  ggplot(PE, aes(x = height_cm, 
               y = school_grade,
               fill = 0.5 - abs(0.5 - after_stat(ecdf)))) +
  #ggridges包中stat_density_ridges函数用于绘制峰峦图
  stat_density_ridges(geom = "density_ridges_gradient",
                      calc_ecdf = TRUE,
                      lwd = 1,
                      color = "white") +
  scale_fill_gradient(low = "#FFCCCC", 
                      high = "#FF9999") +
  labs(x = "Height(cm)",
       y = "School Grade") +
  theme_ridges() +
  theme(legend.position = "none")

ggsave(plot = ridge_hist, "figure_tiff/2-04直方图/图8.9.pdf",width= 6, height= 4, units="in")
```

