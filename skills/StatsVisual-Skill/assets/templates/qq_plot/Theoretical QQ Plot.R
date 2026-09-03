## 常规QQ图 ｜ QQ Plot

14.2。

```{r basic-qqplot, fig.height=5, fig.width=10, fig.cap="江苏省500名高中男生身高QQ图"}

# 加载本章节所需程序包
library(ggpubr)
library(ggsci)
library(tidyverse)
library(cowplot)
library(qqplotr)

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
PE = read.csv("data/0400_PE_data.csv")
PE_men = PE %>%
  filter(school_grade == "Senior School",
         gender == "Male")
PE_women = PE %>%
  filter(school_grade == "Senior School",
         gender == "Female")

set.seed(2022)
bmi_men = PE_men[sample(1:nrow(PE_men), size = 500), ]
bmi_women = PE_women[sample(1:nrow(PE_women), size = 500), ]


p1 = ggplot(bmi_men, 
            aes(sample = scale(bmi))) +
  stat_qq(color = "#669FDB") +
  stat_qq_line(color = "#BC3C29FF") +
  scale_x_continuous(breaks = seq(-4, 4, 1), 
                     limits = c(-4, 4), 
                     expand = c(0, 0)) +
  labs(x = "Theoretical Quantiles",
       y = "BMI Quantiles") +
  theme_egraphics

x = rnorm(500, 0, 1)

p2 = ggplot() + 
  geom_line(data = NULL, 
            aes(x = x, y = dnorm(x, 0, 1)),
            color = "#BC3C29FF", 
            linewidth = 1.2) +
  geom_density(data = bmi_men, 
               aes(x = scale(bmi)), 
               color = "#669FDB",
               size = 1.5, 
               linetype = "dashed") +
  scale_x_continuous(breaks = seq(-4, 4, 1), 
                     limits = c(-4, 4), 
                     expand = c(0, 0)) +
  scale_y_continuous(limits = c(0, 0.5), 
                     expand = c(0, 0)) +
  labs(y = "Density") +
  theme_egraphics

fig14.2 = plot_grid(p1, p2 ,
          ncol = 2,
          labels = c("A", "B"))

ggsave(plot = fig14.2, "figure_tiff/2-10QQ图/图14.2.pdf",width = 10, height= 5, units="in")

```

14.3。

```{r qqplot-twodata,fig.height=5, fig.width=10, fig.cap="高中男生女生BMI指数QQ图"}

# 自建绘制qq图的函数
myqqplot = function(d1, d2){
  n = max(length(d1), length(d2))
  p = (1:n - 1)/(n - 1)
  xlab = quantile(d1, p)
  ylab = quantile(d2, p)
  ggplot(data.frame(xlab, ylab), 
         aes(xlab, ylab)) +
    geom_point(size = 1.2, color = "#0072B5FF")
}

p1 = myqqplot(bmi_women$bmi, bmi_men$bmi)

# 计算qq图斜率
maxsize = max(length(bmi_men$bmi), length(bmi_women$bmi))
slope = mean(quantile(bmi_women$bmi, seq(0, 1, length = maxsize))/
       quantile(bmi_men$bmi, seq(0, 1, length = maxsize)))  

p1 = p1 + geom_abline(slope = slope, intercept = 1, color = "#BC3C29FF") + 
  scale_x_continuous(limits = c(10, 40), expand = c(0, 0)) +
  scale_y_continuous(limits = c(10, 40), expand = c(0, 0)) +
  labs(x = "Male BMI Quantiles", 
       y = "Female BMI  Quantiles") +
  theme_egraphics

p2 = ggplot() +
  geom_density(data = bmi_men, aes(x = bmi, color = "Male"), size = 1.2) +
  geom_density(data = bmi_women, aes(x = bmi, color = "Female"), size = 1.2 ) +
  scale_color_manual(values = rev(c("#BC3C29FF", "#0072B5FF"))) +
  scale_x_continuous(limits = c(0, 40), expand = c(0, 0)) +
  scale_y_continuous(limits = c(0, 0.2), expand = c(0, 0)) +
  labs(x = "BMI",
       y = "Density",
       color = "") +
  theme_egraphics +
  theme(legend.position = "top")

fig14.3 = plot_grid(p1, p2 ,
          ncol = 2,
          labels = c("A", "B"))

ggsave(plot = fig14.3, "figure_tiff/2-10QQ图/图14.3.pdf",width = 10, height= 5, units="in")

```

14.4。

```{r GWAS-plot,fig.height=6,fig.width=6, fig.cap="妊娠早期母亲尿液钠元素GWAS分析QQ图"}

# 读取数据
lung_gwas = get(load("data/0900UKB_sample.Rdata"))

set.seed(2024)
p = sample(lung_gwas$pvalue, 1000000)
p = sort(p)

# 计算膨胀系数
z = qnorm(p / 2)
lambda = round(median(z^2, na.rm =TRUE) / qchisq(0.5, 1), 3)

gwas_p = data.frame(expectation = -log10(qunif(1:length(p)/length(p))),
                    observation = -log10(p))

fig14.4 = 
  ggplot(data = gwas_p, aes(x = expectation, y = observation))+
	geom_point(size = 0.5) +
  geom_abline(intercept = 0, 
	            slope = 1,
	            colour = "red",
	            linewidth = 0.5) +
  annotate(geom = "text", 
           x = 6, y = 4.5,
           label = paste0("λ = ", lambda),
           size = 6) +
	scale_x_continuous(name = expression(Expected~ - log[10](italic(P))),
	                   limits = c(0, 8),
	                   breaks = seq(0, 8, 2),
	                   expand = c(0, 0)) + 
	scale_y_continuous(name = expression(Observed~ - log[10](italic(P))),
	                   limits = c(0, 10),
	                   breaks = seq(0, 10, 2),
	                   expand = c(0, 0)) +
  theme_egraphics

ggsave(plot = fig14.4, "figure_tiff/2-10QQ图/图14.4.pdf",width = 6, height= 6, units="in")

```

