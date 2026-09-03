## 线图叠加误差线 | Line Plot with Errorbar

6.4。

```{r line-errorbar, warning=FALSE, fig.cap="16周内6分钟步行距离较基线的平均变化情况"}

# 读取数据
change_6mwd = read.csv("data/0200_errorbarline.csv")
# 该数据为自制数据，用于绘制图例
legend_6mwd = data.frame(label = c("a","b","c"),
                         x = c(1, 2, 3),
                         y = c(2, 3, 3))

# 绘制主图
p1 = ggplot(change_6mwd) +
  geom_errorbar(aes(x = week, 
                    ymin = observed_value - observed_se,
                    ymax = observed_value + observed_se, 
                    color = label),
                size = 0.8, width = 0, alpha = 1) +
  geom_line(aes(x = week, 
                y = observed_value, 
                color = label),
            size = 1.2, alpha = 1) +
  geom_point(aes(x = week, 
                 y = observed_value),
             shape = 1, color = "black", size = 2, alpha = 1) +
  geom_errorbar(aes(x = week + 0.15, 
                    ymin = mmrm_value - mmrm_se,
                    ymax = mmrm_value + mmrm_se,
                    color = label),
                size = 0.8, width = 0, alpha = 1) +
  geom_point(aes(x = week + 0.15, 
                 y = mmrm_value, 
                 group = label),
             shape = 8, size = 2) +
  geom_errorbar(aes(x = week + 0.3, 
                    ymin = mcmc_value - mcmc_se,
                    ymax = mcmc_value + mcmc_se, 
                    color = label),
                size = 0.8, width = 0, alpha = 1) +
  geom_point(aes(x = week + 0.3, 
                 y = mcmc_value, 
                 group = label),
             shape = 0, size = 2) +
  geom_hline(yintercept = 0, 
             linetype = "dashed") +
  scale_color_manual(values = c("#BC3C29FF", "grey60")) + 
  scale_x_continuous(limits = c(0, 17),
                     breaks = seq(0, 16, 4),
                     expand = c(0, 0.1)) +
  scale_y_continuous(limits = c(-20, 30), 
                     breaks = seq(-20, 30, 5), 
                     expand = c(0,0)) +
  labs(x = "Weeks since Intervention",
       y = "Change in 6MWD from Baseline (m)") +
  coord_cartesian(clip = "off",
                  xlim = c(0, 16)) +
  theme_egraphics +
  theme(legend.position = "none")

# 绘制图形，无实际意义，仅用于提取图例
p2 = ggplot(legend_6mwd) + 
  geom_point(aes(x = x, y = y, shape = label), size = 5) + 
  scale_shape_manual(name = "Legend",
                     labels = c("Observed", "MMRM", "MCMC"),
                     values = c(1, 8, 0)) +
  theme_pubr()  +
  theme(legend.title = element_blank(),
        legend.position = "top",
        legend.key.size = unit(1, "lines"),
        legend.text = element_text(size = 14,
                                   margin = margin(r = 10, unit = "pt")),
        legend.box.margin = margin(0, 0, 0, 0),
        plot.margin = margin(6, 0, 6, 0))

# 提取图例
legend = get_plot_component(p2, 'guide-box-top', return_all = TRUE)

# 将主图与图例进行拼接处理
fig6.4 = 
  plot_grid(legend,
          p1,
          nrow = 2,
          vjust = -3,
          rel_heights = c(0.15:2))

ggsave(plot = fig6.4, "figure_tiff/2-02线图/图6.4.pdf",width= 6, height= 4, units="in")

```

