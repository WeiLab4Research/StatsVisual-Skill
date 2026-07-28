## 玫瑰图 | Nightingale Rose Chart

玫瑰图，在饼图基础上，通过扇形的半径来体现数值大小，从而直观反映数据差异。(图\@ref(fig:pie-rose1))。
自2019年底新冠病毒肆虐全球以来，世界人民深切关注疫情态势。人民日报首次使用南丁格尔玫瑰图来展示世界各国疫情态势，引起一股“玫瑰图”热潮。以2020年4月4日海外新冠累积确诊病例数排名前40的国家疫情数据为例，绘制玫瑰图(图\@ref(fig:pie-rose1))。

```{r nightingale, eval = FALSE}

# 读取数据
nCov = read.csv("data/0300_nCov2019cases.csv",fileEncoding = 'GBK')
nCov$country = factor(nCov$country, levels = nCov$country) 

p_rose = ggplot(nCov, aes(country, plotnum)) +
  geom_col(aes(fill = as.numeric(country)), width = 1, size = 0) +
  # 定义内环白圈位置
  geom_col(aes(y = 80), fill = "white", width = 1, alpha = 0.2, size = 0) +
  geom_col(aes(y = 40), fill = "white", width = 1, alpha = 0.2, size = 0) +
  scale_y_continuous(limits = c(-60, 1801)) +
  coord_polar(direction = -1) +
  # 添加外围标签
  geom_text(aes(label = paste(country, cases, sep = "\n"), 
                y = plotnum * 0.95, angle = angle),
    data = function(d)
      d[nCov$cases > 56000, ], size = 1, color = "white", 
    fontface = "bold", vjust = 1) +
  geom_text(aes(label = paste(country, cases, sep = "\n"),
                y = plotnum * 0.95,angle = angle),
    data = function(d)
      d[nCov$cases > 16000 & nCov$cases <= 56000, ],
    size = 0.6,color = "white",fontface = "bold",vjust = 1) +
  geom_text(aes(label = paste(country, cases, sep = "\n"),
                y = plotnum * 0.95,angle = angle),
    data = function(d)
      d[nCov$cases >= 5500 & nCov$cases <= 16000, ],
    size = 0.4, color = "white",fontface = "bold", vjust = 1) +
  geom_text(aes(label = paste0(country, " ", cases),
                y = plotnum + 20, 
                angle = angle + 90),
    data = function(d)
      d[nCov$cases < 5500 , ], 
    size = 0.8, hjust = 0, fontface = "bold", vjust = 0.5) + 
  annotate(geom = "text", x = 20, y = -60, 
           label = "单位:例",size = 0.8) +
  scale_fill_gradientn(
    colors = c("#330066", "#3333CC", "#006699", "#6699CC", "#33FFFF"),
    guide = "none") +
  theme(legend.position = "none") +
  theme_void()

graph2pdf(x = p_rose, file = "figure_tiff/2-03饼图/图7.8.pdf", font = "SimSun",scaling = 60)


```

7.9。

```{r cancer-rose, eval = FALSE}

# 读取数据
cancer_rose = read.csv("data/0300_ds_cancer_rose.csv", fileEncoding = 'GBK')
cancer_rose$cancer = factor(cancer_rose$cancer,levels = cancer_rose$cancer)

p = ggplot(cancer_rose, aes(cancer, value))+
  geom_col(aes(fill = as.numeric(cancer)),  width = 1, size = 0)+
  geom_col(aes(y = 7), fill = "white", width = 1, alpha = 0.2, size = 0) +
  geom_col(aes(y = 4), fill = "white", width = 1, alpha = 0.2, size = 0) +
  geom_text(aes(label = paste(cancer, value, sep = "\n"),
                y = value + 7, 
                angle = angle - 6),
            data = function(d) d[cancer_rose$value >60, ], size = 1.8,
            fontface = "bold",
            vjust = 1)+
  geom_text(aes(label = paste(cancer, value, sep = "\n"),
                y = value + 2, 
                angle = angle - 6),
            data = function(d) d[cancer_rose$value >25 & cancer_rose$value <60, ], 
            size = 1,
            fontface = "bold",
            vjust = 1)+
  geom_text(aes(label = paste(cancer, value, sep = "\n"),
                y = value + 4, 
                angle = angle - 5),
            data = function(d) d[cancer_rose$value >4 & cancer_rose$value <20, ], 
            size = 0.5,
            fontface = "bold",
            vjust = 1)+
  geom_text(aes(label = paste0(cancer,"(",value,")"),
                y = value + 1, angle = angle + 90),
            data = function(d) d[cancer_rose$value <4, ],
            hjust = 0, 
            size = 0.6,
            fontface = "bold",
            vjust = 0.5)+
  annotate(geom = "text", x = 15, y = -5,
           label = "死亡人数\n(万人)",
           fontface = "bold",
           size = 0.8) +
  scale_y_continuous(limits = c(-5, 75))+
  coord_polar(direction = -1)+
  scale_fill_gradientn(colors = paletteer_c("ggthemes::Red-Blue Diverging", 30),
                       guide = "none")+
  theme(legend.position = "none")+
  theme_void()

graph2pdf(x = p, file = "figure_tiff/2-03饼图/图7.9.pdf", font = "SimSun")

```

