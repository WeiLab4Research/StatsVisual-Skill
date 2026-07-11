## 螺旋直方图 | Spiral Histogram

8.11。

```{r spiral-hist, fig.cap="上海市2017-2020年日均PM2.5浓度变化螺旋直方图"}

# 读取数据
pm2.5 = read.csv("data/0400_spiral_hist.csv")
# 定义色系
colours=paletteer_c("grDevices::Blue-Red 3", 30)

spiral_hist = 
  ggplot()+
  geom_linerange(data = pm2.5,
                 aes(x = DateNum,
                     ymin=Asst-5,
                     ymax=Asst+Valueht-5,
                     color=mean_pm2.5),
                 size =1)+
  geom_line(data = pm2.5,
            aes(x = DateNum,
                y = Asst + Valueht - 5,
                group = Year),
            size =0.25, color="black")+
  geom_line(data = pm2.5,
            aes(x = DateNum,
                y = Asst-5,
                group = Year),
            size =0.25,color="grey20")+
  coord_polar(theta = "x",
              start = 0)+
  scale_x_continuous(breaks=c(1,31,59,90,120,151,181,212,243,273,304,334),
                     labels = c("1月", "2月", "3月", "4月", "5月", "6月",
                                "7月", "8月", "9月", "10月", "11月", "12月"),
                     minor_breaks = NULL)+
  annotate('text', x = 6, y = c(5, 10, 15, 20), 
           label = c("2017","2018","2019","2020"))+
  scale_color_gradient2(mid = colours[15],
                        low = colours[1:10],
                        high = colours[20:30],
                        midpoint = 75,
                        breaks = c(25, 75,125, 175))+
  labs(color = expression(paste(PM[2.5], " (", mu, g, "/", m^3, ")", 
                                sep = ""))) +
  theme_minimal() +
  theme(legend.key.size = unit(0.5, "cm"),
        legend.position = "right",
        axis.title = element_blank(),
        axis.text.y = element_blank(),
        axis.text.x = element_text(size = 18),
        panel.grid.major = element_line(color="grey80"))

ggsave(plot = spiral_hist, "figure_tiff/2-04直方图/图8.11.pdf",width= 10, height= 10, units="in")

```






# 克利夫兰点图 | Cleveland's Dot plot
