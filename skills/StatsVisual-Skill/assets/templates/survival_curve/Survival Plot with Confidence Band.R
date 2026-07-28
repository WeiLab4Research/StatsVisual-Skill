## 生存曲线区间带

20.5

```{r survival-band, fig.cap = "生存曲线增加区间带"}

fig20.5 = ggsurvplot(fit,
           palette = c("#0072B5FF", "#E18727FF"), 
           # 添加区间带
           conf.int = TRUE,          
           xlab = "Overall Survival (years)", 
           break.x.by = 5,                
           ylab = "Survival Probability",  
           axes.off = FALSE,
           legend.labs = c("High", "Low"),       
           legend.title = "GAB1 expression", 
           fun = "pct",
           ggtheme = theme_egraphics)

ggsave(plot = print(fig20.5, new.page = F), file = "figure_tiff/2-16生存分析/图20.5.pdf",width = 6, height= 4, units="in")

```

