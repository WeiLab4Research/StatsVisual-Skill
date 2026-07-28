## 桑基图 | Sanky Plot

12.9。

```{r sanky-plot, fig.width = 6, fig.height = 12,fig.cap="新冠肺炎境外输入病例来源及其输入地"}

# 读取数据
ds_sankey = read.csv(file ="data/0800_sankey_1.csv")

# ，，并使用geom_flow()绘制它们之间的流
# geom_stratum接收到冲积图的strata位置数据，包括水平(x)和
#垂直(y, ymin, ymax)位置，它为这些地层画出一定宽度的矩形

fig12.9 = 
  ggplot(data = ds_sankey,
       aes(axis1 = From, 
           axis2 = Province, 
           y = Value)) +
  # geom_alluvium接收到冲积图的lodes位置数据
  # 包括水平(x)和垂直(y, ymin, ymax)位置，以及冲积流与strata的交叉点
  geom_alluvium(aes(fill = Province),
                curve_type = "cubic") +
  # geom_stratum接收到冲积图的strata位置数据，
  #包括水平(x)和垂直(y, ymin, ymax)位置，它为这些地层画出一定宽度的矩形
  geom_stratum() +
  geom_text(stat = "stratum",
            aes(label = after_stat(stratum))) +
  scale_x_discrete(limits = c("Survey", "Response"),
                   expand = c(0.15, 0.05)) +
  scale_fill_manual(values = colorRampPalette(rev(brewer.pal(11,
                                                             'RdYlBu')))(11)) +
  theme_void() +
  theme(legend.position = "none")

ggsave(plot = fig12.9, "figure_tiff/2-08热图/图12.9.pdf",width= 6, height= 12, units="in")
```

