## 细腰箱线图 | Notched Boxplot

10.5。

```{r box-notched, fig.cap = "江苏省青少年按性别分层身高细腰箱线图"}

fig10.5 = 
  ggplot(PE_sampling, aes(x = gender,
                        y = height_cm,)) +
  stat_boxplot(geom = "errorbar", 
               width = 0.2) +
  geom_boxplot(aes(fill = gender),
               alpha = 0.8,
               width = 0.5,
               notch = TRUE,
               notchwidth = 0.3) +
  scale_y_continuous(limits = c(100, 200),
                     n.breaks = 5,
                     expand = c(0, 0)) +
  scale_fill_nejm() +
  labs(x = "Gender", 
       y = "Height (cm)",
       fill = "") +
  theme_egraphics +
  theme(aspect.ratio = 1.5)

ggsave(plot = fig10.5, "figure_tiff/2-06箱线图/图10.5.pdf",width= 6, height= 4, units="in")

```

