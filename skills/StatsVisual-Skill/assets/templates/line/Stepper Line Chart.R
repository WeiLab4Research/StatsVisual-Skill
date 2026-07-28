## 台阶图 | Stepper Line Chart

6.11。

```{r line-stepper, fig.height=6 ,fig.cap = "中国新冠肺炎累计病例数和治愈人数"}
# 读取数据
covid_CN = read.csv("data/0200_stepper.csv", stringsAsFactors = TRUE)
covid_CN$date = as.Date(covid_CN$date)

fig6.11 = 
  ggplot(covid_CN, aes(as.Date(date))) +
  geom_step(aes(y = cases, color = "cases"), size = 0.8) +
  geom_step(aes(y = recovered, color = "recovered"), size = 0.8) +

  scale_y_continuous(limits = c(0, 1*10^5),
                     expand = c(0, 0)) +
  scale_x_date(date_labels = "%Y-%m-%d", 
               breaks = c(as.Date("2020-02-01"), 
                          as.Date("2020-02-11"),
                          as.Date("2020-02-21"),
                          as.Date("2020-03-01"), 
                          as.Date("2020-03-11")),
               limits = c(as.Date("2020-02-01"), as.Date("2020-03-11")),
               expand = c(0, 0)) +
  scale_color_nejm(labels = c("Diagnosted", "Cured")) +
  labs(x = "Date", 
       y = "N of COVID-19 Cases",
       color = "") +
  theme_egraphics +
  theme(legend.position = "top",
        axis.text.x = element_text(angle = 45,
                                   hjust = 1))
ggsave(plot = fig6.11, "figure_tiff/2-02线图/图6.11.pdf",width= 6, height= 5, units="in")

```

