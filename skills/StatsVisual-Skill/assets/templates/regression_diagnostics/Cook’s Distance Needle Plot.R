## Cook距离诊断 | Rgeression Cook's Distance Diagnostics

19.7

```{r linear-diag-cookd, fig.width=6, fig.height=6, fig.cap ="Cook距离诊断针板图"}

fig19.7 = 
  gg_cooksd(lmfit) +
  scale_y_continuous(expand = c(0, 0), 
                     limits = c(0, 0.06)) +
  scale_x_continuous(expand = c(0, 0),
                     limits = c(0, 300)) +
  ggtitle("") +
  theme_egraphics

ggsave(plot = fig19.7, "figure_tiff/2-15回归模型诊断/图19.7.pdf",width = 6, height= 6, units="in")

```

