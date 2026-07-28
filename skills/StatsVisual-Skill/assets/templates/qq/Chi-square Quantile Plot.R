## 卡方分位数图 | Chi-Square Quantile

14.7。

```{r Chi-square-qq, fig.width=10, fig.height=5, fig.cap="卡方分布QQ图"}

chisquare = data.frame(y = rchisq(500, df = 3))

p1 = ggplot(chisquare, aes(sample = y)) +
  stat_qq(distribution = function(p) qchisq(p, df = 3), col = "#0072B5FF") +
  scale_x_continuous(limits = c(0, 20), expand = c(0, 0)) +
  scale_y_continuous(limits = c(0, 20), expand = c(0, 0)) +
  labs(x = "", y = "Sample") +
  theme_egraphics

p2 = ggplot(chisquare, aes(sample = y)) +
  stat_pp_point(color = "#0072B5FF") +
  stat_pp_line(color = "#BC3C29FF") +
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0)) +
  labs(x = expression("Theoretical" ~~ {chi^2}[nu == 3]),
       y = "Sample") +
  theme_egraphics

fig14.7 = 
  plot_grid(p1, p2,
          ncol = 2,
          align = "v")

ggsave(plot = fig14.7, "figure_tiff/2-10QQ图/图14.7.pdf",width = 10, height= 5, units="in")

```

