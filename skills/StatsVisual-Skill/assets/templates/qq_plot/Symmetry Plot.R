## 对称性诊断 | Symmetry Plot

14.6。

```{r symmetry,fig.height=5, fig.width=10, fig.cap="高中生BMI指数对称性诊断图"}

# 自建函数用于绘制对称性诊断图
symplot <- function(d){
  n <- length(d)  #sample size
  no <- floor((n + 1) / 2)
  sd <- sort(d)
  i <- 1 : no
  ylab <- sd[n + 1 - i] - median(d)
  xlab <- median(d) - sd[i]
  ggplot(data.frame(xlab, ylab),
         aes(xlab, ylab)) +
    geom_point(size = 1.5, color = "#0072B5FF") 
}

# draw basic plot
p1 = symplot(bmi_men$bmi)

##redraw
p1 = p1 + geom_abline(slope = 1, color = "#BC3C29FF") +
  scale_x_continuous(limits = c(0, 8), breaks = seq(0, 10, 2), expand = c(0, 0)) +
  scale_y_continuous(limits = c(0, 20), expand = c(0, 0)) +
  labs(x = "Distance Below Median", y = "Distance Above Median") +
  theme_egraphics

##histogram
p2 = ggplot(bmi_men) + 
  geom_histogram(aes(x = bmi), binwidth = 1, color = "white",
                 fill = "#0072B5FF", alpha = 0.8) +
  scale_x_continuous(limits = c(0, 40), expand = c(0, 0)) +
  scale_y_continuous(limits = c(0, 80), expand = c(0, 0)) +
  labs(x = "BMI", y = "Frequency") +
  theme_egraphics

fig14.6 = plot_grid(p1, p2 ,
          ncol = 2,
          labels = c("A", "B"))

ggsave(plot = fig14.6, "figure_tiff/2-10QQ图/图14.6.pdf",width = 10, height= 5, units="in")

```