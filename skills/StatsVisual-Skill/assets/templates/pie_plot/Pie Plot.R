## 常规饼图 | Pie Plot

图7.2。

```{r pie-regular, fig.cap="2019年美国青少年(10-24岁)前五顺位全死因构成饼图" }

# 加载本章节所需程序包
library(ggpubr)
library(ggsci)
library(cowplot)
library(tidyverse)
library(ggrepel)
library(ggforce)
library(export)
library(paletteer)
library(graphics)

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
leading_cause = read.csv("data/0300_leading_cause.csv")
# 定义因子顺序
leading_cause$cause = factor(leading_cause$cause,
                             levels = c("Accidents", 
                                        "Suicide",
                                        "Homicide",
                                        "Cancer", 
                                        "Heart disease", 
                                        "Others"))

leading_pie = 
  ggplot(leading_cause, aes(x = "", y = perc, fill = cause)) +
  geom_bar(width = 0.3, stat = "identity") +
  geom_text(aes(label = paste0(round(perc, 1), "%")),
            position = position_stack(vjust = 0.5),
            size = 3.5) +
  scale_fill_npg(name = "Cause of Death")+
  coord_polar(theta = "y", start = 0) +
  theme_void() 

ggsave(plot = leading_pie, "figure_tiff/2-03饼图/图7.2.pdf",width= 6, height= 4, units="in")

```

7.3。

```{r pie-male-cancer, fig.cap="2012年男性归因于超重的癌症饼图" }

# 读取数据
male_cancer = read.csv("data/0300_male_cancer.csv")
# 按照占比大小排序
male_cancer = male_cancer[with(male_cancer, order(num)), ]
# 定义因子顺序
male_cancer$cancer = factor(male_cancer$cancer, 
                               levels = rev(male_cancer$cancer))

male_pie = 
  ggplot(male_cancer, aes(x = "", y = num, fill = cancer)) +
  geom_bar(width = 0.3, stat = "identity") +
  scale_fill_npg(name = "Cancer") +
  geom_text(aes(x = 1.1,
                label = paste0(num,"%")),
            position = position_stack(vjust = 0.5),
            size = 3.5) +
  coord_polar(theta = "y", start = 0) +
  theme_void()

ggsave(plot = male_pie, "figure_tiff/2-03饼图/图7.3.pdf",width= 6, height= 4, units="in")
```

图7.4。

```{r pie-cancer, fig.width=8,fig.height=6,fig.cap="2020年各国癌症新发病例数" }

# 读取数据
world_cancer = read.csv("data/0300_ds_cancer_pie.csv")

# 制作各个国家占比的标签
world_cancer_label = world_cancer  %>% 
   mutate(csum = rev(cumsum(rev(value))), 
          pos = value/2 + lead(csum, 1),
          pos = if_else(is.na(pos), value/2, pos),
          percent = paste0(round(100*value/sum(value), 2), "%"),
          labels = paste(country, percent, sep = " "))

world_pie = ggplot(world_cancer, 
       aes(x = "", y = value,
           fill = fct_inorder(country))) +
  geom_bar(stat = "identity",
           width = 0.5,
           color = "white",
           show.legend = F) +
  # 添加标签
  geom_label_repel(data = world_cancer_label,
                   aes(x = 1.25,
                       y = pos, 
                       label = labels),
                   size = 3, 
                   nudge_x = 0.5,
                   show.legend = F,
                   segment.colour = "grey60") +
  scale_fill_brewer(palette = "Set3") +
  coord_polar(theta = "y", start = 0) +
  theme_void()

ggsave(plot = world_pie, "figure_tiff/2-03饼图/图7.4.pdf",width= 6, height= 4, units="in")
```

