## LOWESS非线性回归 | LOWESS Regression

上述案例是用LOWESS拟合个别记录的非线性趋势，亦可用LOWESS来进行两个变量的非线性回归。本例基于96例健康对照(Control)和146例5期慢性肾功能不全患者(CKD 5)的动态心率监测数据，剔除存在缺失值的数据，分别从两组随机抽取15例样本，分别拟合随时间变化的非线性关系，以展示两类人群的心率节律的差异(图\@ref(fig:nonlinear-fit-smooth))。曲线为LOWESS非线性拟合结果（实为条件均数），条带为条件均数之95%可信区间带。

```{r loess-data-cleaning ,eval=FALSE}

# 读取数据
dscase = read.csv("data/1100_heart_smooth_case.csv")
dscontrol = read.csv("data/1100_heart_smooth_control.csv")
# 生成病例组随机数据
set.seed(2022)
case_sampling = dscase[, sample(2:ncol(dscase), size = 15)]
case_sampling = data.frame(dscase$time, case_sampling) 

data_case = data.frame(time = rep(dscase[, 1], times = 15)) 
data_case$group = rep(colnames(case_sampling)[2:16], each = 24)
a=1
for(i in 2:ncol(case_sampling)){
  for(j in 1:nrow(case_sampling)){
    data_case$rate[a] = case_sampling[j,i]
    a = a + 1
  }
}

case_fit = loess.as(as.numeric(data_case$time), 
                    data_case$rate,
                    user.span = NULL)
best_case = as.data.frame(predict(case_fit, se = T))
best_case = data.frame(data_case$time, best_case)
colnames(best_case) = c("time", "fit", "se")

# 计算置信区间
best_case$ci_up = best_case$fit + 1.96 * best_case$se
best_case$ci_low = best_case$fit - 1.96 * best_case$se

best_case$time = paste0(best_case$time, ":", "00")
data_case$time2 = rep(best_case[1:24, 1], times = 15)
best_case$time = factor(best_case$time,levels = unique(best_case$time))

# 对对照组进行随机数据的生成
set.seed(2022)
control_sampling = dscontrol[, sample(2:ncol(dscontrol), size = 15)]
control_sampling = data.frame(dscontrol$time, control_sampling) 

data_control = data.frame(time = rep(dscontrol[,1], times = 15)) 
data_control$group = rep(colnames(control_sampling)[2:16], each = 24)
a = 1
for(i in 2:ncol(control_sampling)){
  for(j in 1:nrow(control_sampling)){
    data_control$rate[a] = control_sampling[j, i]
    a = a+1
  }
}

control_fit = loess.as(as.numeric(data_control$time),
                       data_control$rate, 
                       user.span = NULL)
best_control = as.data.frame(predict(control_fit, se = T))
best_control = data.frame(data_control$time, best_control)
colnames(best_control) = c("time", "fit", "se")

# 生成置信区间
best_control$ci_up = best_control$fit + 1.96 * best_control$se
best_control$ci_low = best_control$fit - 1.96 * best_control$se

best_control$time = paste0(best_control$time, ":", "00")
data_control$time2 = (time = rep(best_control[1:24, 1], times = 15)) 
best_control$time = factor(best_control$time,
                           levels = unique(best_control$time))

```

```{r nonlinear-fit-smooth, fig.width=8, fig.height=6, fig.cap ="健康对照和CKD5患者之24h心率节律差异"}

# 病例组
p1 = ggplot(best_case) + 
  geom_point(aes(time, fit), 
             size = 2, color = "#BC3C29FF") +
  geom_line(aes(as.integer(time), fit,
                color = "#BC3C29FF"),
            size = 1,
            alpha = 1) +
  geom_ribbon(aes(as.integer(time),
                  ymin = ci_low,
                  ymax = ci_up),
              alpha = 0.5,
              fill = "#BC3C29FF") +
  geom_line(data = data_case,
            aes(time2, y = rate, group = group),
            color = "#BC3C29FF",
            alpha = 0.3) +
  scale_x_discrete(expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0), 
                     limits = c(50, 130)) 

# 增加对照数据
p2 = p1 +
  geom_point(data = best_control,
             aes(time, fit),
             size = 2,
             color = "#0072B5FF") +
  geom_line(data = best_control,
            aes(as.integer(time), fit, 
                color = "#0072B5FF"),
            size = 1,
            alpha = 1) +
  geom_ribbon(data = best_control,
    aes(as.integer(time),
        ymin = ci_low,
        ymax = ci_up),
        fill = "#0072B5FF",
    alpha = 0.5) +
  geom_line(data = data_control,
            aes(time2, y = rate, group = group),
            color = "#0072B5FF",
            alpha = 0.1) +
  scale_color_manual(values = c("#BC3C29FF", "#0072B5FF"), 
                     limits = c("Case", "Control"))+
  labs(x = "Point in Time (hour)",
       y = "Heart Rate (bpm)",
       color = "Group") +
  theme_egraphics +
  theme(axis.text.x = element_text(angle = 45,
                                   hjust = 1),
        legend.position = "top")
p2

ggsave(plot = p2, "figure_tiff/2-12曲线平滑/图16.4.pdf",width = 8, height= 6, units="in")

```


# 线性回归 | Linear Regression

