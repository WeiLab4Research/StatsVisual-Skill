## 点线图 | Line Plot with point

图6.2。

```{r line-point, fig.cap="三种模型AUC比较"}

# 加载本章节所需程序包
library(ggpubr)
library(ggsci)
library(cowplot)
library(zoo)
library(forecast)
library(ggstream)
library(RColorBrewer)
library(ggradar)
# 解决字体显示异常问题
library(showtext)
showtext_auto()

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
model_auc = read.csv("data/0200_ds_model.csv")

fig6.2 = ggplot(model_auc,
       aes(time, value, color = group)) +
  geom_point(size = 2,
             show.legend = F) +
  geom_line() +
  scale_color_nejm() +
  scale_y_continuous(limits = c(0.55, 0.8),
                     expand = c(0, 0)) +
  scale_x_continuous(limits = c(10, 80),
                     breaks = seq(10, 80, 10),
                     expand = c(0, 0)) +
  coord_cartesian(clip = "off") +
  labs(x = "Proportion of the training set size to the primary cohort A (%)",
       y = "AUC",
       color = "") +
  theme_egraphics +
  theme(legend.position = "inside",
        legend.position.inside = c(0.8, 0.25))

ggsave(plot = fig6.2, "figure_tiff/2-02线图/图6.2.pdf",width= 6, height= 4, units="in")

```

