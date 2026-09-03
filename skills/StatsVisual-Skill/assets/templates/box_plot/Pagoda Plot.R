## 雁塔图

10.7

```{r yanta-box, fig.cap="江苏省女生身高雁塔图"}

# 处理身高数据，仅展示中位数一侧的数据进行绘制
PE_female$new_height = ifelse(PE_female$height_cm > 178,
                              178, PE_female$height_cm)
PE_female$new_height = ifelse(PE_female$new_height >= median(PE_female$new_height), 
                              PE_female$new_height, 
                              median(PE_female$new_height))

# 定义色谱
colo = paletteer_c("ggthemes::Red-Blue-White Diverging", 30)

fig10.7 = 
  ggplot(PE_female, aes(y = new_height, x = gender)) +
  geom_lv(aes(fill=..LV..), color = "black", k = 10,
          outlier.colour = "#FFB0A1FF",
          outlier.size = 2,
          show.legend = FALSE) +
  scale_y_continuous(limits = c(155, 185),
                     expand = c(0, 0)) +
  scale_fill_manual(values = colo) +
  labs(x = "Gender",
       y = "Height (cm)",
       fill = "") +
  theme_egraphics +
  theme(aspect.ratio = 1)

ggsave(plot = fig10.7, "figure_tiff/2-06箱线图/图10.7.pdf",width= 6, height= 4, units="in")

```

