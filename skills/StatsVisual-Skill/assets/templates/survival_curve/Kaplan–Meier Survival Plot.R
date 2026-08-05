## 常规生存曲线

20.2

```{r survival-regular, fig.width = 6, fig.cap = "生存曲线(左)和死亡曲线(右)示意图"}

# 加载本章节所需程序包
library(ggpubr)
library(ggsci)
library(survminer)
library(survival)
library(readxl)
library(ggsurvfit)

# 设置图形基本背景
theme_egraphics = 
  theme_pubr() + 
  theme(axis.title.y = element_text(margin = margin(t = 0, r = 10, 
                                                    b = 0, l = 0)),
        axis.title.x = element_text(margin = margin(t = 10, r = 0, 
                                                    b = 0, l = 0)),
        axis.title = element_text(size = 13, face = "bold"),
        axis.line = element_line(linewidth = 0.6, color = "black"),
        axis.ticks = element_line(size = 0.3),
        axis.ticks.length = unit(.15, "cm"),
        axis.text  = element_text(size = 10),
        plot.margin = margin(.5, .5, .5, .5, "cm"))

# 读取数据
lung = read.csv(file = "data/1300_survival_anal_graphics.csv")
# 转化随访时间单位
lung$os = lung$os/12
# 根据GAB1表达中位数进行分组
lung$GAB1 = ifelse(lung$GAB1 <= median(lung$GAB1, na.rm = TRUE), 
                   'Low', 'High')
# 拟合生存分析模型
fit = survfit(Surv(os, death) ~ GAB1, data = lung)

fig20.2 = 
  ggsurvplot(fit, 
           size = 1,     
           palette = c("#0072B5FF", "#E18727FF"), 
           xlab = "Overall Survival (years)",
           break.x.by = 1,                  
           xlim = c(0, 10),        
           axes.off = FALSE,
           legend.labs = c("High", "Low"),   
           legend.title = ("GAB1 expression"),
           fun = "pct",
           ggtheme = theme_egraphics) 

ggsave(plot = print(fig20.2, new.page = F), file = "figure_tiff/2-16生存分析/图20.2.pdf",width = 6, height= 4, units="in")
```

