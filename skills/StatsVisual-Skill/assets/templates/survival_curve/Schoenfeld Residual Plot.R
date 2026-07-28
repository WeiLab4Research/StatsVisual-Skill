## 等比例风险假设检验

Cox回归等生存分析模型须要数据满足等比例风险(proportional hazard, PH)假设。可绘制Schoenfeld残差图来判定是否满足等比例风险假设。若Schoenfeld残差图中，y轴为标准化残差，x轴为时间，实线为样条拟合线，上下两条虚线为+/-2倍标准差参考线。若点的分布与时间无关，则提示符合PH假设，否则提示残差与时间可能有关，违背等比例风险假设(图\@ref(fig:survival-ph))。

```{r survival-ph, fig.width=8, fig.height=8, fig.cap="Schoenfeld残差图"}
 
# 拟合cox回归模型
res.cox = coxph(Surv(os, death) ~ GAB1 + age, data = lung)
test.ph = cox.zph(res.cox, global = TRUE)

fig20.11 = ggcoxzph(test.ph, 
         var=c("GAB1", "age"),
         point.col = "#0072B5FF",
         ggtheme = theme_egraphics)

ggsave(plot = print(fig20.11, new.page = F), file = "figure_tiff/2-16生存分析/图20.11.pdf",width = 8, height= 8, units="in")

```

