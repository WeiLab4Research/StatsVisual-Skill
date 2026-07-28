## 杠杆诊断 | Rgeression Leverage Diagnostics

19.5

```{r linear-diag-leverage, fig.width=8, fig.height=4, fig.cap ="杠杆诊断图"}

h = hatvalues(lmfit)
tiff("figure_tiff/2-15回归模型诊断/fig19.5.tiff", width = 8, height = 4, units = "in", res = 300)
# 预设图片组合
split.screen(c(1, 2))
screen(1)
p1 = leveragePlots(lmfit)
screen(2)
p2 = avPlots(lmfit)
dev.off()

```

