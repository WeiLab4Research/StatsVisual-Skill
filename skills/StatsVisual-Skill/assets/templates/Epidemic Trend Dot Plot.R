## 疫情点图
据统计，从2020年5月我国第一波新冠疫情结束，至2022年2月7日，我国本土局部疫情累计病例数大于等于50例的共涉及27个城市，本例使用点图展示了新冠局部疫情此起彼伏之势(图\@ref(fig:ncov))，可同时参考对比直方图章节中峰峦图。

```{r ncov, fig.height= 4, fig.width= 8, fig.cap=""}

ds_covid = read.csv("data/0400_covid_ridges.csv", fileEncoding = "GBK")

ds_covid$label = factor(ds_covid$label, 
                        levels = rev(unique(ds_covid$label)))

stripe_data <- data.frame(
  ymin = seq(0.5, length(unique(ds_covid$label)) - 0.5, by = 1),
  ymax = seq(1.5, length(unique(ds_covid$label)) + 0.5, by = 1),
  xmin = as.Date("2020-05-15"),
  xmax = as.Date("2022-03-01"))

# 本例所需颜色较多，提取多种期刊颜色
colo = c(pal_nejm("default")(8), 
         pal_jama("default")(7),
         pal_lancet()(9),
         pal_npg()(10))

fig9.9 = 
   ggplot(ds_covid,
      aes(x = as.Date(date), y = label,
          fill = label,
          size = dailyconfirm)) +
  geom_rect(data = stripe_data,
            aes(xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax),
            fill = rep(c("grey90","white"), 
                       length.out = nrow(stripe_data)),
            inherit.aes = FALSE)+
  geom_point(color = grey(0.4), 
             alpha = 1, 
             shape = 21, 
             stroke = 0.3) +
  scale_x_date(expand = c(0, 0),
               date_labels = "%Y-%m",
               breaks = seq(as.Date("2020-06-01"), as.Date("2022-02-15"), 
                            by = "2 month")) +
  labs(x = "Date",
       y = "Region") +
  guides(color = "none",
         fill = "none",
         size = guide_legend(title = "Dailyconfirm",
                             label.theme = element_text(size = 10))) +
  scale_size_continuous(range = c(1, 6),
                        breaks = c(1, 10, 50, 100, 150)) +
  scale_fill_manual(values = rep(colo, 1)) +
  theme_classic()+
  theme(axis.text.x = element_text(size = 11,
                                   color = "black"),
    axis.text.y = element_text(hjust = 1,
                               vjust = 0.5,
                               size = 11,
                               color = "black"),
    axis.title = element_text(size = 12),
    plot.margin = margin(0.3, 0.3, 0.3, 0.3, "cm"))

ggsave(plot = fig9.9, "figure_tiff/2-05点图/图9.9.pdf",width= 12, height= 8, units="in")


```


