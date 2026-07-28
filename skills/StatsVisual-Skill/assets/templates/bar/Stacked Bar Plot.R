## 堆积条形图 | Stacked Bar

5.4
```{r stacked-bar, fig.width=8, fig.cap="不同级别教授中性别构成情况"}

# 读取数据
salaries = carData::Salaries
salaries$rank = factor(salaries$rank,
                     level = c("AsstProf", "AssocProf", "Prof"), 
                     labels = c("Assistant", "Associate", "Full"), 
                     order = TRUE)


# 绘制常规的堆叠图
# 通过position = "stack"，实现频数堆叠效果
stacked_bar = ggplot(salaries, 
                     aes(x = rank, 
                         fill = sex)) +
  geom_bar(position = "stack", 
           width = 0.6) +
  scale_x_discrete(expand = c(0, 0.5)) +
  scale_y_continuous(limits = c(0, 300), 
                     expand = c(0, 0)) +
  scale_fill_manual(values = c("#7876B1FF", "#6F99ADFF")) +
  labs(x = "Professor Rank", 
       y = "Count", 
       fill = "Sex") +
  theme_egraphics +
  # 在采用默认主题（theme_egraphics）的基础上，通过theme()函数将图例设至上方
  theme(legend.position = "top")


stacked_bar_fill = ggplot(salaries, 
                          aes(x = rank,
                              fill = sex)) +
  # 通过position = "fill"，实现构成比的堆叠效果
  geom_bar(position = "fill",
           width = 0.6) +
  scale_x_discrete(expand = c(0, 0.5)) +
  scale_y_continuous(limits = c(0, 1), 
                     expand = c(0, 0)) +
  scale_fill_manual(values = c("#7876B1FF", "#6F99ADFF")) +
  labs(x = "Professor Rank",
       y = "Proportion", 
       fill = "Sex") +
  theme_egraphics +
  theme(legend.position = "top")

# 拼图并共享图例和x轴名称
 fig5.4 = 
   stacked_bar +
  stacked_bar_fill+
  plot_layout(nrow = 1, 
              axis_titles = "collect_x",
              guides = "collect") & theme(legend.position = 'top')

ggsave(plot = fig5.4, "figure_tiff/2-01条形图/图5.4.pdf",width= 8, height= 4, units="in")

```

