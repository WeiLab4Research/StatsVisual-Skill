## 异常值识别

亦可绘制Deviance残差图来识别异常值。Deviance残差均数为0，标准差为1。残差为正则表示实际结局早于预测结局，为负责表示实际结局晚于预测结果。残差过大或过小(超过上下1.96倍标准差)，则为可疑离群值，可检视数据(图\@ref(fig:survival-deviance))。

```{r survival-deviance, fig.width=8, fig.height=4, fig.cap="Deviance残差图"}
 
# 拟合cox回归模型
res.cox = coxph(Surv(os, death) ~ GAB1, data = lung)

fig20.12 = 
  ggcoxdiagnostics(
  res.cox,
  type = "deviance",
  hline.col = "#BC3C29FF",
  point.col = "#E18727FF",
  sline.col = "#0072B5FF",
  linear.predictions = FALSE,
  ggtheme = theme_egraphics)

ggsave(plot = print(fig20.12, new.page = F), file = "figure_tiff/2-16生存分析/图20.12.pdf",width = 8, height= 4, units="in")

```

