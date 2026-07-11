## 等高线图 | Contour Line Plot

12.5。

```{r contour-line, fig.width = 6, fig.height = 4, fig.cap="黄石公园老忠实泉喷发时间与间歇时间"}

fig12.5 = 
  ggplot(faithful, aes(x = eruptions,
                     y = waiting)) +
  stat_density2d(aes(colour = after_stat(level))) +
  geom_point() +
  scale_color_viridis_c() +
  labs(x = "Erupitions",
       y = "Waiting") +
  theme_egraphics +
  theme(legend.position = "right")

ggsave(plot = fig12.5, "figure_tiff/2-08热图/图12.5.pdf",width= 6, height= 4, units="in")

```

