## 截尾至某一特定时间

20.3
```{r survival-censor, fig.cap = "截尾至特定时间的生成曲线示意图"}


fig20.3 = 
  ggsurvplot(fit, size = 1, 
           palette = c("#0072B5FF", "#E18727FF"), 
           xlim = c(0, 8),                
           break.x.by = 1, 
           axes.off = FALSE,
           xlab = "Overall Survival (years)", 
           ylab = "Survival Probability",     
           legend.labs = c("High","Low"),       
           legend.title = ("GAB1 expression"), 
           ggtheme = theme_egraphics) 

ggsave(plot = print(fig20.3, new.page = F), file = "figure_tiff/2-16生存分析/图20.3.pdf",width = 6, height= 4, units="in")

```

