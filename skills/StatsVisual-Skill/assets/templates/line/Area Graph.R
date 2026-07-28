## 面积图 | Area Graph

6.7。

```{r line-area, fig.cap = "美国纽约人群新冠疫苗接种率之趋势"}

# 读取数据
nyc_vaccine = read.csv("data/0200_NYC_vaccine.csv")

fig6.7 = 
  ggplot(nyc_vaccine, aes(as.Date(date))) +
  geom_area(aes(y = fcount, fill = "fcount"), alpha = 0.5) +
  geom_area(aes(y = pcount, fill = "pcount"), alpha = 0.5) +
  scale_x_date(date_labels = "%Y-%m-%d", 
               date_breaks = "1 months",
               expand = c(0, 0)) +
  scale_y_continuous(breaks = seq(0, 100, 10), 
                     limits = c(0, 100),
                     expand = c(0, 0)) +
  scale_fill_brewer(palette = "Pastel1",
                    labels = c("Completed",
                               "Incompleted")) +
  labs(x = "Date",
       y = "Vaccinated Proportion (%)", 
       fill = "") +
  theme_egraphics + 
  theme(legend.position = "inside",
        legend.position.inside = c(0.15, 0.9),
        axis.text.x = element_text(angle = 45,
                                   hjust = 1))

ggsave(plot = fig6.7, "figure_tiff/2-02线图/图6.7.pdf",width= 6, height= 4, units="in")

```

