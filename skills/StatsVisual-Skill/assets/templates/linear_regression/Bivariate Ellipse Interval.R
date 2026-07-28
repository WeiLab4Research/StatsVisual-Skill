## 双变量参考值椭圆 | Bivariabe Ellipse Interval

17.5
```{r bivariable-ref,fig.width = 6, fig.height = 4, fig.cap = "500名小学女生身高体重回归参考值椭圆"}

# 读取数据
ds_height = read.csv("data/0600_checkup_data.csv", stringsAsFactors = TRUE)
# 因原数据集样本量过大，因此重抽样以显示出可信区间
ds_height = ds_height %>% 
  filter(gender == "Female",
         school_grade == "Elementary School")
set.seed(2022)
ds_sampling = ds_height[sample(1:nrow(ds_height), size = 500), ]

fig17.5 = 
  ggplot(ds_sampling, aes(weight_kg, height_cm)) +
  geom_point(size = 1.5, 
             alpha = 0.8,
             color = "#BC3C29FF") +
  geom_smooth(method = 'lm', 
              fill = NA,
              color = "#0072B5FF") +
  stat_ellipse(geom = "polygon",
               level = 0.95,
               fill = "#0072B5FF",
               alpha = 0.5) +
  stat_poly_eq(formula = y ~ x, eq.with.lhs=FALSE,
               aes(label = paste("hat(italic(Y))","~`=`~", 
                                 ..eq.label.., "`,`", ..rr.label.., 
                                 sep = "~")),
               label.y.npc = "top", 
               label.x.npc = "left",
               size = 4.5,
               parse = TRUE) + 
  scale_y_continuous(expand = c(0, 0),
                     limits = c(100, 170),
                     breaks = seq(110, 170, 10)) +
  scale_x_continuous(expand = c(0, 0),
                     limits = c(0, 80),
                     breaks = seq(0, 80, 20)) +
  labs(x = "Weight (kg)",
       y = "Height (cm)") +
  theme_egraphics

ggsave(plot = fig17.5, "figure_tiff/2-13线性回归/图17.5.pdf",width = 6, height= 4, units="in")
```

