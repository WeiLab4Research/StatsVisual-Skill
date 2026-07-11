## 海盗图 | Pirate Plot

10.10。

```{r pirate, fig.cap="江苏省青少年按学制分层身高海盗图"}

# 计算不同学制下身高的中位数
PE_median = PE_sampling %>%
  group_by(school_grade)%>% 
  mutate(Median = median(height_cm))

fig10.10 = 
  ggplot(PE_sampling, 
       aes(x = school_grade, 
           y = height_cm)) +
  geom_boxplot(color = "grey60",
               width = 0.4) + 
  geom_violin(aes(fill = school_grade),
              color = "grey",
              alpha = 0.5,
              width = 0.5) +
  geom_jitter(aes(color = school_grade),
              height = 0,
              width = 0.1,
              alpha = 0.5) +
  geom_bar(data = PE_median,
           aes(x = school_grade,
               y = Median,
               fill = school_grade),
           stat = "identity",
           alpha = 0.2,
           width = 0.5) +
  scale_y_continuous(limits = c(0, 200),
                     expand = c(0, 0)) +
  scale_color_nejm() +
  scale_fill_nejm() +
  labs(x = "School Grade", 
       y = "Height (cm)") +
  theme_egraphics +
  theme(legend.position = "none")

ggsave(plot = fig10.10, "figure_tiff/2-06箱线图/图10.10.pdf",width= 6, height= 4, units="in")

```

