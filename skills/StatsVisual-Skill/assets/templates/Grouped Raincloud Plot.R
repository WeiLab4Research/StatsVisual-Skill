## 堆叠云雨图 | Stacked RainCloud Plot

10.12。

```{r box-raincloud, fig.width=6,fig.cap="江苏省青少年按性别、学校分层身高堆叠云雨图"}

fig10.12 = 
  ggplot(PE_sampling, aes(x = gender, 
                        y = height_cm, 
                        fill = school_grade )) +
  geom_flat_violin(position = position_nudge(x = 0.1, y = 0), 
                   adjust = 1.5, 
                   trim = FALSE, 
                   alpha = 0.5, 
                   color = NA) +
  geom_point(aes(x = as.numeric(factor(gender)) - 0.15, 
                 y = height_cm, 
                 color = school_grade),
             position = position_jitter(width = 0.05, height = 0),
             size = 1,
             shape = 20) +
  geom_boxplot(outlier.shape = NA, 
               alpha = 0.5, 
               width = 0.1, 
               colour = "black") +
  scale_y_continuous(limits = c(100, 200),
                     expand = c(0, 0)) +
  scale_fill_nejm() +
  scale_color_nejm() +
  labs(x = "Gender", 
       y = "Height (cm)",
       fill = "",
       color = "") +
  theme_egraphics + 
  theme(legend.position = "top")

ggsave(plot = fig10.12, "figure_tiff/2-06箱线图/图10.12.pdf",width= 6, height= 4, units="in")

```


# 散点图 | Scatter Plot

