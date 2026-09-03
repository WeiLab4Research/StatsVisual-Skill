## 三元图

13.3

```{r ternary-basic, fig.cap="受试者体内无机砷及其代谢物含量之三元图"}
# 加载本章节所需程序包
library(ggpubr)
library(ggsci)
library(ggtern)
# 解决字体显示异常问题
library(showtext)
showtext_auto()

# 读取数据
BT = read.csv("data/0810_ternary.csv")

fig13.3 = 
  ggtern(BT, aes(x = mma, y = ias, z = dma)) +
  geom_point(aes(color = group)) +
  scale_color_nejm() +
  Tlab("MMA%") +
  Llab("iAs%") + 
  Rlab("DMA%") +
  labs(col = "BMI Category") +
  theme_bw() +
  theme_showarrows()

ggsave(plot = fig13.3, "figure_tiff/2-09三元图/图13.3.pdf",width = 6, height= 4, units="in")

```

13.4。

```{r ternary-expand, fig.cap="受试者体内无机砷及其代谢物含量之区间三元图"}

confidenceBreaks <- c(0.5, 0.8,0.9, 0.95, 0.99)
fig13.4 = 
  ggtern(BT, aes(mma, ias, dma)) +
  stat_confidence_tern(color = 'white',
                       mapping = aes(fill = ..level..),
                       geom = "polygon", 
                       breaks = confidenceBreaks)+
  geom_mask() +
  geom_point(colour = "black", 
             fill = "yellow", 
             shape = 21, 
             size = 1) +
  scale_fill_gradient(breaks = confidenceBreaks) +
  Tlab("MMA%") + 
  Llab("iAs%") + 
  Rlab("DMA%") +
  labs(fill = "Confidence Level")+
  theme_bw()

ggsave(plot = fig13.4, "figure_tiff/2-09三元图/图13.4.pdf",width = 6, height= 4, units="in")

```

13.5。

```{r ternary-density, fig.cap="受试者体内无机砷及其代谢物含量之密度三元图"}

fig13.5 = 
  ggtern(data = BT, aes(x = mma, y = ias, z = dma)) +
  stat_density_tern(aes(fill = after_stat(level),
                        alpha = after_stat(level)), 
                    geom = "polygon",
                    breaks = seq(0, 10, by = 0.1)) +
  scale_fill_gradient(low = "blue", high = "red", 
                      name = "Density Level", 
                      labels = c("1", "2", "3", "4", "5"),
                      limits = c(0, 10))+
  scale_alpha_continuous(guide = "none")+
  geom_point(colour = "black", fill = "black", shape = 21, size = 1) +
  Tlab("MMA%") + 
  Llab("iAs%") + 
  Rlab("DMA%") +
  theme_bw()

ggsave(plot = fig13.5, "figure_tiff/2-09三元图/图13.5.pdf",width = 6, height= 4, units="in")

```

图13.6。

```{r ternary-smooth, fig.cap="受试者体内无机砷及其代谢物含量之插值三元图"}

# 目标变量为total，拟合x（MMA%）、y（iAS%）、z(DMA%)对total的多项式回归
fig13.6 = 
  ggtern(BT, aes(mma, ias, dma)) +
  geom_interpolate_tern(mapping = aes(color = ..level.., 
                                      value = total),
                        base = "identity",
                        method = "glm",
                        formula = value ~ poly(x, y, degree = 5))+
  scale_colour_gradient(low = "green",
                        high = "red") +
  geom_point(colour = "black", fill = "black", shape = 21, size = 1)+
  Tlab("MMA%") +
  Llab("iAs%") + 
  Rlab("DMA%") + 
  labs(color = "Total")+
  theme_bw()

ggsave(plot = fig13.6, "figure_tiff/2-09三元图/图13.6.pdf",width = 6, height= 4, units="in")
```


# QQ图 | Quantile-quantile Plot

