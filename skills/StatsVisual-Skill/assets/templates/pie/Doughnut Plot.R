## 环形饼图 | Doughnut Plot

图7.5。

```{r pie-doughnut, fig.cap = "2019年美国青少年(10-24岁)前五顺位全死因构成环形图" }

cause_bar = 
  ggplot(leading_cause, aes(x = 3.5, 
                          y = num, 
                          fill = cause)) +
  geom_bar(width = 1, stat = "identity") +
  geom_text(aes(label = paste0(round(perc, 1), "%")),
            position = position_stack(vjust = .5),
            size = 3.5) +
  scale_fill_npg(name = "Cause of Death") +
  xlim(c(1, 4)) +
  coord_polar(theta = "y", start = 0) +
  theme_void()

ggsave(plot = cause_bar, "figure_tiff/2-03饼图/图7.5.pdf",width= 6, height= 4, units="in")
```

