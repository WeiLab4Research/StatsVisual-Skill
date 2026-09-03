## 常规点图

9.2。

```{r cleveland-basic, fig.height=8, fig.cap = "56个元素和儿童认知得分的关联性"}

# 加载本章节所需程序包
library(ggpubr)
library(ggsci)
library(ggforce)
library(ggnewscale)
library(ggrepel)
library(ggbreak)

# 设置图形基本背景
theme_egraphics = 
  theme_pubr() + 
  theme(axis.title.y = element_text(margin = margin(t = 0, r = 10, 
                                                    b = 0, l = 0)),
        axis.title.x = element_text(margin = margin(t = 10, r = 0, 
                                                    b = 0, l = 0)),
        axis.title = element_text(size = 13, face = "bold"),
        axis.line = element_line(linewidth = 0.6, color = "black"),
        axis.ticks = element_line(size = 0.3),
        axis.ticks.length = unit(.15, "cm"),
        axis.text  = element_text(size = 10),
        plot.margin = margin(.5, .5, .5, .5, "cm"))

# 读取数据
bayley = read.csv("data/0500_cleveland.csv")
set.seed(2022)
bayley  = bayley[sample(1:nrow(bayley), size = 30, replace = FALSE), ]

bayley_dot = 
  ggplot(bayley, 
       aes(x = coef_adjusted,
           y = reorder(element, coef_adjusted))) +
  geom_point(size = 3,
             color = "#0072B5FF") +
  scale_x_continuous(limits = c(-1, 2),
                     expand = c(0, 0)) +
  scale_y_discrete(expand = c(0, 0.2)) +
  labs(x = "Association Coefficient \non Cognitive Score", 
       y = "Urine Element") +
  theme_egraphics +
  theme(panel.grid.major.y = element_line(colour = "grey50", 
                                          linetype = "dashed"))

ggsave(plot = bayley_dot, "figure_tiff/2-05点图/图9.2.pdf",width= 6, height= 8, units="in")
```

