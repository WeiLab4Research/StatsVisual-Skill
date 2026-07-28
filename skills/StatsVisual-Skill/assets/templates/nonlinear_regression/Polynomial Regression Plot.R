# 非线性回归 | Nonlinear Regression

18.2
```{r polynormial-reg, fig.height=3, fig.cap = "汽车撞击后时间和假人头部加速度的多项式回归"}

# 加载本章节所需程序包
library(ggpubr)
library(ggsci)
library(cowplot)
library(aomisc)

# 设置图形基本背景
theme_egraphics = 
  theme_pubr() + 
  theme(axis.title.y = element_text(margin = margin(t = 0, r = 10, 
                                                    b = 0, l = 0)),
        axis.title.x = element_text(margin = margin(t = 10, r = 0, 
                                                    b = 0, l = 0)),
        axis.title = element_text(size = 13, face = "bold"),
        axis.line = element_line(linewidth = 0.6, color = "black"),
        axis.ticks = element_line(size = 0.3),
        axis.ticks.length = unit(.15, "cm"),
        axis.text  = element_text(size = 10),
        plot.margin = margin(.5, .5, .5, .5, "cm"))

# 读取数据
vehicle = read.csv("data/1201_polynormial.csv")

# 通过5折交叉验证，获取最佳阶数参数
cv.MSE = c()
for (i in 1:10) {
  set.seed(2023)
  polyfit = glm(accel ~ poly(time, degree = i), data = vehicle)
  # 保存模型拟合过程中误差
  cv.MSE[i] =  boot::cv.glm(vehicle, polyfit, K = 5)$delta[1]
}

vehicle_mse = data.frame(x = 1:length(cv.MSE),y = cv.MSE)
# 交叉验证结果
p1 = ggplot(vehicle_mse, aes(x, y)) +
  geom_line(color = "#0072B5FF", linewidth = 1.2) +
  geom_point(color = "#BC3C29FF", size = 2) +
  geom_point(aes(x = which.min(y), y = min(y)), 
             shape = "X", 
             color = "#BC3C29FF",
             size = 5) +
  geom_hline(yintercept = min(vehicle_mse$y) + sd(vehicle_mse$y), 
             linetype = "dashed") +
  scale_x_continuous(expand = c(0, 0), 
                     breaks = seq(0, 10, 2)) +
  scale_y_continuous(expand = c(0, 0),
                     limits = c(500, 3000),
                     breaks = seq(500, 3000, 500)) +
  coord_cartesian(clip = "off") +
  labs(x = "Power of Time",
       y = "CV Error") +
  theme_egraphics

# 查找误差最小时的阶数
k_optimal = which.min(cv.MSE)

p2 = ggplot(vehicle, aes(x = time, y = accel)) + 
  geom_point() +
  stat_smooth(method = 'lm', 
              formula = y ~ poly(x, k_optimal),  
              color = "#BC3C29FF",
              fill = "#0072B5FF", 
              size = 1) + 
  scale_y_continuous(limits = c(-150, 150), 
                     expand = c(0, 0)) +
  scale_x_continuous(limits = c(0, 60),
                     expand = c(0, 0)) +
  labs(x = "Millisecond after Impact", 
       y = "Acceleration of Model Head") +
  theme_egraphics

fig18.2 = 
  plot_grid(p1, p2,
          ncol = 2,
          labels = c("A", "B"),
          label_size = 10)

ggsave(plot = fig18.2, "figure_tiff/2-14非线性回归/图18.2.pdf",width = 6, height= 3, units="in")
```


