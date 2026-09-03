## 小提琴图 | Violin Plot

10.8。

```{r box-violin, fig.cap = "江苏省青少年按性别分层身高小提琴图"}

fig10.8 = 
  ggplot(PE, aes(x = gender, 
               y = height_cm)) +
  stat_boxplot(geom = "errorbar",
               width = 0.05) +
  geom_boxplot(aes(color = gender),
               alpha = 0.8, 
               width = 0.05) +
  geom_violin( aes(fill = gender),
               color = "grey", 
               alpha = 0.5,) +
  labs(x = "Gender", 
       y = "Height (cm)") +
  scale_y_continuous(limits = c(100, 200),
                     expand = c(0, 0)) +
  scale_fill_nejm() +
  scale_color_nejm() +
  theme_egraphics +
  theme(aspect.ratio = 1.2)

ggsave(plot = fig10.8, "figure_tiff/2-06箱线图/图10.8.pdf",width= 6, height= 4, units="in")
```

