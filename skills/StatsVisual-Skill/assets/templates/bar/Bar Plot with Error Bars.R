## 误差线条形图 |  with Error Bar

5.6
```{r bar-error, fig.cap="鸢尾花形态数据的均值及变异"}

# 读取数据
iris_sum = read.csv(file ="data/0100_bar_error.csv")

fig5.6 = 
  ggplot(iris_sum, 
       aes(x = attribute, y = mean, fill = species)) +
  geom_bar(stat = "identity", 
           position = position_dodge(),
           color = "white", 
           width = 0.6) +
  # 双侧的误差线，误差线为标准差
  geom_errorbar(aes(ymin = mean - sd, 
                    ymax = mean + sd),
                position = position_dodge(0.6),
                width = 0.2) +
  scale_fill_manual(values =  c("#6F99ADFF", "#7876B1FF", "#20854EFF")) +
  scale_x_discrete(expand = c(0, 0.35)) +
  scale_y_continuous(breaks = seq(0, 8, 1), 
                     limits = c(0, 8),
                     expand = c(0, 0)) +
  labs(x = "Attribute", 
       y = "Mean",
       fill = "Species") +
  theme_egraphics +
  theme(legend.position = "top")

ggsave(plot = fig5.6, "figure_tiff/2-01条形图/图5.6.pdf",width= 6, height= 4, units="in")


```

