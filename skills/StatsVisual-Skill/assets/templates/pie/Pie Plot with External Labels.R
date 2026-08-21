## 外围标签饼图 | Pie Plot

图7.4。

```{r pie-cancer, fig.width=8,fig.height=6,fig.cap="2020年各国癌症新发病例数" }

# 读取数据
world_cancer = read.csv("data/0300_ds_cancer_pie.csv")

# 制作各个国家占比的标签
world_cancer_label = world_cancer  %>% 
   mutate(csum = rev(cumsum(rev(value))), 
          pos = value/2 + lead(csum, 1),
          pos = if_else(is.na(pos), value/2, pos),
          percent = paste0(round(100*value/sum(value), 2), "%"),
          labels = paste(country, percent, sep = " "))

world_pie = ggplot(world_cancer, 
       aes(x = "", y = value,
           fill = fct_inorder(country))) +
  geom_bar(stat = "identity",
           width = 0.5,
           color = "white",
           show.legend = F) +
  # 添加标签
  geom_label_repel(data = world_cancer_label,
                   aes(x = 1.25,
                       y = pos, 
                       label = labels),
                   size = 3, 
                   nudge_x = 0.5,
                   show.legend = F,
                   segment.colour = "grey60") +
  scale_fill_brewer(palette = "Set3") +
  coord_polar(theta = "y", start = 0) +
  theme_void()

ggsave(plot = world_pie, "figure_tiff/2-03饼图/图7.4.pdf",width= 6, height= 4, units="in")
```

