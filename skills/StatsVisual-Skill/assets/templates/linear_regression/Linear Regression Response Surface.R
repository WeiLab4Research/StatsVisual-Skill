## 直线回归响应面 | Linear Regression Response Surface

单变量线性回归可用二维散点图展示，两个自变量的回归模型需要用3D图形来展示。本例基于上例的第一个模型(lmfit1)，用`ploty`包实现三维散点图和动态交互(图\@ref(fig:response-surface))。

```{r response-surface, eval=FALSE, fig.cap="三维散点图和响应面"}

petal_lm = lm(api00 ~ meals + ell, data = API)

#Graph Resolution (more important for more complex shapes)
graph_reso = 0.05

#Setup Axis
axis_x = seq(min(API$meals), max(API$meals), by = graph_reso)
axis_y = seq(min(API$ell), max(API$ell), by = graph_reso)

#Sample surface points
petal_lm_surface = expand.grid(meals = axis_x,
                               ell = axis_y,
                               KEEP.OUT.ATTRS = F)
petal_lm_surface$api00 = predict.lm(petal_lm, newdata = petal_lm_surface)
petal_lm_surface = acast(petal_lm_surface, ell ~ meals, 
                         value.var = "api00") 

plot_ly(API, 
        x = ~ meals, 
        y = ~ ell, 
        z = ~ api00,
        type = "scatter3d", 
        mode = "markers",
        showlegend = F) %>%
  add_markers(list(xaxis = list(title = 'Meals'),
                   yaxis = list(title = 'Ell'),
                   zaxis = list(title = 'API'))) %>%
  add_trace(z = petal_lm_surface,
            x = axis_x,
            y = axis_y,
            type = "surface",
            showscale = FALSE)

```

