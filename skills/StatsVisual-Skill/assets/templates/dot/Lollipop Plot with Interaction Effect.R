## 棒棒糖图叠加交互效应 | Lollipop Plot with Interaciton Effect

9.4。

```{r cleveland-lollipop2, fig.width=10, fig.cap="棒棒糖图叠加交互效应"}

# 读入数据
element_data = read.csv("data/0500_lollipop.csv")
element_data$element<- factor(element_data$element, 
                              levels = element_data$element)

# 提取相关系数为负的子集，用于后期棒棒糖头的着色
element_negative = subset(element_data, element_data$motor < 0)
element_negative$motor = abs(element_negative$motor)
# 提取相关系数为正的子集，用于后期棒棒糖头的着色
element_positive  = subset(element_data, element_data$motor > 0)

# 构建具有交互作用元素数据集
mozheng = data.frame(x=c("47Ti", "66Zn", "93Nb",
                         "111Cd", "118Sn", "121Sb", "133Cs"),
                    y=c(0, 0.8, 0, 0, 0.1, 0.35, 0),
                    type = rep(c('cubic', 'quadratic'), c(3, 4)),
                    point = c ('end', 'control', 'end',
                               'end', 'control', 'control', 'end'))

# 构建具有交互作用元素数据集
mofu1 = data.frame(x = c("9Be", "75As", "133Cs",
                         "47Ti", "89Y", "141Pr"),
                  y = c(0, 1.5, 0, 0, 1.5, 0),
                  type = rep(c('cubic', 'quadratic'), c(3, 3)),
                  point = c ('end', 'control', 'end',
                             'end', 'control', 'end'))

mofu2 = data.frame(x = c("121Sb", "133Cs", "137Ba"),
                   y = c(0, 0.35, 0),
                   type = rep(c('cubic', 'quadratic'), c(3, 3)),
                   point = c ('end', 'control', 'end'))


fig9.4 = 
  ggplot(element_data, aes(element, motor)) +
  geom_segment(aes(x = element, xend = element, 
                   y = 0, yend = abs(motor)),
               size = 1.2,
               alpha = 0.4 ,
               color = "black") +
  geom_point(data = element_negative, size = 4, color = "#0072B5FF") +
  geom_point(data = element_positive, size = 4, color = "#BC3C29FF") +
  # geom_bezier函数用于绘制曲线
  geom_bezier(data = mozheng,
              aes(x = x, y = y, group = type),
              size = 1.2,
              alpha = 0.6,
              color = "#E18727FF") + 
  geom_bezier(data = mofu1,
              aes(x = x, y = y, group = type),
              size = 1.2,
              alpha = 0.6,
              color = "#E18727FF") +
  geom_bezier(data = mofu2,
              aes(x = x, y = y, group = type),
              size = 1.2,
              alpha = 0.45,
              color =  "#E18727FF") +
  scale_y_continuous(expand = c(0, 0),
                    breaks = seq(0, 1.5, 0.3),
                    limits = c(0, 1.5)) +
  labs(x = "Element", 
       y = "b on Motor Composite Score") +
  theme_egraphics +
  theme(axis.text.x = element_text(size = 7.5,
                                   angle = 45,
                                   hjust = 1))

ggsave(plot = fig9.4, "figure_tiff/2-05点图/图9.4.pdf",width= 10, height= 4, units="in")
```

