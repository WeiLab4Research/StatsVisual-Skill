## 生存曲线展示和比较的整合图形

将KM曲线、各时点风险人数表、生存曲线间比较结果等信息合并于一图，一目了然(图\@ref(fig:survival-combine))。

```{r survival-combine, fig.width = 8, fig.height= 6, fig.cap = "生存曲线及组间比较"}
 

brcaov = survminer::BRCAOV.survInfo

set.seed(20190822)
brcaov = brcaov[sample(1:nrow(brcaov), replace = TRUE, size = 200), ]
brcaov$times = brcaov$times/365.25

fit_brcaov = survfit(Surv(times, patient.vital_status) ~ admin.disease_code, 
                     data = brcaov) 

ggsurvplot(fit_brcaov , size = 1, 
           palette = c("#0072B5FF", "#E18727FF"),
           xlab = "Overall Survival(years)",
           legend.labs=c("High","Low"),
           legend.title=(NULL),
           risk.table = TRUE,   
           ggtheme = theme_egraphics)

```

