## 综合诊断 ｜Regression Joint Evaluation 

19.8

```{r linear-diag-3parallel, fig.width=8, fig.height=6, fig.cap ="异常点、杠杆和强影响等回归诊断结果"}

tiff("figure_tiff/2-15回归模型诊断/fig19.8.tiff", width = 8, height = 6, units = "in", res = 300)
infIndexPlot(lmfit)
dev.off()

```

19.9

```{r leverage-cook, fig.cap="杠杆与Cook距离关系图"}

fig19.9 = 
  ggplot(lmfit, aes(.hat, .cooksd)) + 
  geom_point(na.rm = TRUE) + 
  stat_smooth(method = "loess", color = "#BC3C29FF", 
              fill = "#0072B5FF", na.rm = TRUE) + 
  geom_abline(slope = seq(0, 3, 0.5), 
              color = "gray", 
              linetype = "dashed") +
  scale_y_continuous(limits = c(0, 0.06)) +
  scale_x_continuous(expand = c(0, 0), 
                     limits = c(0, 0.03)) +
  labs(x = "Leverage hii",
       y = "Cook's Distance") + 
  theme_egraphics

ggsave(plot = fig19.9, "figure_tiff/2-15回归模型诊断/图19.9.pdf",width = 6, height= 4, units="in")

```

19.10

```{r linear-diag-3to1, fig.height=6, fig.cap ="异常点、杠杆和强影响等回归诊断结果融合图"}

fig19.10 = 
  ggplot(lmfit, aes(.hat, .stdresid)) +
  geom_point(aes(size = exp(.cooksd)), na.rm = TRUE, shape = 1) +
  stat_smooth(method = "loess",
              color = "#BC3C29FF",
              fill = "#0072B5FF",
              na.rm = TRUE) +
  geom_hline(yintercept = c(-2, 0, 2),
             col = "#BC3C29FF",
             linetype = "dashed") +
  scale_size_continuous("Cook's Distance",
                        range = c(1, 15)) +
  scale_x_continuous(expand = c(0, 0),
                     limits = c(0.003, 0.03),
                     breaks = c(0.005, 0.01, 0.015, 0.02, 0.025, 0.03)) +
  scale_y_continuous(expand = c(0, 0), 
                     limits = c(-3, 3)) +
  labs(x = "Leverage",
       y = "Standardized Residuals") +
  theme_egraphics

ggsave(plot = fig19.10, "figure_tiff/2-15回归模型诊断/图19.10.pdf",width = 6, height= 6, units="in")

tiff("figure_tiff/2-15回归模型诊断/fig19.11.tiff", width = 6, height = 6, units = "in", res = 300)
influencePlot(lmfit)
dev.off()
```

# 生存曲线 | Survival 

# 溯源

