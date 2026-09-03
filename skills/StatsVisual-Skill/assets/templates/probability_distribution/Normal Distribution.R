# 概率和统计分布 | Probabilistic and Statistical Distribution

## 正态分布 | Normal Distribution
15.1

```{r normal-distribution, fig.width=6, fig.height=8, fig.cap="不同参数下的正态分布"}


source("rcode/libraries.r")
source("rcode/wishart_VisCov.r")

ds_height = read.csv("data/1000_normal_height.csv")

##set default color
cols = pal_nejm("default")(2)

# generate dataset
x = seq(-8, 8, 0.1)
# different mu
ymu = c(dnorm(x, 0, 1), dnorm(x, 4, 1))
# different sigma
ysigma = c(dnorm(x, 0, 1), dnorm(x, 0, 2))
group = rep(c(1, 2), each = (length(ymu) / 2))
data_normal = as.data.frame(cbind(c(x, x), ymu, ysigma, group))
data_normal$group = factor(data_normal$group)

p1 = ggplot(data_normal, aes(V1, ymu, group = group, color = group)) +
  geom_line(size = 1.2) +
  geom_vline(xintercept = c(0, 4),
             size = 1.2,
             linetype = "dashed") +
  scale_x_continuous(expand = c(0, 0),
                     limits = c(-8, 8),
                     breaks = seq(-8, 8, 1)) +
  scale_y_continuous(expand = c(0, 0.01), 
                     limits = c(0, 0.5)) +
  scale_color_nejm(labels = c(expression(paste(italic("μ"), "=0")),
                              expression(paste(italic("μ"), "=4")))) +
  labs(x = "x", y = "Density", color = "") +
  coord_cartesian(clip = "off") +
  theme_pubr() +
  theme_egraphics


p2 = ggplot(data_normal, aes(V1, ysigma, group = group, color = group)) +
  geom_line(size = 1.2) +
  scale_x_continuous(
    expand = c(0, 0),
    limits = c(-8, 8),
    breaks = seq(-8, 8, 1)
  ) +
  scale_y_continuous(expand = c(0, 0.01), limits = c(0, 0.5)) +
  scale_color_nejm(labels = c(expression(paste(italic("σ"), "=1")),
                              expression(paste(italic("σ"), "=2")))) +
  labs(x = "x", y = "Density",color = "") +
  coord_cartesian(clip = "off") +
  theme_pubr() +
  theme_egraphics

fig15.1 = 
  plot_grid(p1, p2,
          labels = c("A", "B"),
          nrow = 2)

ggsave(plot = fig15.1, "figure_tiff/2-11数据分布/图15.1.pdf",width = 6, height= 8, units="in")

```