## 哑铃图 | Dunbbell Plot

9.5。

```{r cleveland-dumbbell, fig.height=8, fig.cap = "56个元素和儿童认知得分的关联性(协变量校正前后哑铃图)"}

# 数据子集提取
ds_dum = bayley[, c("element", "coef_adjusted", "coef_unadjusted")]
# 数据长宽格式转换
ds_melt = reshape2::melt(ds_dum, id.vars = "element")

fig9.5 = 
 ggplot(ds_melt, aes(x = value, 
                    y = reorder(element, value))) +
  geom_line(aes(group = element)) +
  geom_point(aes(color = variable), 
             size = 3) +
  scale_x_continuous(limits = c(-2, 3),
                     expand = c(0, 0)) +
  scale_y_discrete(expand = c(0, 0.2)) +
  scale_color_nejm(labels = c("Adjusted", "Unadjusted")) +
  labs(x = "Association Coefficient \non Cognitive Score",
       y = "Urine Element") +
  theme_egraphics +
  theme(panel.grid.major.y = element_line(colour = "grey90",
                                          linetype = "solid",
                                          size = 0.5),
       legend.position = "top",
       legend.title = element_blank())

ggsave(plot = fig9.5, "figure_tiff/2-05点图/图9.5.pdf",width= 6, height= 8, units="in")

```

