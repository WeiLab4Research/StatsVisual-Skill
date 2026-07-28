## 堆叠直方图 | Stacked Histogram 
 
8.7。

```{r covid-hist, fig.cap="上海奥密克戎流行期间现存感染者堆叠直方图"}

# 读取数据
shanghai_nCov = read.csv("data/0400_shanghaifit.csv")

shanghai_hist = 
  ggplot(shanghai_nCov) +
  geom_bar(aes(time, (p1+p2)/10000, fill = "b"), 
           stat = "identity", 
           width = 0.8, 
           alpha = 1) +
  geom_bar(aes(time, p1/10000, fill = "a"), 
           stat = "identity", 
           width = 0.8, 
           alpha = 1) +
  scale_fill_manual(values = c("a" = "#0072B5FF",
                               "b" = "#BC3C29FF"),
                    labels = c("a" = expression(P[1]),
                               "b" = expression(P[2]))) +
  scale_x_continuous(expand = c(0.01,0), 
                     breaks = c(1, 25, 50, 75, 95)) +
  scale_y_continuous(expand = c(0, 0), 
                     breaks = c(0, 2, 4, 6, 8, 10, 12)) +
  coord_cartesian(clip = "off", 
                  ylim = c(0, 12), 
                  xlim = c(1, 95)) +
  labs(x = "Duration of Shanghai Omicron Epidemic",
       y = bquote(bold(.("Daily Infections") ~ bold((10^4)))),
       fill = "") +
  theme_egraphics +
  theme(legend.position = "inside",
        legend.position.inside = c(0.1, 0.9))

ggsave(plot = shanghai_hist, "figure_tiff/2-04直方图/图8.7.pdf",width= 6, height= 4, units="in")
```
 
