## 基础条形图 | Bar Plot

5.3
```{r basic-bar, fig.cap="元素暴露风险得分和儿童神经发育迟缓"}

# 加载本章节所需程序包
library(ggpubr)
library(cowplot)
library(patchwork)
library(ggsci)
library(waterfalls)

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
umbilical_cord_sum = read.csv(file ="data/0100_basic_bar_1.csv")
umbilical_cord = read.csv(file ="data/0100_basic_bar.csv")

# 根据汇总结果绘制图形
bar_basic = ggplot(umbilical_cord_sum,
                   aes(x = cognitive_scaled_ers_lmw_cat5, 
                       y = percent * 100)) +
  geom_bar(stat = "identity",
           fill = "steelblue") +
  scale_x_continuous(expand = c(0.01, 0)) +
  scale_y_continuous(limits = c(0, 50),
                     expand = c(0, 0)) +
  labs(x = "ERS Quantile",
       y ="Developmental Delay (%)") +
  theme_egraphics

# 根据原始数据绘制图形
bar_fill = ggplot(umbilical_cord,
                      aes(x = cognitive_scaled_ers_lmw_cat5, 
                          fill = cognitive_scaled_low)) +
  geom_bar(position = "fill", 
           show.legend = FALSE) +
  geom_text(stat = "count", 
            aes(label = after_stat(count)),
            color = "white",
            size = 3.5,
            position = position_fill(0.9)) +
  scale_x_continuous(expand = c(0.01, 0)) +
  scale_y_continuous(labels = seq(0, 100, 25),
                     limits = c(0, 1),
                     expand = c(0, 0)) +
  scale_fill_manual(values = c("gray60", "steelblue")) +
  labs(x = "ERS Quantile", 
       y = "Developmental Delay (%)") +
  theme_egraphics

# 将两幅图拼成一行，标为A和B
fig5.3 = 
  plot_grid(bar_basic,
          bar_fill,
          nrow = 1,
          labels = c("A", "B"))

ggsave(plot = fig5.3, "figure_tiff/2-01条形图/图5.3.pdf",width= 6, height= 4, units="in")


```

