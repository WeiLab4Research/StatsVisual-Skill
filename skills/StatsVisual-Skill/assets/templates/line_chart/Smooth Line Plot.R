## 平滑折线图 | Smooth Line Plot

6.6。

```{r line-smooth,fig.height=6, fig.cap = "1990-2009年江苏省细菌性痢疾发病数ARIMA模型拟合"}

# 加载自写函数
source("rcode/0200_hamonics.r")
# 谐波分析模型
fit_harmonic = harmonics_model(user_vals = dysentery_case$case,
                               user_dates = as.Date(dysentery_case$year),
                               harmonic_deg = 3)

# 将原始数据与谐波分析后的病例数合并
df_combine = cbind(dysentery_case, fit_harmonic)
# 修改数据集列名
names(df_combine) <- c("year", "case", "fit")

p1 = ggplot(df_combine) +
  geom_point(aes(x = as.Date(year), y = case), 
             color="black",
             size = 0.8) +
  geom_line(aes(x = as.Date(year), y = fit), 
            colour =  "#BC3C29FF",
            size = 0.8) +
  scale_y_continuous(expand = c(0, 0),
                     limits = c(0, 25000)) +
  labs(x = "Date",
       y ="N of Cases") +
   theme_egraphics

# 拟合ARIMA模型
fit_arima = Arima(time_data, 
                  order = c(1, 0, 2),
                  seasonal = c(2, 1, 1))

# 数据转换
arima = fit_arima$fitted
arima_data = trans(arima)

p2 = ggplot() +
  geom_point(data = dysentery_case,
             aes(as.Date(year), case),
             color =  "#BC3C29FF",
             size = 0.8) +
  geom_line(data = arima_data,
            aes(as.Date(time), value),
            color = "grey60",
            size = 0.8) +
  scale_x_date(date_labels = "%Y", 
               date_breaks = "5 years",
               limits = c(as.Date("1990-01-01"), as.Date("2010-12-01")),
               expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0),
                     limits = c(0, 25000)) +
  labs(x = "Year", 
       y = "N of Cases") +
  theme_egraphics

fig6.6 = 
  plot_grid(p1, p2,
          labels = c("A", "B"),
          nrow = 2)

ggsave(plot = fig6.6, "figure_tiff/2-02线图/图6.6.pdf",width= 6, height= 6, units="in")

```

