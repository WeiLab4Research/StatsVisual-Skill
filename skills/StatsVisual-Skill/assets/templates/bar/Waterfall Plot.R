## 瀑布图 | Waterfall Plot

5.7

```{r waterfall-ind, fig.cap="紫杉醇联合吉西他滨治疗未经治疗局部晚期胰腺癌的疗效"}

# 读取数据
therapy = read.csv(file ="data/0100_waterfall_negative.csv")

# 根据较之基线变化值的正负附以不同颜色
# (change > 0)表达式将判断变化是否大于0
fig5.7 = 
  ggplot(therapy,
       aes(x = id,
           y = change, 
           fill = (change > 0))) +
  geom_bar(stat = "identity",
           width = 0.8) +
  scale_y_continuous(breaks = seq(-100, 100, 20),
                     limits = c(-100, 100),
                     expand = c(0, 0)) +
  scale_x_continuous(breaks = seq(0, 105, 10), 
                     expand = c(0, 0.4)) +
  scale_fill_nejm() +
  labs(x = "No. of Patients (n=101)",
       y = "Maximum change from baseline (%)") +
  theme_egraphics

ggsave(plot = fig5.7, "figure_tiff/2-01条形图/图5.7.pdf",width= 6, height= 4, units="in")

```

除此之外，瀑布图还有首尾相接的台阶形式和落差形式，留给读者自行探索。

