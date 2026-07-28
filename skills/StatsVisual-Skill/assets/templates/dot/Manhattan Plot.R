## 曼哈顿图 | Manhattan Plot

9.8。

```{r manhattan, fig.height= 4, fig.width=6, fig.cap = "注意缺陷与多动障碍的全基因组关联研究结果"}

# 加载数据
load("data/0500_manhattanplot.RData")
# 本函数来自于“manhattan”包，稍加修改
source("rcode/0500_manhattan.R")

# 对显著位点添加基因名称
lc_dta[lc_dta$MarkerName=="2:74046345", 'label'] = "TET3"
lc_dta[lc_dta$MarkerName=="7:124858989", 'label'] = "POT1"
lc_dta[lc_dta$MarkerName=="5:139481561", 'label'] = "TMEM173"
lc_dta[lc_dta$MarkerName=="5:1293971", 'label'] = "TERT"
lc_dta[lc_dta$MarkerName=="6:32293475", 'label'] = "MHC"
lc_dta[lc_dta$MarkerName=="15:78590583", 'label'] = "CHRNA5"
lc_dta[lc_dta$MarkerName=="19:40844710", 'label'] = "CYP2A6"

# 对显著位点赋值不同颜色
lc_dta[lc_dta$MarkerName %in% c("2:74046345",
                                "5:139481561", 
                                "7:124858989"),'color'] = 'red'
lc_dta[lc_dta$MarkerName %in% c("5:1293971",
                                "6:32293475",
                                "15:78590583",
                                "19:40844710"),'color']='black'

fig9.8 = 
  manhattan(lc_dta, build = 'hg18',
          color1 = "deepskyblue", color2 = "blue") +
  # 增加显著位点标签
  geom_text_repel(aes(label = label), 
                  vjust = -1) +
  # 设置y轴截断
  scale_y_break(c(20, 65),
                expand = c(0, 0), 
                space = 0.01) +
  geom_hline(yintercept = -log10(5e-8),
             color = 'red',
             linetype = "dashed") +
  labs(x = "Chromosome",
       title = "") +
  theme(axis.title.x = element_text(margin = margin(t = -5, r = 0, 
                                                    b = 0, l = 0)),
        axis.line.y.right = element_blank(),
        axis.text.y.right = element_blank(),
        axis.ticks.y.right = element_blank()) 

ggsave(plot = fig9.8, "figure_tiff/2-05点图/图9.8.pdf",width= 6, height= 4, units="in")

```

# 箱线图 | Boxplot

