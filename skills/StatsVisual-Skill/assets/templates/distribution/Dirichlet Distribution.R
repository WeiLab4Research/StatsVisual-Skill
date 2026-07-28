## 狄利克雷分布 ｜ Dirichlet Distribution

15.21

```{r dirichlet-distribution,fig.width=8,fig.height=6, fig.cap="不同参数下Dirichlet分布"}

Diri_dist = function(a1, a2, a3){
  alpha1 = a1
  alpha2 = a2
  alpha3 = a3
  n = 20
  y1 = rgamma(n, alpha1, rate = 1)
  y2 = rgamma(n, alpha2, rate = 1)
  y3 = rgamma(n, alpha3, rate = 1)
  vx = as.matrix(expand.grid(y1, y2, y3))
  colnames(vx) = c("y1", "y2", "y3")
  data = as.data.frame(vx)
  data$ry1 = data$y1/(data$y1+data$y2+data$y3)
  data$ry2 = data$y2/(data$y1+data$y2+data$y3)
  data$ry3 = data$y3/(data$y1+data$y2+data$y3)
  vx = as.matrix(data[, 4:6])
  dy = ddiri(vx, c(alpha1, alpha2, alpha3))
  dat = as.data.frame(cbind(vx, dy))
  dat = dat[!(is.na(dat$dy) | dat$dy <0), ]
  return(dat)
}

dd = Diri_dist(1, 1, 1)
plot_ly(dd, 
        x = ~ ry1,
        y = ~ ry2,
        z = ~ dy,
        type = "scatter3d", 
        mode = "markers",
        size = 1) %>%
  layout(scene = list(xaxis = list(title = "x1"), 
                      yaxis = list(title = "x2"),
                      zaxis = list(title = "y")))

dd = Diri_dist(2, 2, 2)
plot_ly(dd, 
        x = ~ ry1,
        y = ~ ry2,
        z = ~ dy,
        type = "scatter3d", 
        mode = "markers",
        size = 1) %>%
  layout(scene = list(xaxis = list(title = "x1"), 
                      yaxis = list(title = "x2"),
                      zaxis = list(title = "y")))

dd = Diri_dist(10, 10, 10)
plot_ly(dd, 
        x = ~ ry1,
        y = ~ ry2,
        z = ~ dy,
        type = "scatter3d", 
        mode = "markers",
        size = 1) %>%
  layout(scene = list(xaxis = list(title = "x1"), 
                      yaxis = list(title = "x2"),
                      zaxis = list(title = "y")))

```

