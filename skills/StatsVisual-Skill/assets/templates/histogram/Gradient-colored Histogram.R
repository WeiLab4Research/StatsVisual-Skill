## 变色直方图 | Colored Histogram

图8.4。

```{r histogram-makeup, fig.cap = "江苏省13088名青少年体质指数分布直方图"}

# 构建色谱
colors = scales::seq_gradient_pal("white", "red")(seq(0, 1, length.out = 30))

color_hist = 
  ggplot(PE) +
  geom_histogram(aes(bmi),
                 bins = 30,
                 color = gray(1),
                 fill = colors) +
  scale_y_continuous(breaks = seq(0, 7000, 1000),
                     limits = c(0, 7000),
                     expand = c(0, 0)) +
  labs(x = "BMI", y = "Frequency") +
  theme_egraphics

ggsave(plot = color_hist, "figure_tiff/2-04直方图/图8.4.pdf",width= 6, height= 4, units="in")
```

