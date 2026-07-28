## 强影响点诊断 | Rgeression Influence Diagnostics

19.6
```{r linear-diag-leverage2, fig.width=6, fig.height=6, fig.cap ="强影响点诊断图"}

h = influence(lmfit)$hat
tiff("figure_tiff/2-15回归模型诊断/fig19.6.tiff", width = 6, height = 6, units = "in", res = 300)
faraway::halfnorm(h, ylab = "leverage") + 
  theme_egraphics

dev.off()
```

