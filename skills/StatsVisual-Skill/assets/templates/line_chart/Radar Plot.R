## 雷达图 | Radar Plot

6.12。

```{r line-radar-plot,fig.width=10,fig.height=6, fig.cap="2020年新冠疫情全球各国防控情况之雷达图"}

# 读取数据
covid_nph = read.csv("data/0200_rader_plot.csv", header = TRUE)
# 修改数据列名
colnames(covid_nph) = c("region",
                        "Never under control(n=81)", 
                        "once under control(n=85)", 
                        "Rebound(n=56)",
                        "Rebound greater(n=28)", 
                        "Fluctuate(n=10)")
# 定义雷达图颜色
radar_color = c("#FDAF91FF",
                "#0099B4FF",
                "#ED0000FF",
                "#00468BFF",
                "#42B540FF",
                "#925E9FFF")

fig6.12 =
  ggradar(covid_nph,
        base.size = 1,
        background.circle.transparency = 0,
        plot.extent.x.sf = 1.2,
        group.colours = radar_color,
        legend.position = "bottom",
        legend.text.size = 8,
        group.point.size = 4,
        axis.label.offset = 1.1,
        axis.label.size = 4,
        font.radar = 1)

ggsave(plot = fig6.12, "figure_tiff/2-02线图/图6.12.pdf",width= 10, height= 6, units="in")

```


# 饼图 | Pie Plot

