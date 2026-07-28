## 散点图+平滑曲线图 | Smoothing Curve by Spline/LOESS/Polynomial

11.5。

```{r scatter-curve, fig.width=10, fig.cap="江苏青少年身高体重平滑曲线图"}

smooth = read.csv("data/0710_smooth_data.csv")

p1 = ggplot(smooth, aes(height_cm, weight_kg)) +
  geom_point(fill = "black",
             color = "black",
             size = 2,
             shape = 21) +
  geom_smooth(method = "loess",
              span = 0.4,
              se = TRUE,
              color = "#00A5FF",
              fill = "#00A5FF",
              alpha = 0.2) +
  scale_x_continuous(limits = c(100, 170),
                     breaks = seq(100, 170, 10),
                     expand = c(0, 0)) +
  scale_y_continuous(limits = c(0, 100),
                     expand = c(0, 0)) +
  labs(x = "Height(cm)", 
       y = "Weight(kg)") +
  theme_egraphics


p2 = ggplot(smooth, aes(height_cm, weight_kg)) +
  geom_point(fill = "black",
             color = "black",
             size = 2,
             shape = 21) +
  geom_smooth(method = "lm",
              span = 0.4,
              se = TRUE,
              color = "#9900CC",
              fill = "#9900CC",
              alpha = 0.2) +
  scale_x_continuous(limits = c(100, 170),
                      breaks = seq(100, 170, 10),
                     expand = c(0, 0)) +
  scale_y_continuous(limits = c(0, 100),
                     expand = c(0, 0)) +
  labs(x = "Height(cm)", 
       y = "Weight(kg)") +
  theme_egraphics

fig11.5 = 
  plot_grid(p1,
          p2,
          rel_widths = c(0.5, 0.5),
          labels = c("A", "B"))

ggsave(plot = fig11.5, "figure_tiff/2-07散点图/图11.5.pdf",width= 10, height= 4, units="in")


```

