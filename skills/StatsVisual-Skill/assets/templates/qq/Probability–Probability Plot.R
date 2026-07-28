## PP图 | Probability–Probability plot

14.5。

```{r basic-qqplot2,fig.height=5, fig.width=5, fig.cap="江苏省高中男生BMI PP图"}

fig14.5  = 
  ggplot(bmi_men, aes(sample = scale(bmi))) +
  stat_pp_line(color = "#BC3C29FF") +
  stat_pp_point(color = "#0072B5FF", size = 1.2) +
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0)) +
  labs(x = "Probability Points",
       y = "Cumulative Probability") +
  theme_egraphics

ggsave(plot = fig14.5, "figure_tiff/2-10QQ图/图14.5.pdf",width = 6, height= 5, units="in")
```

