## 残差诊断 | Regression Residual Diagnostics


```{r linear-diag-residual1, fig.cap = "回归模型残差诊断图"}

# 加载本章节所需程序包
library(ggpubr)
library(ggsci)
library(car)
library(lindia)

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
# 删除缺失值
API = na.omit(API)

# 拟合线性回归方程
lmfit = lm(api00 ~ meals, data = API)

fig19.1 = ggplot(lmfit, aes(.fitted, .resid)) + 
  geom_point() +
  stat_smooth(method = "loess", 
              color = "#BC3C29FF", 
              fill = "#0072B5FF") + 
  geom_hline(yintercept = 0,
             linewidth = 1,
             color = "#BC3C29FF", 
             linetype = "dashed") +
  scale_x_continuous(expand = c(0, 0), 
                     limits = c(450, 850)) +
  scale_y_continuous(expand = c(0, 0), 
                     limits = c(-200, 200)) +
  coord_cartesian(clip = 'off') +
  labs(x = "Fitted values",
       y = "Residuals") +
  theme_egraphics

ggsave(plot = fig19.1, "figure_tiff/2-15回归模型诊断/图19.1.pdf",width = 6, height= 4, units="in")

```

19.2

```{r residual-qq, fig.height=4, fig.width=4, fig.cap = "回归模型残差诊断之QQ图"}

fig19.2 = ggplot(lmfit, aes(sample = .stdresid)) + 
   geom_qq(color = "#0072B5FF") +
   geom_abline(color = "#BC3C29FF") + 
   scale_x_continuous(expand = c(0, 0),
                      limits = c(-4, 4)) +
   scale_y_continuous(expand = c(0, 0), 
                      limits = c(-4, 4)) +
   labs(x = "Theoretical Quantiles",
        y = "Standardized Residuals") +
   theme_egraphics
  
ggsave(plot = fig19.2, "figure_tiff/2-15回归模型诊断/图19.2.pdf",width = 4, height= 4, units="in")
```

19.3

```{r diag-var, fig.cap="残差方差齐性诊断图"}

fig19.3 = ggplot(lmfit, aes(.fitted, sqrt(abs(.stdresid)))) + 
  geom_point(na.rm = TRUE) + 
  stat_smooth(method = "loess", 
              color = "#BC3C29FF", 
              fill = "#0072B5FF", 
              na.rm = TRUE) + 
  geom_hline(yintercept = 1,
             size = 1,
             color = "#BC3C29FF", 
             linetype = "dashed") +
  scale_x_continuous(expand = c(0, 0), 
                     limits = c(450, 850)) +
  scale_y_continuous(expand = c(0, 0), 
                     limits = c(0, 2)) +
  labs(x = "Fitted Value", 
       y = expression(sqrt("|Standardized residuals|"))) +
  theme_egraphics

ggsave(plot = fig19.3, "figure_tiff/2-15回归模型诊断/图19.3.pdf",width = 6, height= 4, units="in")
```

19.4

```{r linear-diag-residual2,  fig.height=6, fig.cap = "回归模型残差诊断"}

fig19.4 = ggplot(lmfit, aes(seq_along(.stdresid), .stdresid)) + 
  geom_point(na.rm = TRUE) +
  stat_smooth(method="loess", 
              color = "#BC3C29FF", 
              fill = "#0072B5FF") + 
  geom_hline(yintercept = c(-3, 0, 3), 
             color = "#BC3C29FF", 
             linetype = "dashed") +
  scale_x_continuous(expand = c(0, 0), 
                     limits = c(0, 300)) +
  scale_y_continuous(expand = c(0, 0), 
                     limits = c(-4, 4)) +
  labs(x = "Values", 
       y = "Standardized Residual") +
  theme_egraphics

ggsave(plot = fig19.4, "figure_tiff/2-15回归模型诊断/图19.4.pdf",width = 6, height= 6, units="in")
```

