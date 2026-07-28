## LOWESS曲线平滑 | LOWESS Smooth

以R中自带的海狸(beavers)连续监测的体温数据为例（时间/分，体温/摄氏度），拟合连续24小时的体温节律(图\@ref(fig:smooth-lowess))。

```{r smooth-lowess, fig.width = 8, fig.height = 6, fig.cap = "海狸昼夜体温节律的LOWESS曲线拟合"}

# 加载本章节所需程序包
library(ggpubr)
library(ggsci)
library(fANCOVA)

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

ds = beaver1
ds$min = seq(10, nrow(beaver1) * 10, 10)
ds$frac = NA
ds$lowess = NA

# 按不同fraction进行loess拟合
ds_lowess = ds
for (f in seq(0, 1, by = 0.01)) {
  cat(".")
  cur_ds = ds
  cur_ds$frac = f
  if (f == 0)
    f = 0.000001
  cur_ds$lowess = lowess(ds$min, ds$temp, f = f)$y
  ds_lowess = rbind(ds_lowess, cur_ds)
}

# 产生色谱
colo = colorRampPalette(c("grey90","red"))((length(unique(ds_lowess$frac))))

fig16.2 = 
  ggplot(ds_lowess, aes(min, temp)) +
  geom_point(size = 2) +
  geom_line(linewidth = 0.6, color = "grey90") +
  geom_line(aes(min, lowess, 
                color = as.factor(format(frac, 4.2))), 
            linewidth = 0.5,
            show.legend = F) +
  scale_color_manual(values = colo) +
  scale_x_continuous(limits = c(0, 1200),
                     breaks = seq(0, 1200, 300),
                     expand = c(0, 0)) +
  scale_y_continuous(limits = c(36.25, 37.75),
                     breaks = seq(36.25, 37.75, 0.25),
                     expand = c(0, 0)) +
  labs(x = "Minutes", 
       y = "Temperature(℃)", 
       color = "Parameter.frac") +
  theme_egraphics 

ggsave(plot = fig16.2, "figure_tiff/2-12曲线平滑/图16.2.pdf",width = 8, height= 6, units="in")

```

16.3

```{r individual-trend, fig.width=8, fig.height=6, fig.cap = "心率监测数据"}

# 加载自写函数包
source("rcode/auto_loess.r")

# 读取数据
ds_heart = read.csv(file ="data/1100_heart_rate.csv")
ds_heart$time = factor(ds_heart$time, levels = unique(ds_heart$time))

ds = ds_heart
ds$frac = NA
ds$lowess = NA

lowess_heart = ds
for(f in seq(0, 1, by = 0.01)){
  cat(".")
  cur_ds = ds
  cur_ds$frac = f
  if(f==0) f=0.000001
  cur_ds$lowess = lowess(ds$time, ds$normal, f = f)$y
  lowess_heart = rbind(lowess_heart, cur_ds)
}

# autoloess函数可找到最优fraction
best_frac_fit = loess(ds$normal ~ as.numeric(ds$time)) %>%
  autoloess(span=c(0.01, 0.800))
best_frac = subset(lowess_heart, 
                   frac == round(best_frac_fit$pars$span, 2))

# 改变日期格式
lowess_heart$time = paste0(lowess_heart$time, ":", "00")
lowess_heart$time = factor(lowess_heart$time, 
                           levels = unique(lowess_heart$time))

# 生成色谱
colo = colorRampPalette(c("gray90"))(length(unique(lowess_heart$frac)))

fig16.3 = ggplot(lowess_heart, aes(time, normal)) +
  geom_point(size = 3) +
  geom_line(aes(as.integer(time), normal), size = 1) +
  geom_line(aes(as.integer(time), lowess, 
                color = as.factor(format(frac, 4.2))), 
            alpha = 0.1,
            size = 0.8,
            show.legend = F) +
  geom_line(data = best_frac, aes(as.integer(time), lowess),
            size = 1,
            color = "#BC3C29FF") +
  scale_color_manual(values = colo) +
  scale_x_discrete(expand = c(0, 0)) +
  scale_y_continuous(limits = c(40, 100), 
                     expand = c(0, 0)) +
  labs(x = "Point in Time (hour)", 
       y = "Heart Rate (bpm)") +
  theme_egraphics +
  theme(axis.text.x = element_text(angle = 45,
                                   hjust = 1))

ggsave(plot = fig16.3, "figure_tiff/2-12曲线平滑/图16.3.pdf",width = 8, height= 6, units="in")

```

