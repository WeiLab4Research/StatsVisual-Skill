## 正态化函数搜索图 | Ladder of Powers for Normal Distribution, histograms or QQ plots

14.9。

```{r gladder,fig.width=8,fig.height=8,fig.cap="高中生BMI指数阶梯效能图"}

# 加载函数包
source("rcode/ladder.r")

x = bmi_men$bmi 
point_color = "cyan4"
line_color = "black"
line_type = "solid"

# 通过不同形式的数据转化
transformed_x <- tibble::tibble(
    cubic = x ^ 3,
    square = x ^ 2,
    identity = x,
    square_root = sqrt(x),
    log = log(x),
    inv_square_root = 1 / sqrt(x),
    inverse = 1 / x,
    inv_square = 1 / (x ^ 2),
    inv_cubic = 1 / (x ^ 3)) %>%
    dplyr::mutate(dplyr::across(.cols = c(inv_square_root,
                                          inverse,
                                          inv_square,
                                          inv_cubic),
                                .fns = ~ -1 * .))
  
  colnames(transformed_x) = c("Cubic",
                                "Square",
                                "Identity",
                                "Square root",
                                "Log",
                                "1 / Square root",
                                "Inverse",
                                "1 / Square",
                                "1 / Cubic")
  transformed_x_draw = stack(transformed_x)
  
fig14.9 = ggplot(data = transformed_x_draw,
         aes(sample = values)) +
    geom_qq_line(color = line_color,
                 linetype = line_type) +
    geom_qq(color = point_color,
            alpha = 0.8) +
    facet_wrap(~ind, scales = "free") + 
    labs(x = NULL,
         y = NULL,
         title = "Quantile-Normal plots by transformation") +
    theme_bw() +
    theme(strip.background = element_blank())
  
ggsave(plot = fig14.9, "figure_tiff/2-10QQ图/图14.9.pdf",width = 8, height= 8, units="in")

# gladder
fig14.10 = gladder(bmi_men$bmi)

ggsave(plot = fig14.10, "figure_tiff/2-10QQ图/图14.10.pdf",width = 8, height= 8, units="in")

```


# (PART) 统计图形 {-}

# 概率和统计分布 | Probabilistic and Statistical Distribution

