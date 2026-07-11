## 疫情峰峦图 | Ridges Plot for COVID-19

8.10。

```{r covid-ridges, fig.width=10,fig.height=6, fig.cap="中国27个城市新冠局部疫情峰峦图"}

# 读取数据
CN_nCov = read.csv("data/0400_covid_ridges.csv",fileEncoding = "GBK")

# 本例所需颜色较多，提取多种期刊颜色
colo = c(pal_nejm("default")(8), 
         pal_jama("default")(7),
         pal_lancet()(9),
         pal_npg()(10))

# 定义顺序
city50level = c("Beijing","Urumqi, Xinjiang" ,"Dalian, Liaoning" ,
                 "Kashgar, Xinjiang","Hulun Buir, Inner Mongolia",
                 "Heihe, Heilongjiang" ,"Shijiazhuang, Hebei",
                 "Xingtai, Hebei","Suihua, Heilongjiang" ,
                 "Haerbin, Heilongjiang","Tonghua, Jilin",
                 "Changchun, Jilin" ,"Ruili, Yunnan" ,
                 "Guangzhou, Guangdong","Nanjing, Jiangsu",
                 "Yangzhou, Jiangsu","Zhangjiajie, Hunan",
                 "Xiamen, Fujian", "Zhengzhou, Henan",
                 "Xinji, Hebei", "Putian, Fujian"  ,
                 "Alashan, Inner Mongolia","Lanzhou, Gansu",
                 "Xian, Shaanxi","Ningbo, Zhejiang" ,
                 "Shaoxing, Zhejiang", "Xuchang, Henan")

CN_nCov$label = factor(CN_nCov$label, levels = rev(city50level))

# 绘制主图
p1 = ggplot(CN_nCov, aes(x = as.Date(date), 
                       y = label, 
                       height = dailyconfirm,
                       group = group,
                       fill = label)) +
  geom_density_ridges(show.legend = FALSE, 
                      stat = "identity",
                      color = NA,
                      scale = 10,
                      alpha = 0.8) +
  scale_x_date(date_minor_breaks = "3 days", date_breaks = "1 months",
               limits = c(as.Date("2020-06-01"), as.Date("2022-02-6")),
               labels = date_format("%Y-%m-%d")) +
  labs(x = "Date", 
       y = "Region") +
  scale_fill_manual(values = rep(colo, 7)) +
  theme_minimal(base_size = 14) +
  theme(axis.text.x = element_text(angle = 30, hjust = 1, 
                                   size = 10, color = "black"),
        axis.text.y = element_text(hjust = 1,
                                   size = 9, color = "black"),
        panel.grid.major.x = element_line(size = 0.01, color = "grey60"),
        panel.grid.minor = element_line(size = 0.01),
        plot.margin = margin(0.3, 0.3, 0, 0.3, "cm"))

# 以北京发病数为标尺，绘制图例
p2 = ggplot(subset(CN_nCov, CN_nCov$cityname == "Beijing"))+
  geom_area(aes(x = date, y = dailyconfirm, group = group),
            fill = "white", color= "white", alpha = 0.8) +
  scale_y_continuous(expand = c(0, 0), 
                     breaks = c(0, 50, 100), 
                     limits = c(0, 100)) +
  labs(x= "", 
       y = "") +
  theme_pubr() +
  theme(axis.text = element_text(size = 10),
        axis.ticks.length=unit(-0.1, "cm"),
        axis.line.x = element_blank(),
        axis.line.y = element_line(color = "grey60"),
        axis.ticks.y = element_line(color = "grey60"),
        panel.grid.major.y = element_line(color = "white"),
        axis.ticks.x = element_blank(),
        axis.title.y = element_text(margin = margin(t = 0, r = 5, 
                                                    b = 0, l = 0), 
                                    size = 10),
        axis.text.x = element_blank(),
        axis.text.y = element_text(margin = margin(t = 0, r = 0.4,
                                                   b = 0, l = 0,'cm')),
        plot.margin = margin(t = 0, r = 0, 
                             b = 0, l = 0, "cm"))

# 设置两图拼接比例
layout <- c(area(t = 21, b = 27, l = 18, r = 18),
            area(t = 2, b = 45, l = 2, r = 17.9))

# 拼图
final <- p2 + p1 + 
  plot_layout(design = layout)

final

ggsave(plot = final, "figure_tiff/2-04直方图/图8.10.pdf",width= 10, height= 6, units="in")

```

