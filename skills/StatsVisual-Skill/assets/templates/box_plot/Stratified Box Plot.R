## 分层箱线图 | Stratified Boxplot

10.4。

```{r box-stratify, fig.width=8, fig.height=4, fig.cap = "江苏省青少年按学制等级、性别分组的箱线图"}

p1 = ggplot(PE_sampling, aes(y = height_cm, 
                             x = gender)) +
  stat_boxplot(geom = "errorbar",
               width = 0.2) +
  geom_boxplot(aes(color = gender),
               alpha = 0.5, 
               width = 0.5) +
  scale_y_continuous(limits = c(70, 200),
                     expand = c(0, 0)) +
  scale_color_nejm() +
  labs(x = "Gender",
       y = "Height (cm)",
       color = "") +
  theme_egraphics 

p2 = ggplot(PE, aes(y = height_cm, 
                    x = school_grade, 
                    fill = gender)) +
  stat_boxplot(geom = "errorbar", 
               width = 0.5) +
  geom_boxplot(alpha = 0.5, 
               width = 0.5) +
  scale_y_continuous(limits = c(70, 200),
                     expand = c(0, 0)) +
  scale_fill_nejm() +
  labs(x = "School Grade",
       y = "Height (cm)",
       fill = "") +
  theme_egraphics +
  theme(legend.position = "top")

fig10.4 = 
  plot_grid(
  p1,
  p2,
  rel_widths = c(0.35, 0.65),
  labels = c("A", "B"),
  ncol = 2)

ggsave(plot = fig10.4, "figure_tiff/2-06箱线图/图10.4.pdf",width= 8, height= 4, units="in")
```

