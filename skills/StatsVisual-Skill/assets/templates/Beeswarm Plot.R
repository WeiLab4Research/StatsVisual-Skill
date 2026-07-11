## 蜂群图 | Beeswarm Boxplot

10.9

```{r box-scatter, fig.cap = "江苏省青少年按性别分层身高蜂群图"}

p1 = ggplot(PE_sampling, 
            aes(x = gender, 
                y = height_cm)) +
  stat_boxplot(geom = "errorbar",
               width = 0.05) +
  geom_violin(color = "grey",
              alpha = 0.5,
              aes(fill = gender),
              show.legend = FALSE) +
  geom_beeswarm(aes(x = gender,
                    y = height_cm,
                    color = school_grade),
                alpha = 0.5) +
  scale_y_continuous(limits = c(100, 200),
                     expand = c(0, 0)) +
  scale_color_nejm() +
  scale_fill_nejm() +
  labs(x = "Gender", 
       y = "Height (cm)",
       color = "School Grade") +
  theme_egraphics +
  theme(aspect.ratio = 1.5)

p2 = ggplot(PE_sampling, 
            aes(x = gender, 
                y = height_cm)) +
  stat_boxplot(geom = "errorbar",
               width = 0.05) +
  geom_violin(color = "grey",
              alpha = 0.5,
              aes(fill = gender),
              show.legend = FALSE) +
  geom_jitter(aes(color = school_grade),
              height = 0,
              width = 0.1,
              alpha = 0.5) +
  scale_y_continuous(limits = c(100, 200),
                     expand = c(0, 0)) +
  scale_color_nejm() +
  scale_fill_nejm() +
  labs(x = "Gender", 
       y = "Height (cm)",
       color = "School Grade") +
  theme_egraphics +
  theme(aspect.ratio = 1.5)

# 拼图并共享图例
fig10.9 = p1 + p2 +
  plot_layout(nrow = 1, 
              guides = "collect") & theme(legend.position = 'top')

ggsave(plot = fig10.9, "figure_tiff/2-06箱线图/图10.9.pdf",width= 10, height= 6, units="in")

```

