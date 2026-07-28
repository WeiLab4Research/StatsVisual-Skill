## 金字塔图 | Pyramid Histogram

8.8。

```{r histogram-pyramid, fig.height=6, fig.cap = "2010年中国第六次人口普查年龄结构"}

# 读取数据
pop = read.csv("data/0400_population_census.csv")

# 按性别计算构成比
pop = pop %>% 
  mutate(Age = factor(Age, levels = unique(.$Age))) %>%
  group_by(Sex) %>%
  mutate(percent = 100*Pops/sum(Pops))

pop_hist = 
  ggplot(pop, aes(x = Age,
                y = ifelse(Sex == "Male", -Pops, Pops),
                group = Sex, 
                fill = Sex)) +
  geom_bar(stat = "identity", alpha = 0.6) +
  geom_hline(yintercept = 0, linetype = "dashed") +
  scale_x_discrete(expand = c(0, 0)) +
  scale_y_continuous(labels = abs, 
                     limits = c(-100, 100),
                     expand = c(0, 0)) +
  scale_fill_nejm() +
  labs(x = "Year Grade",
       y = "Proportion of Population (%)",
       fill = "") +
  coord_flip() +
  theme_egraphics +
    theme(legend.position = "inside",
        legend.position.inside = c(0.9, 0.9))

ggsave(plot = pop_hist, "figure_tiff/2-04直方图/图8.8.pdf",width= 6, height= 4, units="in")
```

