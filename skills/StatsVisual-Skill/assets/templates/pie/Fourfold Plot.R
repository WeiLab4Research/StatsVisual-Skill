## 四瓣图 | Fourfold Plot

四瓣图，用于展示两个二分类变量交叉组合所形成的2×2列联表之频数。**Michael Friendly**在其1994年发表的文章《A Fourfold Display for 2-by-2 by k Tables》[@RN2]中根据加州伯克利分校(UCB)录取数据，首次应用四瓣图来展示学生录取是否与性别有关联。本例将用R中绘制四瓣图的基础函数`fourfoldplot()`和内置数据集`UCBAdimissions`来重现文章中的图(图\@ref(fig:pie-fourfold)，原文中Figure 2)。
四瓣图从优势比(odds ratio，OR)的角度出发，基于假设检验和区间估计之间的关系，来检验列联表中行列变量是否独立。设四个频数分别为a、b、c、d，则原假设(H0)下OR值(ad/bc)应接近于1;反之，若OR值远离1且具有统计学意义，则行列变量不独立。从图形中观察，OR值体现于两相邻四分之一圆的半径之比，若两个相邻扇形半径差异显著（即两个扇形的可信区间弧线无重叠），则拒绝原假设。本例中，院系A四瓣图的可信区间弧线不相交，说明院系A的录取情况与性别有关。

```{r pie-fourfold, fig.cap = "加州伯克利分校录取数据四瓣图"}

dimnames(UCBAdmissions) = list("录取情况" = c("录取", "拒绝"),
                              "性别" = c("男性", "女性"),
                              "院系" = LETTERS[1:6])

tiff("figure_tiff/2-03饼图/fig7.12.tiff", width = 6, height = 4, units = "in", res = 300)
fourfoldplot(UCBAdmissions, 
             mfcol = c(2, 3))
dev.off()

```

某一随机对照试验中，将病情相似的169名消化道溃疡患者随机分成两组，试验组85名患者，服用奥美拉唑，对照组84名患者，服用雷尼替丁。4周后，试验组有64名患者痊愈，21名患者的溃疡尚未愈合；对照组有51名患者痊愈，33名患者的溃疡尚未愈合。用四瓣图来展示试验数据。图中可见，四瓣图的可信区间并不相交，说明服用奥美拉唑和服用雷尼替丁治疗胃溃疡的疗效有差异(图\@ref(fig:fourfoldexample))。

```{r fourfoldexample, fig.show ='hold', fig.cap = "医学实例研究之四瓣图"}

# 读取数据
fourfold_survival = read.csv("data/0300_fourfold1.csv", fileEncoding = 'GBK')
fourfold_therapy = read.csv("data/0300_fourfold2.csv", fileEncoding = 'GBK')

table1 = xtabs(~治疗方式 + 人数, fourfold_survival)
table2 = xtabs(~处理 + 疗效, fourfold_therapy)


par(mar = c(4, 4, 0.1, 0.1))
tiff("figure_tiff/2-03饼图/fig7.13.tiff", width = 6, height = 4, units = "in", res = 300)
fourfoldplot(table1, color= c("#3C5488FF", "#DC0000FF"))
dev.off()

tiff("figure_tiff/2-03饼图/fig7.14.tiff", width = 6, height = 4, units = "in", res = 300)
fourfoldplot(table2, color= c("#3C5488FF", "#DC0000FF"))
dev.off()  

```

# 直方图 | Histogram
