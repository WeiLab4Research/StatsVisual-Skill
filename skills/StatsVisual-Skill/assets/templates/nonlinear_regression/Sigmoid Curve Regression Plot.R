## S型曲线回归 | Sigmoidal Curve Regression

18.4

```{r scurve-reg, fig.height=4, fig.cap = "S型曲线回归案例"}


p_l3 = ggplot(DNase, aes(conc, density)) +
  geom_point(aes(color = Run), show.legend = F) +
  stat_smooth(method = "nls",
              method.args = list(
                formula = y ~ d / (1 + exp(-b * (x - e))),
                start = list(d = 1, b = 1, e = 1)),
              se = FALSE,
              color = "#0072B5FF") +  
  scale_y_continuous(expand = c(0, 0.1)) +
  scale_x_continuous(expand = c(0.01, 0)) +
  coord_cartesian(clip = "off") +
  labs(subtitle = "Logistic / 3 params", 
       x = "Concentration", 
       y = "Density") +  
  theme_egraphics

## Gompertz, 3 parameters

p_g3 = ggplot(DNase, aes(conc, density)) +
  geom_point(aes(color = Run), show.legend = F) +
  stat_smooth(method = "nls",
              method.args = list(
                formula = y ~ d * exp(-exp(-b * (x - e))),
                start = list(d = 1, b = 1, e = 1)),
              se = FALSE,
              color = "#0072B5FF") +  
  scale_y_continuous(expand = c(0, 0.1)) +
  scale_x_continuous(expand = c(0.01, 0)) +
  coord_cartesian(clip = "off") +
  labs(subtitle = "Gompertz / 3 params", 
       x = "Concentration", 
       y = "Density") +  
  theme_egraphics

## Log-logistic, 3 parameters

p_ll3 = ggplot(DNase, aes(conc, density)) +
  geom_point(aes(color = Run), show.legend = F) +
  stat_smooth(method = "nls",
              method.args = list(
                formula = y ~ d /(1 +  exp(-b * (log(x) - log(e)))),
                start = list(d = 1, b = 1, e = 1)),
              se = FALSE,
              color = "#0072B5FF") +  
  scale_y_continuous(expand = c(0, 0.1)) +
  scale_x_continuous(expand = c(0.01, 0)) +
  coord_cartesian(clip = "off") +
  labs(subtitle = "Log-logistic / 3 params", 
       x = "Concentration", 
       y = "Density") + 
  theme_egraphics

## Weibull, type 1

p_w3 = ggplot(DNase, aes(conc, density)) +
  geom_point(aes(color = Run), show.legend = F) +
  stat_smooth(method = "nls",
              method.args = list(
                formula = y ~ d * exp(-exp(-b * (log(x) - log(e)))),
                start = list(d = 5, b = 0.3, e = 15)),
              se = FALSE,
              color = "#0072B5FF") +  
  scale_y_continuous(expand = c(0, 0.1)) +
  scale_x_continuous(expand = c(0.01, 0)) +
  coord_cartesian(clip = "off") +
  labs(subtitle = "Weibull / 3 params", 
       x = "Concentration", 
       y = "Density") + 
  theme_egraphics

fig18.4 = 
  plot_grid(p_l3, p_g3, p_ll3, p_w3, 
          nrow = 2, ncol = 2, labels = "AUTO")

ggsave(plot = fig18.4, "figure_tiff/2-14非线性回归/图18.4.pdf",width = 6, height= 4, units="in")

```
