## 常规箱线图 | Regular Boxplot

10.3。

```{r box-regular, fig.cap = "江苏省青少年身高箱线图"}

# 加载本章节所需程序包
library(ggpubr)
library(ggsci)
library(cowplot)
library(lvplot)
library(paletteer)
library(ggbeeswarm)
library(patchwork)
library(ggdist)
library(PupillometryR)

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
# 提取出女性数据
PE_female = subset(PE, PE$gender == "Female")

fig10.3 = 
  ggplot(PE, aes(y = height_cm, x = "")) +
  stat_boxplot(geom = "errorbar", width = 0.2) +
  geom_boxplot(alpha = 0.5, 
               width = 0.5,
               outlier.colour = "red",
               outlier.shape = 1) +
  labs(x = "Overall",
       y = "Height (cm)") +
  scale_y_continuous(limits = c(70, 200), 
                     n.breaks = 5,
                     expand = c(0, 0)) +
  theme_egraphics +
  theme(aspect.ratio = 1.6) 

ggsave(plot = fig10.3, "figure_tiff/2-06箱线图/图10.3.pdf",width= 6, height= 4, units="in")

```

