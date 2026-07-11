## 日历图 | Calendar Chart

日历图，是以“日历”形式来逐日/逐周/逐月的展示数据。可以将数值填写于日历格里，也可以映射为格子颜色。本例将根据2021年1月至10月中国北京市每日新增新冠肺炎病例数据，通过`geom_tile`函数来展示以月为单位的日历图，颜色越深则代表那天新增确诊人数越多(图\@ref(fig:scatter-calendar))。

```{r scatter-calendar, fig.width=8, fig.cap="2020年度北京市新冠肺炎每日新增病例数日历图"}

# 读入数据
beijing_Cov = read.csv("data/0710_calendar.csv")

# 调整日期顺序
beijing_Cov$weekday1 = factor(beijing_Cov$weekday, 
                              levels = (1:7), 
                              labels=(c("Mon", "Tue", "Wed", 
                                        "Thu", "Fri", "Sat", "Sun")), 
                              ordered = TRUE)
beijing_Cov$month1 = factor(beijing_Cov$month, 
                            levels = as.character(1:12),
                            labels=c("Jan", "Feb", "Mar", "Apr", "May", 
                                     "Jun", "Jul", "Aug", "Sep", "Oct", 
                                     "Nov", "Dec"), 
                            ordered=TRUE)

fig12.12 = 
  ggplot(beijing_Cov, aes(weekday1, monthweek, fill = new)) +
  geom_tile(colour = "white") +
  scale_fill_gradient(low = "white", high = "#CC0000") +
  geom_text(aes(label = day), size = 3) +
  # 适用于根据一个或多个分类变量对数据进行分面
  facet_wrap( ~ month1, nrow = 3) +
  scale_y_reverse() +
  labs(x = "Day", 
       y = "Week of the month",
       fill = "Daily New Cases") +
  theme_pubr(legend = "right") +
  theme(axis.text = element_blank(),
        axis.ticks = element_blank(),
        strip.text = element_text(size = 11, 
                                  face = "plain",
                                  color = "black"),
        axis.text.x = element_text(angle = 45,
                                   size = 10))


ggsave(plot = fig12.12, "figure_tiff/2-08热图/图12.12.pdf",width = 8, height= 4, units="in")
```


# 三元图 | Ternary Plot
