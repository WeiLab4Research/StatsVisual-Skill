## 分位数回归 | Quantile Regression

fig18.5

```{r qreg, fig.height=3, fig.cap = "母亲孕早期血清Sr元素水平和新生儿出生体重之分位数回归"}

# 读取数据
ds_qreg = read.csv("data/1201_quantile.csv")
ds_qbci = read.csv("data/1201_quantile_mediation.csv")

p_qline = ggplot(ds_qreg, aes(X88Sr, birthweight)) + 
  geom_point(size = 1.2) + 
  geom_quantile(quantiles = seq(0.1, 0.9, 0.05), 
                color = "#0072B5FF", 
                alpha = 0.5) +
  scale_x_continuous(expand = c(0, 0), 
                     limits = c(10, 90), 
                     breaks = seq(10, 90, 10)) +
  scale_y_continuous(expand = c(0, 0), 
                     limits = c(0, 5)) +
  labs(x = "ln(X88Sr)", 
       y = "Birth Weight (kg)") +
  theme_egraphics
 
p_qci = ggplot(ds_qbci,
               aes(quantile, Total_estimate)) + 
  geom_line(color = "#0073C2FF",
            linewidhth = 1.2)+ 
  geom_hline(yintercept = 0,
             color = "#A73030FF",
             linetype = "dashed",
             linewidth = 1)+ 
  geom_vline(xintercept = 0.17, 
             color = "#A73030FF", 
             linetype = 3,
             linewidth = 0.75) +
  geom_ribbon(aes(ymin = Total_estimate_LC,
                  ymax = Total_estimate_UC), 
              fill = "grey60", 
              alpha = 0.6) +
  scale_x_continuous(expand = c(0, 0),
                     limits = c(0.1, 0.9),
                     breaks = c(0.17, 0.3, 0.5, 0.7, 0.9)) +
  scale_y_continuous(expand = c(0, 0),
                     limits = c(-200, 500), 
                     breaks = seq(-200, 500 ,100)) +
  labs(x = "Quantile of Birth Weight (kg)", 
       y = "b of ln(X88Sr)") +
  theme_egraphics

fig18.5 = 
  plot_grid(p_qline, p_qci, 
          nrow = 1, ncol = 2, 
          labels = "AUTO")

ggsave(plot = fig18.5, "figure_tiff/2-14非线性回归/图18.5.pdf",width = 6, height= 3, units="in")
```

fig18.6

```{r qreg-curve, fig.cap = "母亲孕早期血清Sr元素水平和新生儿出生体重之分位数曲线回归"}

fig18.6 = 
  ggplot(ds_qreg, aes(X88Sr, birthweight)) + 
  geom_point(size = 1.2, alpha = 0.8) + 
  geom_quantile(quantiles = seq(0.1, 0.9, 0.05), 
                color = "#0072B5FF",
                alpha = 0.5,
                method = "rqss", 
                lambda = 0.8) +
  scale_x_continuous(expand = c(0, 0),
                     limits = c(10, 90), 
                     breaks = seq(10, 90, 10)) +
  scale_y_continuous(expand = c(0, 0),
                     limits = c(0, 5)) +
  labs(x = "ln(X88Sr)", 
       y = "Birth Weight (kg)") +
  theme_egraphics

ggsave(plot = fig18.6, "figure_tiff/2-14非线性回归/图18.6.pdf",width = 6, height= 4, units="in")

```

# 回归模型诊断 | Regression Model Diagnostics

