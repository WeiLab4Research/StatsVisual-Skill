## 时间序列图 | Time Series Plot

6.5。

```{r line-time-series, fig.width=8, fig.height=6, fig.cap = "1990-2009年江苏省细菌性痢疾发病数时间序列分析"}

# 函数用于将时间序列数据转化为数据框
trans = function(x){
  res <- data.frame(value = as.matrix(x), date=time(x))
  res$year <- trunc(res$date)
  res$month <- (res$date - res$year) * 12 + 1
  res$time = paste(res$year,"-",ifelse(res$month<10,
                                       paste(0,res$month,sep = ""),
                                       res$month), sep = "")
  res$time = as.yearmon(res$time)
  res
}

# 读取数据
dysentery_case = read.csv("data/0200_timeseries_liji.csv")

# 原始数据绘图
p1 = ggplot(dysentery_case) +
  geom_line(aes(as.Date(year), case),
            color = "#BC3C29FF",
            size = 0.6,
            alpha = 0.8) +
  scale_x_date(date_labels = "%Y", 
               date_breaks = "5 years",
               limits = c(as.Date("1990-01-01"), as.Date("2010-12-01")),
               expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0),
                     limits = c(0, 25000)) +
  labs(x = "Year", 
       y ="N of Cases",
       title = "Observed Value") +
  theme_egraphics

# 对数变换后数据绘图
p2 = ggplot(dysentery_case) +
  geom_line(aes(as.Date(year), log(case)),
            color = "#BC3C29FF",
            size = 0.6,
            alpha = 0.8) +
  scale_x_date(date_labels = "%Y", 
               date_breaks = "5 years",
               limits = c(as.Date("1990-01-01"), as.Date("2010-12-01")),
               expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0),
                     limits = c(5, 11)) +
  labs(x = "Year",
       y ="Log (Number of Cases)",
       title = "Log Transform") +
  theme_egraphics

# 构建时间序列格式数据
time_data = ts(dysentery_case$case, frequency = 12, start = c(1990, 1))
# 将对数后的数据进行1阶查分
data_d1 = diff(log(time_data), 1)
diff_data = trans(data_d1)

# 1阶差分后数据绘图
p3 = ggplot(diff_data) +
  geom_line(aes(as.Date(time), value),
            color = "#BC3C29FF",
            size = 0.6,
            alpha = 0.8) +
  scale_x_date(date_labels = "%Y", 
               date_breaks = "5 years",
               limits = c(as.Date("1990-01-01"), as.Date("2010-12-01")),
               expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0),
                     limits = c(-1.5, 1.5)) +
  labs(x = "Year", 
       y ="Dlog(N of Cases, 1)",
       title = "1 Order Differenced") +
  theme_egraphics

# 季节性差分
data_d2 = diff(data_d1, 12)
season_data = trans(data_d2)

p4 = ggplot(season_data) +
  geom_line(aes(as.Date(time), value),
            color = "#BC3C29FF",
            size = 0.6,
            alpha = 0.8) +
  scale_x_date(date_labels = "%Y", 
               date_breaks = "5 years",
               limits = c(as.Date("1990-01-01"), as.Date("2010-12-01")),
               expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0),
                     limits = c(-1, 1)) +
  labs(x = "Year",
       y ="Dlog(N of Cases, 12)",
       title = "Seasonally Differenced") +
  theme_egraphics

fig6.5 = 
  plot_grid(p1, p2,
          p3, p4,
          labels = c("A", "B", "C", "D"),
          nrow = 2)

ggsave(plot = fig6.5, "figure_tiff/2-02线图/图6.5.pdf",width= 8, height= 6, units="in")
```

