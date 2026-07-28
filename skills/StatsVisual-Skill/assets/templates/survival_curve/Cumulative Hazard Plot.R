## 累积风险函数

20.6

```{r survival-cumhaz, fig.cap = "累计风险函数图"}

fig20.6 = ggsurvplot(fit,
           palette = c("#0072B5FF", "#E18727FF"), 
           xlab = "Overall Survival(years)",
           break.x.by = 2,
           ylim = c(0, 1.5),
           xlim = c(0, 10),
           ylab = "Cumulative Hazard",
           axes.off = FALSE,
           legend.labs = c("High", "Low"),
           legend.title = "GAB1 expression",
           # 设定函数计算累计风险
           fun = "cumhaz",
           ggtheme = theme_egraphics)

ggsave(plot = print(fig20.6, new.page = F), file = "figure_tiff/2-16生存分析/图20.6.pdf",width = 6, height= 4, units="in")

```

