## 常规直方图 | Regular Histogram

图7.2。

```{r histogram-regular, fig.cap = "江苏省13088名青少年体质指数分布直方图"}
# 加载本章节所需程序包
library(ggpubr)
library(ggsci)
library(cowplot)
library(patchwork)
library(ggridges)
library(scales)
library(paletteer)
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
PE = read.csv("data/0400_PE_data.csv")

pe_hist = 
  ggplot(PE) +
  geom_histogram(aes(bmi),
                 bins = 30,
                 color = gray(1),
                 fill = gray(0.5)) +
  scale_y_continuous(breaks = seq(0, 7000, 1000),
                     limits = c(0, 7000),
                     expand = c(0, 0)) +
  labs(x = "BMI", y = "Frequency") +
  theme_egraphics

ggsave(plot = pe_hist, "figure_tiff/2-04直方图/图8.2.pdf",width= 6, height= 4, units="in")
```

