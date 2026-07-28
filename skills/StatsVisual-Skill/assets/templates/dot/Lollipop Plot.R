## 棒棒糖图 | Lollipop Plot

9.3。

```{r cleveland-lollipop, fig.height=8, fig.cap = "56个元素和儿童认知得分的关联性(棒棒糖图)"}

# 筛选回归系数有意义的元素
sig = subset(bayley, p <= 0.05)

lolipop = 
  ggplot(bayley, aes(x = coef_adjusted, 
                y = reorder(element, coef_adjusted))) +
  geom_segment(aes(yend = element),
               xend = 0, 
               colour = "grey50") +
  geom_vline(xintercept = 0, linetype = "dashed") +
  geom_point(size = 3, 
             color = "#0072B5FF") +
  geom_point(data = sig, size = 3, 
             color = "#BC3C29FF") +
  scale_x_continuous(limits = c(-1, 2),
                     expand = c(0, 0)) +
  scale_y_discrete(expand = c(0, 0.2)) +
  labs(x = "Association Coefficient \non Cognitive Score", 
       y = "Urine Element") +
  theme_egraphics 


ggsave(plot = lolipop, "figure_tiff/2-05点图/图9.3.pdf",width= 6, height= 8, units="in")

```

