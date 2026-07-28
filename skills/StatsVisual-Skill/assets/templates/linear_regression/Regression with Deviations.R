## 直线回归误差线图 | Regression with Deviations

17.6。

```{r reg-fit-deviation, fig.cap="学生学业成绩与接受餐补学生比例回归误差线图"}

 fig17.6 = ggscatter(API, 
          x = "meals", 
          y = "api00",
          add = "reg.line",
          color = "#0072B5FF",
          alpha = 0.8,
          conf.int = TRUE,
          fullrange = FALSE,
          conf.int.level = 0.95,
          add.params = list(color = "black", 
                            size = 1,
                            fill = "#0072B5FF"),
          xlab = "Proportion Accepted Free Meals (%)",
          ylab = "Academic Performance Index") +
  stat_fit_deviations(formula = y ~ x, alpha = 0.5) +
  scale_y_continuous(expand = c(0, 0), 
                     limits = c(300, 1000), 
                     breaks = seq(300, 1000, 100)) +
  scale_x_continuous(expand = c(0, 0), 
                     limits = c(0, 100),
                     breaks = seq(0, 100, 20)) +
  stat_poly_eq(formula = y ~ x, eq.with.lhs=FALSE,
               aes(label = paste("hat(italic(Y))","~`=`~", 
                                 ..eq.label.., "`,`", ..rr.label.., 
                                 sep = "~")),
               label.y.npc = "top", 
               label.x.npc = "right",
               size = 6,
               parse = TRUE) + 
  coord_cartesian(clip = "off") +
  theme_egraphics

ggsave(plot = fig17.6, "figure_tiff/2-13线性回归/图17.6.pdf",width = 6, height= 4, units="in")
```

