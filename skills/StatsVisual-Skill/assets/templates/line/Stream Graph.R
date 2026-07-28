## 量化波形图 | Stream Graph

6.10。

```{r line-river, fig.width=10, fig.height=6, fig.cap = "美国等国家新冠每日新增病例河流图"}

# 读取数据
world_covid = read.csv("data/0200_gradient.csv", stringsAsFactors = FALSE)
world_covid$date = as.Date(world_covid$date)

cols = colorRampPalette(rev(brewer.pal(11, "RdYlBu")))(10)

fig6.10 = 
  ggplot(world_covid, aes(x = date, y = new,
                group = country, 
                fill = country)) +
  geom_stream(color = "white", lwd = 0.5) +
  geom_hline(yintercept = 0,
             linetype = "dashed") +
  scale_fill_manual(values = cols) +
  scale_x_date(date_labels = "%Y-%m-%d", 
               date_breaks = "3 months",
               limits = c(as.Date("2020-01-01"), as.Date("2021-11-01")),
               expand = c(0, 0)) +
  scale_y_continuous(limits = c(-3*10^5, 3*10^5),
                     labels = function(x) format(abs(x), scientific = FALSE, trim = TRUE),
                     expand = c(0, 0)) +
  labs(x = "Date", 
       y = "Cases Number", 
       fill = "") +
  theme_egraphics +
    theme(legend.position = "right",
          axis.text.x = element_text(angle = 45,
                                   hjust = 1))

ggsave(plot = fig6.10, "figure_tiff/2-02线图/图6.10.pdf",width= 10, height= 6, units="in")

```

