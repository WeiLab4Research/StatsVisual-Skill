## 极坐标条形图 | Bar on Polar

5.8

```{r round-bar, fig.width=8, fig.height=8, fig.cap="新冠Delta和Omicron毒株感染者临床症状差异对比"}

delta_vaccine = read.csv(file ="data/0100_polar_plot.csv")
delta_vaccine_label = read.csv(file ="data/0100_polar_label.csv")

fig5.8 = 
  ggplot(delta_vaccine) +
  geom_bar(aes(x = as.factor(id), y = value, fill = label),
           stat = "identity",
           position = "dodge",
           alpha =  1,
           width = 0.5) +
  # 为两种不同变异株设置不同的填充色
  scale_fill_manual(values = c("lightblue", "navyblue")) +
  scale_y_continuous(limits = c(-50,120),
                     breaks = seq(0, 100, 25)) +
  # 根据delta_vaccine_label中预设值，控制标签位置和角度
  geom_text(data = delta_vaccine_label[17:32, ],
            aes(x = id - 0.05, 
                y = maxvalue + 10,
                label = name,
                angle = angel + 88),
            color = "grey30",
            hjust = 0.1,
            fontface = "bold",
            alpha = 1,
            size = 3,
            inherit.aes = FALSE) +
  # 在适当的地方添加发病率标尺
  annotate(geom = "text", 
           x = 0, 
           y = seq(0, 100, 25) + 4, 
           label = c("0", "25", "50", "75", "100") , 
           color = "grey30", 
           size = 5 ,
           angle = 0,
           fontface = "bold", 
           hjust = 1) +
  annotate(geom = "text", 
           x = 0, 
           y = -20, 
           label = "Prevalence (%)" , 
           color = "grey30",
           size = 4 ,
           angle = 0, 
           fontface = "bold",
           hjust = 0.5) +
  geom_text(data = delta_vaccine_label[1:16, ],
            aes(x= id - 0.12,
                y = maxvalue + 10,
                label = name,
                angle = angel-95),
            hjust = 0.8,
            color = "grey30",
            fontface = "bold",
            alpha = 1,
            size = 3,
            inherit.aes = FALSE) +
  # 极坐标旋转
  coord_polar(direction = -1) +
  # 为了美观，进行少许定制化的样主题背景修改
  theme_minimal() +
  theme(legend.title = element_blank(),
        legend.position = "inside",
        legend.position.inside = c(0.51, 0.50),
        legend.key.size = unit(0.8, 'cm'),
        legend.text = element_text(size = 11),
        axis.text = element_blank(),
        axis.title = element_blank(),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.minor.y = element_blank(),
        plot.margin = unit(rep(-1, 4), "cm") )

  
ggsave(plot = fig5.8, "figure_tiff/2-01条形图/图5.8.pdf",width= 8, height= 8, units="in")

```

# 线图 | Line Plot

