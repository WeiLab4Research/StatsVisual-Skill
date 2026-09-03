## 气泡图 | Bubble Plot

11.8

```{r scatter-bubble, fig.cap="2011年不同国家GDP与出生时期望寿命的气泡图"}

# 读取数据
pop = read.csv("data/0710_quitebubble.csv")

fig11.8=
ggplot(pop, aes(x = GDP,
                y = life,
                size = people,
                color = region)) +
  geom_point(alpha = 0.5) +
  scale_size(range = c(4, 30)) +
  scale_x_continuous(limits = c(0, 75000), 
                     n.breaks = 10) +
  scale_y_continuous(limits = c(40, 90),
                     expand = c(0, 0)) +
  geom_smooth(method = "loess",
              span = 0.4,
              se = TRUE,
              color = "#9900CC",
              fill = "#9900CC",
              alpha = 0.1) +
  scale_color_viridis(discrete = T,
                      option = "viridis") +
  labs(y = "Life expectancy at birth") +
  theme_egraphics +
  theme(legend.position = "none")

ggsave(plot = fig11.8, "figure_tiff/2-07散点图/图11.8.pdf",width= 8, height= 6, units="in")

```

