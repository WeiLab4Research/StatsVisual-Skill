## 云雨图 | RainCloud Plot

10.11。

```{r box-shadow, fig.cap = "江苏省青少年按性别分层身高云雨图"}

fig10.11 = 
  ggplot(PE_sampling, aes(x = gender, 
                        y = height_cm)) +
  stat_halfeye(aes(fill = gender),
               adjust = 0.5,
               width = 0.5,
               .width = c(0.5, 1),
               alpha = 0.5) +
  geom_boxplot(width = 0.05) +
  stat_dots(side = "left",
            dotsize = 0.4,
            justification = 1.05,
            binwidth = 2) +
  scale_y_continuous(limits = c(100, 200),
                     expand = c(0, 0)) + 
  scale_fill_nejm() +
  labs(x ="Gender",
       y = "Height (cm)") +
  coord_flip() +
  theme_egraphics +
  theme(aspect.ratio = 1,
        legend.position = "none")

ggsave(plot = fig10.11, "figure_tiff/2-06箱线图/图10.11.pdf",width= 6, height= 4, units="in")

```

