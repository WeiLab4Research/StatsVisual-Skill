## 平滑散点图 | Smooth Scatter Plot

11.6。

```{r scatter-smooth, fig.height=6, fig.cap="江苏省青少年身高体重平滑散点图"}

fig11.6 = 
  ggplot(PE, aes(height_cm, weight_kg)) +
  geom_pointdensity(adjust = 0.1) +
  scale_x_continuous(limits = c(90, 210),
                     expand = c(0, 0)) +
  scale_y_continuous(limits = c(0, 120),
                     expand = c(0, 0)) +
  scale_color_gradient(low = "lightblue",
                       high = "darkblue") +
  labs(x = "Height(cm)", y = "Weight(kg)") +
  theme_egraphics 

ggsave(plot = fig11.6, "figure_tiff/2-07散点图/图11.6.pdf",width= 6, height= 6, units="in")
```

