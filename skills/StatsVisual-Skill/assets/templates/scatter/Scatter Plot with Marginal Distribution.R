## 带边际分布散点图 | Marginal Plot on Scatter Plot

11.4。

```{r scatter-marginal, fig.width=6,fig.cap="江苏省500名青少年身高体重散点图叠加箱线图"}

p = ggscatter(PE_sampling,
              x = "height_cm",
              y = "weight_kg",
              add = "reg.line",
              conf.int = T,
              add.params = list(color = "black",
                                size = 1,
                                fill = "#99CCFF"),
              cor.method = "pearson",
              xlab = "Height (cm)",
              ylab = "Weight (kg)") +
  scale_x_continuous(limits = c(110, 190),
                     expand = c(0, 0)) +
  scale_y_continuous(limits = c(10, 100),
                     breaks = c(10, 25, 50, 75, 100),
                     expand = c(0, 0)) +
  annotate("text",
           label = "Pearson r = 0.830\n               P < 0.001",
           x = 130,
           y = 80,
           color = "black",size = 6) +
  theme_egraphics

fig11.4 = 
  ggMarginal(p,
           type = "boxplot",
           size = 9,
           lwd = 1,
           alpha = 0.5,
           yparams = list(fill = "#CC0000"),
           xparams = list(fill = "#006699"))

ggsave(plot = fig11.4, "figure_tiff/2-07散点图/图11.4.pdf",width= 6, height= 4, units="in")

```

