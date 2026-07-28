## 火山图 | Valcano Plot

11.9。


```{r scatter-valcano, fig.width = 12, fig.height=4,fig.cap="UKB糖尿病人群蛋白质差异表达火山图"}

# 读取数据
data = read.csv("data/0710_protein_list.csv")
protein_list = read.csv("data/0710_protein_data.csv")

# 设置FDR的阈值
topX = 42
cutoff = 0.05 / topX 
std = data$sd

# 提取显著蛋白的名称
proteins_annotation = protein_list$Feature[1:topX]
data = data %>% 
  # 增加蛋白显著性标记
  mutate(point_group = ifelse(npx %in% proteins_annotation, "yes", "no")) %>% 
  mutate(newlabel = str_remove(npx, "npx_"),
         # 差异值标准化处理
         value_1v0 = estimate_1v0/std,
         value_2v0 = estimate_2v0/std,
         value_2v1 = estimate_2v1/std)

data = data[order(data$point_group, decreasing = TRUE), ]

# 1型糖尿病vs对照组
p_c1 = ggplot(data, aes(x = value_1v0,
                        y = -log10(p_1v0))) + 
  geom_point(size = 1.5, color = "grey90") +
  geom_point(data = subset(data, point_group == "yes"), 
             size = 1.5, color = "grey60") +
  geom_point(data = subset(data, point_group == "yes" &
                             p_1v0 <= cutoff), 
             size = 1.5, color = "red") +
  geom_hline(yintercept =  -log10(cutoff),
             linetype = "dashed") +
  geom_text_repel(data = subset(data, point_group == "yes" &
                                  p_1v0 <= cutoff),
            aes(x =value_1v0, 
                y=-log10(p_1v0),
                label = newlabel),
            size = 2,
            color = "red",
            nudge_x=-0.05, 
            nudge_y=0.1,
            max.overlaps = 30,) +
  scale_y_continuous(limits = c(0, 10),
                     expand = c(0, 0)) + 
  scale_x_continuous(limits = c(-1, 1),
                     expand = c(0, 0)) +
  labs(x = "Differential NPX",
       y =  expression(-log[10](P)),
       title = "Type 1 v. Ctrl") + 
  theme_pubr() +
  theme(legend.position = "none",
        axis.title = element_text(size = 10, face = "bold"),
        axis.ticks.length = unit(.15, "cm"),
        axis.text  = element_text(size = 10),
        plot.margin = margin(.5, .5, .5, .5, "cm"))

# 2型糖尿病vs对照组
p_c2 = ggplot(data, aes(x = value_2v0, 
                        y = -log10(p_2v0),
                        color = point_group)) + 
  geom_point(size = 1.5, color = "grey90") +
  geom_point(data = subset(data, point_group == "yes"),
             size = 1.5, color = "grey60") +
  geom_point(data = subset(data, point_group == "yes" &
                             p_2v0 <= cutoff), 
             size = 1.5, color = "red") +
  geom_hline(yintercept = -log10(cutoff),
             linetype = "dashed") +
  geom_text_repel(data = subset(data, data$point_group == "yes" &
                                  p_2v0 <= cutoff),
            aes(x = value_2v0, 
                y = -log10(p_2v0),
                label = newlabel),
            size = 2,
            color = "red",
            nudge_x = 0.01, 
            nudge_y = 0.2,
            max.overlaps = 20) +
  scale_y_continuous(limits = c(0, 10),
                     expand = c(0, 0))+
  scale_x_continuous(limits = c(-1, 1),
                     expand = c(0, 0))+
  coord_cartesian(ylim = c(0, 10)) +
  labs(x = "Differential NPX",
       y =  expression(-log[10](P)),
       title = "Type 2 v. Ctrl") + 
  theme_pubr() +
  theme(legend.position = "none",
        axis.title = element_text(size = 10, face = "bold"),
        axis.ticks.length = unit(0.15, "cm"),
        axis.text  = element_text(size = 10),
        plot.margin = margin(0.5, 0.5, 0.5, 0.5, "cm"))

# 1型糖尿病vs2型糖尿病
p_12 = ggplot(data, aes(x = value_2v1, 
                        y =- log10(p_2v1),
                        color = point_group)) + 
  geom_point(size = 1.5, color = "grey90") +
  geom_point(data = subset(data, point_group == "yes"), 
             size = 1.5, color = "grey60") +
  geom_point(data = subset(data, point_group == "yes" &
                             abs(estimate_2v1 / sd) <= 0.1), 
             size = 1.5, color = "red") +
  geom_text_repel(data = subset(data, data$point_group == "yes" &
                                  abs(estimate_2v1 / sd) <= 0.1),
            aes(x = value_2v1, 
                y = -log10(p_2v1),
                label = newlabel),
            size = 2,
            color = "red",
            nudge_x = 0.01, 
            nudge_y = 0.2,
            max.overlaps = 20) +
  geom_vline(xintercept = c(0.1, -0.1),
             linetype = "dashed") +
  scale_y_continuous(limits = c(0, 10),
                     expand = c(0, 0))+ 
  scale_x_continuous(limits = c(-1, 1),
                     expand = c(0, 0))+
  labs(x = "Differential NPX",
       y =  expression(-log[10](P)),
       title = "Type 2 v. Type 1") + 
  theme_pubr() +
  theme(legend.position = "none",
        axis.title = element_text(size = 10, face = "bold"),
        axis.ticks.length = unit(.15, "cm"),
        axis.text  = element_text(size = 10),
        plot.margin = margin(.5, .5, .5, .5, "cm"))

fig11.9 = 
  plot_grid(p_c1, p_c2, p_12, 
          nrow = 1, labels = c("A", "B", "C"))

ggsave(plot = fig11.9, "figure_tiff/2-07散点图/图11.9.pdf",width= 12, height= 4, units="in")

```

# 热图 | Heatmap

