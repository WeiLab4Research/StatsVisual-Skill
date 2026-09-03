## 爆炸片饼图 | Exploding Pie Plot

图7.7。

```{r pie-exploded, fig.cap="2019年美国青少年(10-24岁)前五顺位全死因构成" }

# 计算各个死因构成比并排序
leading_cause$fraction = leading_cause$num/sum(leading_cause$num)
leading_cause = leading_cause[order(leading_cause$fraction), ]

# 生成爆炸片饼图数据
exploded = leading_cause %>%
  mutate(ymax = cumsum(fraction) - 0.01,
         ymin = c(0,head(ymax, n = -1)) + 0.01,
         x1 = length(unique(cause)) - (1:nrow(leading_cause)) * 0.5 + 1,
         x2 = length(unique(cause)) - (1:nrow(leading_cause)) * 0.5 + 2)
exploded$cause = factor(exploded$cause,
                        levels = c("Accidents",
                                   "Suicide",
                                   "Homicide",
                                   "Cancer", 
                                   "Heart disease", 
                                   "Others"))

explode_pie = 
  ggplot()+
  geom_rect(data = exploded,
            aes(fill = cause,
                ymax = ymax,
                ymin = ymin, 
                xmax = x1, 
                xmin=0),
            color = "white")+
  scale_fill_npg(name = "Cause of Death") +
  ylim(0, 1)+
  xlim(c(0, 3 + length(unique(leading_cause))))+
  coord_polar(theta="y",
              direction = -1) +
  theme_void()

ggsave(plot = explode_pie , "figure_tiff/2-03饼图/图7.7.pdf",width= 6, height= 4, units="in")
```

