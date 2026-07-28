## 协变量校正

在观察性研究中，由于研究因素和协变量(很)可能存在关联。在回归模型中，通常通过调整协变量，以使得研究因素的预后效应估计更为准确。常规生存曲线为单个因素展示形式，或多个因素通过组合而成单个因素进行展示，并未考虑协变量对生存曲线的影响，易误导观众。建议绘制校正协变量的生存曲线(图\@ref(fig:survival-adj))，与未校正协变量的图相比，以观察协变量对生存曲线的影响。

```{r survival-adj, fig.cap="校正协变量的生存曲线"}
 
fit = coxph(Surv(os, death) ~ GAB1 + age + gender, data = lung)

fig20.13 = ggadjustedcurves(fit, data = lung, 
                 variable = "GAB1",
                 method = "average", 
                 palette = c("#0072B5FF", "#E18727FF"),
                 axes.off = FALSE,
                 xlim = c(0, 10),
                 xlab = "Overall Survival (years)",
                 ylab = "Survival Probability",
                 legend.labs=c("High","Low"),
                 legend.title = "GAB1 expression",
                 ggtheme = theme_egraphics)

ggsave(plot = print(fig20.13, new.page = F), file = "figure_tiff/2-16生存分析/图20.13.pdf",width = 6, height= 4, units="in")

```



