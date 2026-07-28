## 中位生存时间标尺

20.4

```{r survival-mst, fig.cap = "生成曲线标注中位数参考线"}

fig20.4 = 
  ggsurvplot(fit,
           size = 1,         
           # 增加中位生存时间
           surv.median.line = "hv", 
           palette = c("#0072B5FF", "#E18727FF"), 
           xlim = c(0, 10),                  
           break.x.by = 1,                    
           xlab = "Overall Survival (years)", 
           ylab = "Survival Probability", 
           axes.off = FALSE,
           legend.labs = c("High","Low"),       
           legend.title = ("GAB1 expression"), 
           ggtheme = theme_egraphics) 

ggsave(plot = print(fig20.4, new.page = F), file = "figure_tiff/2-16生存分析/图20.4.pdf",width = 6, height= 4, units="in")

```

