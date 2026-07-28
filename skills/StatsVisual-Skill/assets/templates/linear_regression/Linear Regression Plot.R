## 直线回归 | Linear Regression

17.3。

```{r linear-regression, fig.width = 6, fig.height = 4, fig.cap = "直线回归五线谱(以400所小学的学业成绩和学生享受膳食补贴比例的关系为例)"}

# 加载本章节所需程序包
library(ggpubr)
library(ggsci)
library(ggpmisc)
library(ggExtra)
library(tidyverse)
library(plotly)
library(reshape2)

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
API = read.csv("data/1200_api00_linear_regression.csv")
# 删除数据缺失值
API = na.omit(API)

p = ggscatter(API,
              x = "meals", 
              y = "api00",
              add = "reg.line",
              conf.int = TRUE,
              fullrange = FALSE,
              conf.int.level = 0.95,
              add.params = list(color = "black", 
                                size = 1,
                                fill = "red"),
              xlab = "Proportion Accepted Free Meals (%)",
              ylab = "Academic Performance Index") +
  scale_y_continuous(expand = c(0, 0), 
                     limits = c(300, 1000), 
                     breaks = seq(300, 1000, 100)) +
  scale_x_continuous(expand = c(0, 0), 
                     limits = c(0, 100),
                     breaks = seq(0, 100, 20)) +
  # 增加公式
  stat_poly_eq(formula = y ~ x, 
               eq.with.lhs=FALSE,
               aes(label = 
                     paste("hat(italic(Y))","~`=`~", ..eq.label.., "`,`",
                           ..rr.label.., 
                           sep = "~")),
               label.y.npc = "top",
               label.x.npc = "right",
               size = 6,
               parse = TRUE) + 
  coord_cartesian(clip = 'off') +
  theme_egraphics

fig17.3 = ggMarginal(p, 
           type="boxplot",
           size = 12, lwd = 1, alpha = 0.5,
           yparams = list(fill ="#CC0000"),
           xparams = list(fill ="#006699"))

ggsave(plot = fig17.3, "figure_tiff/2-13线性回归/图17.3.pdf",width = 6, height= 4, units="in")

```

直线回归五线谱图 | Linear Regression with Confidence and Tolerance Bands

17.4。

```{r conf-tolerance-band,fig.width = 6, fig.height = 4, fig.cap = "10名3岁男童体重与体表面积回归五线谱"}

# 读取数据
ds_weight = read.csv("data/1200_ds_weight.csv")

# 拟合线性回归
lmfit = lm(bsa~weight, data = ds_weight)

# 计算预测值
ds_weight$yhat = predict(lmfit)
# 计算预测值区间
ri = predict(lmfit, interval = "prediction", newdata = ds_weight, level = 0.95)

# 合并数据
ds_band = merge(ds_weight, ri, by.x = "yhat", by.y = "fit")

# 根据预测区间带定义异常值
ds_band$Outlier = ds_weight$bsa >= ds_band$upr | ds_weight$bsa <= ds_band$lwr

fig17.4 = ggscatter(ds_band,
            x = "weight",
          y = "bsa",
          col = "Outlier",
          add = "reg.line",
          conf.int = TRUE,
          fullrange = FALSE,
          conf.int.level = 0.95,
          add.params = list(color = "black",
                            size = 1,
                            fill = "#0072B5FF")) +
  scale_color_manual(values = rev(c("#BC3C29FF", "#0072B5FF"))) +
  geom_line(aes(x = weight, y = lwr), 
            color = "#BC3C29FF",
            linetype = "dashed") +
  geom_line(aes(x = weight, y = upr),
            color = "#BC3C29FF",
            linetype = "dashed") +
  scale_y_continuous(expand = c(0, 0),
                     limits = c(4.5, 7),
                     breaks = seq(4.5, 7, 0.5)) +
  scale_x_continuous(expand = c(0, 0),
                     limits = c(11, 16),
                     breaks = seq(11, 16, 1)) +
  stat_poly_eq(formula = y ~ x,
               eq.with.lhs = FALSE,
    aes(label = paste("hat(italic(Y))", "~`=`~",
        ..eq.label.., "`,`", ..rr.label.., 
        sep = "~")),
    label.y.npc = "top",
    label.x.npc = "right",
    size = 6,
    parse = TRUE) +
  labs(x = "Weight (kg)",
        y= expression(paste("BSA (", m^2, ")"))) +
  coord_cartesian(clip = "off") +
  theme_egraphics

ggsave(plot = fig17.4, "figure_tiff/2-13线性回归/图17.4.pdf",width = 6, height= 4, units="in")
```

