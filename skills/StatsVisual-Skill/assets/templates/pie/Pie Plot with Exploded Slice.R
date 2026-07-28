## 吃豆饼图 | Pie Plot with Exploded Slice

图7.6。

```{r pie-explode, fig.cap="2019年美国青少年(10-24岁)前五顺位全死因构成"}

# 定义吃豆图的位置控制参数
leading_cause$focus = c(0, 0.2, 0, 0, 0, 0)

explode_bar = 
  ggplot(leading_cause) +
  geom_arc_bar(aes(
  x0 = 0, y0 = 0, r0 = 0, r = 1, amount = num,
  fill = cause,  explode = focus), 
  stat = 'pie') +
  coord_fixed() +
  theme_no_axes() +
  scale_fill_npg(name = "Cause of Death")+
  theme_void()

ggsave(plot = explode_bar, "figure_tiff/2-03饼图/图7.6.pdf",width= 6, height= 4, units="in")
```

