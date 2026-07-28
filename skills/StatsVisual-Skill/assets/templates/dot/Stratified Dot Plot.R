## 分组点图 | Stratified Dot Plot

9.6。

```{r strata-dot, fig.height=8, fig.cap = "不同品牌汽车的燃油效率"}

# 读入数据
ds_carbrand = mtcars
ds_carbrand$cyl = as.factor(ds_carbrand$cyl)
# 新增一列数据为汽车品牌
ds_carbrand$name = rownames(ds_carbrand)

fig9.6 =
  ggdotchart(
  ds_carbrand,
  x = "name",
  y = "mpg",
  size = 2.5,
  group = "cyl",
  color = "cyl",
  rotate = TRUE,
  sorting = "descending",
  ggtheme = theme_pubr()) +
  scale_y_continuous(limits = c(0, 40),
                     expand = c(0, 0)) +
  scale_x_discrete(expand = c(0, 0.2)) +
  scale_color_nejm() +
  labs(x = "Car Brand",
       y = "Miles per Gallon (mpg)",
       color = "N Cylinder") +
  theme_egraphics +
  theme(panel.grid.major.y = element_line(colour = "grey90",
                                          linetype = "solid",
                                          size = 0.5))

ggsave(plot = fig9.6, "figure_tiff/2-05点图/图9.6.pdf",width= 6, height= 8, units="in")


```

9.7。

```{r dot-pm, fig.height=8, fig.width=6, fig.cap="2018年中国部分省份年均PM2.5、PM10浓度"}

# 读入数据
ds_pm10 = read.csv("data/0500_pm10dot.csv")
# 按照PM10浓度排序
ds_pm10 = ds_pm10[order(ds_pm10$year_pm25), ]
# 确定因子顺序
ds_pm10$province = factor(ds_pm10$province, levels = ds_pm10$province)


fig9.7 = 
  ggplot(ds_pm10) +
  geom_point(aes(province, year_pm25, color = year_pm25),  size = 3) +
  scale_color_gradient(low = "#F4FAFEFF",
                       high = "#273871FF", 
                       name = expression(PM[2.5])) +
  new_scale_color() +
  geom_point(aes(province, year_pm10, color = year_pm10), 
             shape = 17, size = 3) +
  scale_color_gradient(low = "#EBEAF4FF",
                       high = "#AF0040FF",
                       name = expression(PM[10])) +
  geom_hline(yintercept = c(35, 70), 
             linetype = "dashed", 
             color = "grey60") +
  scale_y_continuous(limits = c(0, 100), 
                     breaks = seq(0, 100, 20),
                     expand = c(0, 0)) +
  labs(x = "Province",
       y = expression(bold(paste(Value, " (", mu, g, "/", m^3, ")", 
                                            sep = "")))) +
  coord_flip() +
  theme_egraphics +
  theme(legend.position = "right",
        panel.grid.major.y = element_line(colour = "grey90", 
                                          linetype = "dashed"))

ggsave(plot = fig9.7, "figure_tiff/2-05点图/图9.7.pdf",width= 6, height= 8, units="in")

```

