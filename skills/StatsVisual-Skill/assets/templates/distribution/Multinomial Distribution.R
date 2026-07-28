## 多项分布 | Multinomial Distribution

15.17

```{r multinomial-distribution, fig.width=8,fig.height=6,fig.cap="不同参数下的多项式分布图"}

dmulti = function(n,p){
  X = t(as.matrix(expand.grid(0:n, 0:n))) 
  XX = rbind(X, n:n - colSums(X))
  d = rep(0,dim(X)[2])
  index = which(colSums(X) <= n)
  d[index] = apply(XX[,index], 2, function(x) dmultinom(x, prob = p))
  d.mat = matrix(d,n+1,n+1)
  dimnames(d.mat) = list(as.character(c(0:n)), as.character(c(0:n)))
  return(d.mat)
}
d.mat1 = dmulti(n=3,p=c(0.1,0.3,0.6))
d.mat2 = dmulti(n=3,p=c(0.3,0.3,0.4))
d.mat3 = dmulti(n=3,p=c(0.6,0.3,0.1))
d.mat4 = dmulti(n=10,p=c(0.6,0.3,0.1))

tiff("figure_tiff/2-11数据分布/fig15.17.tiff", width = 8, height = 6, units = "in", res = 300)
opar = par(no.readonly = T)
par(mfrow=c(2,2))

s3d.dat = data.frame(columns = c(col(d.mat1)),rows = c(row(d.mat1)), value = c(d.mat1))
scatterplot3d(s3d.dat, type = "h", lwd = 4, pch = " ", lab = c(4,4,4), scale.y = 0.75,
              zlim=c(0,0.5), ylab="y",xlab="x",zlab="Probability Mass",
              cex.axis = 0.75, cex.lab = 0.8, y.margin.add = 0.2,
              x.ticklabs = colnames(d.mat1), cex.symbols = 0.4, 
              y.ticklabs = rownames(d.mat1),color = grey(16:1/40), main = " ")
mtext("n=3, p=c(0.1, 0.3, 0.6)",side = 1,line = 2.5,cex = 1)

s3d.dat = data.frame(columns = c(col(d.mat2)),rows = c(row(d.mat2)), value = c(d.mat2))
scatterplot3d(s3d.dat, type = "h", lwd = 4, pch = " ", lab = c(4,4,4), scale.y = 0.75,
              zlim=c(0,0.5), ylab="y",xlab="x",zlab="Probability Mass",
              cex.axis = 0.75, cex.lab = 0.8, y.margin.add = 0.2,
              x.ticklabs = colnames(d.mat2), cex.symbols = 0.4, 
              y.ticklabs = rownames(d.mat2),color = grey(16:1/40), main = " ")
mtext("n=3, p=c(0.3, 0.3, 0.4)",side = 1,line = 2.5, cex = 1)

s3d.dat = data.frame(columns = c(col(d.mat3)),rows = c(row(d.mat3)), value = c(d.mat3))
scatterplot3d(s3d.dat, type = "h", lwd = 4, pch = " ", lab = c(4,4,4), scale.y = 0.75,
              zlim=c(0,0.5), ylab="y",xlab="x",zlab="Probability Mass",
              cex.axis = 0.75, cex.lab = 0.8, y.margin.add = 0.2,
              x.ticklabs = colnames(d.mat3), cex.symbols = 0.4, 
              y.ticklabs = colnames(d.mat3), color = grey(16:1/40), main = " ")
mtext("n=3, p=c(0.6, 0.3, 0.1)",side = 1,line = 2.5,cex = 1)

s3d.dat = data.frame(columns = c(col(d.mat4)),rows = c(row(d.mat4)), value = c(d.mat4))
scatterplot3d(s3d.dat, type = "h", lwd = 4, pch = " ", scale.y = 0.75,
              # lab = c(4,4,4),
              xlim = c(0,10), ylim = c(0,10),
              zlim=c(0,0.15), ylab="y",xlab="x",zlab="Probability Mass", 
              cex.axis = 0.75, cex.lab = 0.8, y.margin.add = 0.2,
              # x.ticklabs = c(0,2,4,6,8,10), y.ticklabs = c(0,2,4,6,8,10),
              cex.symbols = 0.4, 
              color = grey(121:1/140), main = " ")
mtext("n=10, p=c(0.6, 0.3, 0.1)",side = 1,line = 2.5,cex = 1)
par(opar)

dev.off()
```

