## 生存曲线风险人群数

在一项肺动脉去神经疗法治疗肺动脉高压的随机对照试验（PAND-CFDA）中，128位受试者被随机分入试验组和对照组，在基础治疗的基础上，试验组采用肺动脉去神经手术(PADN组)，对照组采用假手术（Sham组）。主要疗效指标是6分钟步行距离（6MWD），次要指标包括临床恶化事件发生率。以该临床试验随访6个月内临床恶化事件发生率为基础，绘制带有不同时间点风险人数及删失人数的生存曲线，结果显示，随访6个月期间，PADN组和sham组分别有1例（1.6%）和9例（13.8%）出现临床恶化(HR: 0.11，95% CI: 0.01-0.87)。

```{r survival-risk, fig.width = 8, fig.height = 6, fig.cap = "生存曲线及不同时间点风险人群"}

# 读取数据
padn = read_excel("data/1300_survival_padn.xlsx")
# 拟合生存分析模型
fit_padn = survfit2(Surv(CWdays, ClinicalWorsening) ~ group, data = padn)

p1 = ggsurvfit(fit_padn,
          type = "cumhaz",
          theme = theme_egraphics + 
            theme( legend.position = "none")) +
  scale_x_continuous(limits = c(0, 200),
                     expand = c(0, 0),
                     breaks = seq(0, 180, 30),
                     labels = seq(0, 6, 1)) +
  scale_y_continuous(limits = c(0, 1), 
                     breaks = seq(0, 1, 0.2), 
                     labels = seq(0, 100, 20),
                     expand = c(0, 0)) +
  scale_color_manual(values = c("#BC3C29FF", "grey60" )) +
  scale_fill_manual(values = c("#BC3C29FF", "grey60" ),
                     labels = c('PADN', 'Sham')) +
  labs(x = "Months since Intervention", 
       y = "Clinical Worsening (%)") +
  coord_cartesian(clip = "off") +
  add_risktable(
    hjust = 0,
    risktable_stats = "{n.risk} ({n.censor})",
    stats_label = list(n.risk = "Number at Risk",
                       n.censor = "number censored"))

p2 = ggsurvfit(fit_padn,
          type = "cumhaz",
          theme = theme_egraphics + 
            theme( legend.position = "none")) +
  annotate(geom = 'text', x = 161, y = 0.025, 
           label = paste("PADN: 1.6%"), size = 6) +
  annotate(geom = 'text', x = 165, y = 0.156, 
           label = paste("Sham: 13.8%"),
            size = 6) +
  annotate(geom = 'text', x = 19, y = 0.102, 
           label = c("Log-rank"),
            size = 6) +
  annotate(geom = 'text', x = 41, y = 0.102, 
           label = paste("italic(P)"),
            size = 6, parse = T) +
  annotate(geom = 'text', x = 60, y = 0.102, 
           label = "= 0.010",size = 6) +
  scale_x_continuous(limits = c(0, 200),
                     expand = c(0, 0),
                     breaks = seq(0, 180, 30),
                     labels = seq(0, 6, 1)) +
  scale_y_continuous(limits = c(0, 0.2), 
                     breaks = seq(0, 0.2, 0.05), 
                     labels = seq(0,20,5),
                     expand = c(0,0)) +
  scale_color_manual(values = c("#BC3C29FF", "grey60" )) +
  labs(x = "", 
       y = "") +
  coord_cartesian(clip = "off")

fig20.8 = 
  p1 + annotation_custom(ggplotGrob(p2), 
                       xmin = -5, xmax = 175, 
                       ymin = 0.1, ymax = 1)

ggsave(plot = print(fig20.8, new.page = F), file = "figure_tiff/2-16生存分析/图20.8.pdf",width = 8, height= 8, units="in")


```

```{r survival-pnrisk, fig.width=8, fig.height=6, fig.cap = "sss"}

fig20.7 = ggsurvfit(fit_padn,
          type = "cumhaz",
          theme = theme_egraphics) +
  scale_x_continuous(limits = c(0, 200),
                     expand = c(0, 0),
                     breaks = seq(0, 180, 30),
                     labels = seq(0, 6, 1)) +
  scale_y_continuous(limits = c(0, 1), 
                     breaks = seq(0, 1, 0.2), 
                     labels = seq(0, 100, 20),
                     expand = c(0, 0)) +
  scale_color_manual(values = c("#BC3C29FF", "grey60" )) +
  scale_fill_manual(values = c("#BC3C29FF", "grey60" ),
                     labels = c('PADN', 'Sham')) +
  labs(x = "Months since Intervention", 
       y = "Clinical Worsening (%)") +
  coord_cartesian(clip = "off") +
  add_risktable(
    hjust = 0,
    risktable_stats = "{n.risk} ({n.censor})",
    stats_label = list(n.risk = "Number at Risk",
                       n.censor = "number censored"))

ggsave(plot = print(fig20.7, new.page = F), file = "figure_tiff/2-16生存分析/图20.7.pdf",width = 8, height= 8, units="in")


```


