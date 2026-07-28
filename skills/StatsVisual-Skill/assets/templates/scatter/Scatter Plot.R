## 常规散点图

本例随机抽取500名江苏青少年身高和体重数据，以身高为自变量，体重为因变量，绘制散点图(图\@ref(fig:scatter-basic))。

```{r scatter-basic, fig.cap="江苏省500名青少年身高体重散点图"}

# 加载本章节所需程序包
library(tidyverse)
library(ggpubr)
library(ggsci)
library(cowplot)
library(GGally)
library(ggExtra)
library(ggpointdensity)
library(graphics)
library(ggrepel)
library(viridis)

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
PE = read.csv("data/0600_checkup_data.csv")
# 因原数据集样本量过大，因此重抽样以显示出可信区间
set.seed(2022)
PE_sampling = PE[sample(1:nrow(PE), size = 500), ]

fig11.2 = 
  ggplot(PE_sampling) +
  geom_point(aes(height_cm, weight_kg)) +
  scale_x_continuous(limits = c(120, 180),
                     expand = c(0, 0)) +
  scale_y_continuous(limits = c(20, 100),
                     expand = c(0, 0)) +
  labs(y = "Weight(kg)", 
       x = "Height(cm)") +
  theme_egraphics

ggsave(plot = fig11.2, "figure_tiff/2-07散点图/图11.2.pdf",width= 6, height= 4, units="in")

```

