## 多层饼图 | Nested Pie Plot

多层饼图，常用于展示数据的多层结构和亚组的构成情况。本例展示了2018年美国各部门碳排放来源的占比情况，可清楚观察到运输业碳排放量最大，约占29%，工业部门中的精炼工厂(refineris)排放量位居工业部门之首，数据来源于美国环保局(US Environmental Protection Agency, EPA)(图\@ref(fig:pie-carbon))。

```{r pie-carbon, fig.cap = "2018年美国各部门碳排放情况"}

# 读取数据
ds_carbon = read.csv("data/0300_sunburst_carbon.csv")

plot_ly(ds_carbon,
  labels = ds_carbon$label,
  parents = ds_carbon$parent,
  values = ds_carbon$value,
  type = "sunburst",
  branchvalues = "total")

```

图中每圈代表一个年份，各条代表一种传染病，每格的颜色深浅表示该传染病当年发病率的相对高低；如图中标尺所示(Scale)，各传染病的发病率以逐年最小值-最大值为限标化至0-1尺度空间。该绘图数据是经过扰动的，并非该省真实数据；率的标化方法参考[@RN62](图\@ref(fig:pie-disease))。
本图作者：陈家进

```{r pie-2, eval = FALSE}

# 读取数据
ds_disease = read.csv("data/0300_jiangsu_disease.csv", fileEncoding = 'GBK')
# 仅提取2000年后的数据
ds_disease = subset(ds_disease, ds_disease$year>=2000)

# 疾病中文名称
Dise = c('甲型H1N1流感','人感染H7N9禽流感','手足口病','流行性腮腺炎','包虫病',
         '血吸虫病','麻风病','布病','艾滋病','戊肝','丙肝','梅毒',
         '其它感染性腹泻病','霍乱','丝虫病','炭疽','钩体病','流脑',
         '新生儿破伤风','狂犬病','阿米巴性痢疾','斑疹伤寒','出血热','伤寒',
         '疟疾','肺结核','甲肝','淋病','细菌性痢疾','百日咳','白喉',
         '传染性非典','脊灰','急性出血性结膜炎','登革热','猩红热',
         '风疹','流感','黑热病','乙肝','麻疹')

# 疾病对应英文
Label = c('Influenza H1N1','Influenza H7N9','HFMD','Mumps','Hydatid disease',
          'Schistosomiasis','Leprosy','Brucellosis','HIV infection',
          'Hepatitis E','Hepatitis C','Syphilis','OID','Cholera',
          'Filariasis','Anthrax','Leptospirosis','ECM','NT','Rabies','AD',
          'Typhus','Haemorrhagic fever','Typhoid','Malaria','Tuberculosis',
          'Hepatitis A','Gonorrhoea','BD','Pertussis','Diphtheria','SARS',
          'Poliomyelitis','AHC','Dengue', 'Scarlet fever','Rubella',
          'Seasonal influenza','Kala-azar','Hepatitis B','Measles')

# 定义疾病顺序
ds_disease$disease = factor(ds_disease$disease, levels = Dise)
ds_disease$year = factor(ds_disease$year)

fig7.11 = 
  ggplot(ds_disease, aes(x = disease,
                   y = year)) +
  geom_tile(aes(fill = incidence),
            color = "#D3D3D3",
            lwd = 0.1) + 
  coord_polar(theta = 'x')+
  scale_fill_gradient(low = 'white', 
                      high = "#F59A58", 
                      na.value = "white")+
  guides(fill = guide_colorbar(title = "Scale"))+
  scale_x_discrete(expand = c(0.03, 0), NULL, 
                   label = Label)+
  scale_y_discrete(expand = c(0.15, 0), NULL, 
                   breaks = seq(2000, 2020, 5))+
  annotate("text", x = 0, 
           y = c(1, 5, 10, 15, 20), 
           label = c("2000", "2005", "2010", "2015", "2020") , 
           color = "grey30", 
           size= c(3, 3, 3, 4, 5),
           angle = 0,
           fontface = "bold", 
           hjust = 0.6) +
  # 自定义背景主题
  theme(panel.background = element_rect(fill = "white", colour = NA), 
        panel.border = element_rect(fill = NA, colour = NA), 
        title = element_text(size = 14),
        axis.text.x = element_text(size = 12),
        axis.text.y = element_blank(),
        axis.ticks.y = element_blank(),
        axis.title.x = element_text(size = 16),
        axis.title.y = element_text(size = 16,
                                    angle = 90),
        legend.key = element_rect(fill="white", colour = NA),
        complete = TRUE)


ggsave(plot = fig7.11 , "figure_tiff/2-03饼图/图7.11.pdf",width= 10, height= 10, units="in")

```

```{r pie-disease, echo = FALSE,fig.cap="2020-2020某省份44种传染病发病趋势变化"}

include_graphics("figs/0300_jiangsudisease.png")

```

