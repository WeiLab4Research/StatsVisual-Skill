## 分组条形图 | Stratified Bar

5.5

```{r stratified-bar, fig.cap="二次给药后按年龄和性别的病例分布"}

# 读取数据
vaccine_rna = read.csv(file ="data/0100_stratified_bar.csv")

fig5.5 = 
  ggplot(vaccine_rna, 
       aes(x = group, 
           y = count, 
           fill = sex)) +
  geom_bar(stat = "identity", 
           position = position_dodge(width = 0.9)) +
  geom_text(aes(label = count),
            position = position_dodge(width = 1),
            vjust = -0.5,
            color = "black",
            size = 5) +
  scale_fill_manual(values = c("#6F99ADFF", "#7876B1FF")) +
  scale_y_continuous(limits = c(0, 50), 
                     expand = c(0, 0)) +
  labs(x = "Age Group (yr)", 
       y = "N of Cases",
       fill = "Sex") +
  theme_egraphics +
  theme(legend.position = "top")

ggsave(plot = fig5.5, "figure_tiff/2-01条形图/图5.5.pdf",width= 6, height= 4, units="in")

```

