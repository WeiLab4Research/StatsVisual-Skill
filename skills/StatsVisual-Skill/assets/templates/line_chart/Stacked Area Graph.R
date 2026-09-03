## 堆叠面积图 | Stacked Area Graph

fig6.8。

```{r line-stacked, fig.cap = "中国新冠肺炎累计确诊病例数、死亡数、治愈数的堆叠面积图"}

# 读取数据
hubei_covid19 = read.csv("data/0200_China_nCov.csv")
# 转化日期格式
hubei_covid19$date = as.Date(hubei_covid19$date)

fig6.8 = 
  ggplot(hubei_covid19, aes(date)) +
  geom_area(aes(y = wuhan + hubei + total, fill = "total")) +
  geom_area(aes(y = wuhan + hubei, fill = "hubei")) +
  geom_area(aes(y = wuhan, fill = "wuhan")) +
  geom_vline(xintercept = as.numeric(as.Date("2020-02-13")),
             color = "grey90",
             lwd = 1) +
  scale_x_date(date_labels = "%Y-%m-%d", 
               date_breaks = "1 week",
               limits = c(as.Date("2020-01-11"), as.Date("2020-05-11")),
               expand = c(0, 0)) +
  scale_y_continuous(limits = c(0, 100000),
                     expand = c(0, 0)) +
  scale_fill_brewer(palette = "Pastel1",
                    labels = c("Hubei w/o Wuhan",
                               "China w/o Hubei",
                               "Wuhan")) +
  labs(x = "Date", 
       y = "N of Cumulative Cases", 
       fill = "") +
  theme_egraphics +
  theme(legend.position = "top",
        legend.key.size = unit(0.4, 'cm'),
        axis.text.x = element_text(angle = 45,
                                   hjust = 1))

ggsave(plot = fig6.8, "figure_tiff/2-02线图/图6.8.pdf",width= 6, height= 4, units="in")
```

