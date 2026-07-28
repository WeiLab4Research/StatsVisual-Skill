## 韦恩图 | Venn Plot，Venn Diagram

热图，用来描述数据间的关系；而韦恩图，可用来展示集合间的包含关系。
文氏图，或译Venn图(韦恩图)、温氏图、范氏图，由**John Venn**在《Journal of Symbolic Logic》(《符号逻辑》)中提出，用于显示元素集合重叠区域的图表。
韦恩图是关系型图表，通过图形与图形之间的层叠关系，来表示集合与集合之间的相交关系。每个集合通常以一个圆圈表示。每个集合都是一组具有共同之处的物件或数据。当多个圆圈(集)相互重叠时，称为交集，里面的数据同时具有重叠集中的所有属性。

恒河猴持续腹泻的转录组景观及人类和小鼠炎症性肠病模型比较研究，收集10只持续性腹泻和12只健康的中国恒河猴的全外周血，将恒河猴的(differentially expressed genes, DEGS)与患有炎症性肠病(inflammatory bowel disease, IBD)的人类和小鼠的DEGs进行了比较，以确定腹泻个体的基因表达变化[@RN28]。通过比较恒河猴(rhesus macaque, RM)、人血(human blood, HB)、人肠(human intestines, HI)和小鼠肠(mouse intestines, MI)四组间的差异，得到了组间重叠DEGs的数量。在所有四组中只有5个共有的deg。在恒河猴与人类血液、恒河猴与人类肠道和恒河猴与小鼠的配对比较中，分别有17,75和109个重叠的DEGs(图\@ref(fig:venn-plot))。

```{r venn-plot, fig.width=8, fig.height=6, fig.cap="DEGs重叠情况"}

# 读取数据
ds_venn = read.csv(file ="data/0800_Venn.csv")

venn_list = list("RM" = ds_venn$rhesus.macaque,
                 "HB" = ds_venn$human.blood,
                 "HI" = ds_venn$human.intestines,
                 "MI" = ds_venn$mouse.intestines)

fig12.10 = 
  ggvenn(venn_list,
       c("RM","HB","HI","MI"),
       show_percentage = T,      
       stroke_color = "white")+         
       scale_fill_npg()

ggsave(plot = fig12.10, "figure_tiff/2-08热图/图12.10.pdf",width = 8, height= 6, units="in")
```

