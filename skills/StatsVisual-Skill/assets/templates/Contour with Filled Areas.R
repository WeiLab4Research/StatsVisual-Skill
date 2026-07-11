## 轮廓填充图 | Contour with Filled Areas

续上例，通过对等高线区域进行颜色填充，可得轮廓填充图。相比于等高线图，通过色阶更清晰体现数据的变化(图\@ref(fig:contour-filled))。

```{r contour-filled, fig.cap="黄石公园老忠实泉喷发时间与间歇时间"}

fig12.6 = 
  ggplot(faithfuld, 
       aes(waiting, eruptions, z = density)) +
  geom_contour_filled() +
  labs(x = "Erupitions",
       y = "Waiting") +
  theme(title = element_text(size = 20, colour = 'black'),
        legend.text = element_text(size = 10),
        legend.title = element_text(size = 12),
        axis.text.x = element_text(size = 11, angle = 0),
        axis.text.y = element_text(size = 12),
        axis.title.x = element_text(size = 12),
        axis.title.y = element_text(size = 12),
        panel.background = element_rect(fill = 'white'))

ggsave(plot = fig12.6, "figure_tiff/2-08热图/图12.6.pdf",width= 6, height= 4, units="in")
```

