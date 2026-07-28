## 增强箱线图 | Boxenplot

10.6。

```{r boxenplot, fig.width=9, fig.cap="江苏省青少年按学制等级、性别分组的增强箱线图"}

p1 = ggplot(PE, aes(y = height_cm, x = gender)) +
  geom_lv(aes(fill = after_stat(LV)), 
          color = "black",
          k = 9,
          show.legend = FALSE) +
  scale_y_continuous(limits = c(70, 200),
                     expand = c(0, 0)) +
  scale_fill_brewer() +
  labs(x = "Gender",
       y = "Height (cm)",
       fill = "") +
  theme_egraphics +
  theme(aspect.ratio = 1)

p2 = ggplot(PE, aes(y = height_cm, x = school_grade)) +
  geom_lv(aes(fill = after_stat(LV)), 
          color = "black", 
          k =9,
          show.legend = FALSE) +
  scale_y_continuous(limits = c(70, 200),
                     expand = c(0, 0)) +
  scale_fill_brewer() +
  labs(x = "School Grade",
       y = "Height (cm)",
       fill = "") +
  theme_egraphics +
  theme(legend.position = "right",
        aspect.ratio = 0.35,
        legend.key.size = unit(0.3, 'cm'),
        legend.text = element_text(size = 8))

fig10.6 = 
  plot_grid(
  p1,
  p2,
  rel_widths = c(0.3, 0.7),
  labels = c("A", "B"),
  ncol = 2,
  axis = "b")

ggsave(plot = fig10.6, "figure_tiff/2-06箱线图/图10.6.pdf",width= 9, height= 4, units="in")


```

