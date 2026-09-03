## 多元正态分布 | Multivariate Normal Distribution

15.3
```{r two-dimentional, fig.cap="二元正态分布"}

# set parameter
x1 = seq(-10, 10, length = 41)  
x2 = seq(-10, 10, length = 41)  
mu1 = 0
mu2 = 0
rho = 0
s1 = 25
s2 = 25
fx = function(x1, x2){
  term1 = 1/(2*pi*sqrt(s1*s2*(1-rho^2)))
  term2 = -1/(2*(1-rho^2))
  term3 = (x1-mu1)^2/s1
  term4 = (x2-mu2)^2/s2
  term5 = -2*rho*((x1-mu1)*(x2-mu2))/(sqrt(s1)*sqrt(s2))
  term1*exp(term2*(term3+term4-term5))
}

z = outer(x1, x2, fx)

# set color
colos = c("#E3F2FDFF", "#BBDEFBFF", "#90CAF9FF", "#64B5F6FF", "#42A5F5FF",
               "#2196F3FF", "#1E88E5FF", "#1976D2FF", "#1565C0FF", "#0D47A1FF" )

plot_ly(z = ~ z,
        colors = colos,
        contours = list(
          y = list(
            show = TRUE,
            usecolormap = TRUE, 
            highlightcolor = "#ff0000",
            project = list(y = TRUE)),
          x = list(
            show = TRUE,
            usecolormap = TRUE,
            highlightcolor = "#ff0000",
            project = list(x = TRUE))),
        showscale = FALSE
        ) %>% 
  add_surface()

```

