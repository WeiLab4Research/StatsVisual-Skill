## 凹凸曲线回归 | Convex Concave Curve Regression
fig18.3

```{r con-reg, fig.height=6, fig.cap = "凹凸函数回归案例"}

# 加载数据
data("DNase")

p_expg = ggplot(DNase, aes(conc, density)) +
  geom_point(aes(color = Run), show.legend = F) +
  stat_smooth(method = "nls",
              method.args = list(
                formula = y ~ a * exp(k * x),
                start = list(a = 0.2, k = 0.2)),
              se = FALSE,
              color = "#0072B5FF") +  
  scale_y_continuous(expand = c(0, 0.1)) +
  scale_x_continuous(expand = c(0.01, 0)) +
  coord_cartesian(clip = "off") +
  labs(subtitle = "Exponential Growth", 
       x = "Concentration", 
       y = "Density") +  
  theme_egraphics


# 加载数据
data("degradation")

p_expd = ggplot(degradation, aes(Time, Conc)) +
  geom_point(color = "#BC3C29FF", size = 2) +
  stat_smooth(method = "nls",
              data = degradation,
              aes(x = Time, y = Conc),
              method.args = list(
                formula = y ~ a - (b - a)*exp(-x/c),
                start = list(a = 0, b = 99, c = 14)),
              se = FALSE,
              color = "#0072B5FF") +
  scale_y_continuous(expand = c(0, 0.1), 
                     limits = c(0, 110), 
                     breaks = c(0, 20, 40, 60, 80, 110)) +
  scale_x_continuous(expand = c(0, 0), 
                     limits = c(0, 80)) +
  coord_cartesian(clip = "off") +
  labs(subtitle = "Exponential Decay", 
       x = "Concentration", 
       y = "Density") +  
  theme_egraphics

p_a = ggplot(DNase, aes(conc, density)) +
  geom_point(aes(color = Run), show.legend = F) +
  stat_smooth(method = "nls",
              data = DNase,
              aes(x = conc, y = density),
              method.args = list(
                formula = y ~ a - (a - b) * exp(-c * x),
                start = list(a = 3, b = 0, c = 1)),
              se = FALSE,
              color = "#0072B5FF") +
  scale_y_continuous(expand = c(0, 0.1)) +
  scale_x_continuous(expand = c(0.01, 0)) +
  coord_cartesian(clip = "off") +
  labs(subtitle = "Asymptotic", 
       x = "Concentration", 
       y = "Density") +  
  theme_egraphics

p_p = ggplot(DNase, aes(conc, density)) +
  geom_point(aes(color = Run), show.legend = F) +
  stat_smooth(method = "nls",
              method.args = list(
                formula = y ~ a * x^b,
                start = list(a = 0.4, b = 0.6)),
              se = FALSE) +
  scale_y_continuous(expand = c(0, 0.1)) +
  scale_x_continuous(expand = c(0.01, 0)) +
  coord_cartesian(clip = "off") +
  labs(subtitle = "Power", 
       x = "Concentration", 
       y = "Density") +  
  theme_egraphics

p_log = ggplot(DNase, aes(conc, density)) +
  geom_point(aes(color = Run), show.legend = F) +
  stat_smooth(method = "nls",
              method.args = list(
                formula = y ~ a + b*log(x),
                start = list(a = 0.4, b = 0.6)),
              se = FALSE,
              color = "#0072B5FF") +
  scale_y_continuous(expand = c(0, 0.1)) +
  scale_x_continuous(expand = c(0.01, 0)) +
  coord_cartesian(clip = "off") +
  labs(subtitle = "Logarithmic fit", 
       x = "Concentration", 
       y = "Density") +  
  theme_egraphics
  

p_rec = ggplot(DNase, aes(conc, density)) +
  geom_point(aes(color = Run), show.legend = F) +
  stat_smooth(method = "nls",
              method.args = list(
                formula = y ~ a * x / (b + x),
                start = list(a = 2, b = 3)),
              se = FALSE,
              color = "#0072B5FF") +
  scale_y_continuous(expand = c(0, 0.1)) +
  scale_x_continuous(expand = c(0.01, 0)) +
  coord_cartesian(clip = "off") +
  labs(subtitle = "Rectangular hyperbola fit", 
       x = "Concentration", 
       y = "Density") +  
  theme_egraphics
  
fig18.3 = plot_grid(p_expg, p_expd, p_a, p_p, p_log, p_rec,
          nrow = 3, ncol = 2, labels = "AUTO")

ggsave(plot = fig18.3, "figure_tiff/2-14非线性回归/图18.3.pdf",width = 6, height= 6, units="in")

```

