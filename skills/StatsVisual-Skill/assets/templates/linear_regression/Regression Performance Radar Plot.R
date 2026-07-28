## 回归模型效果评价 | Regression Performance Rader Plot

模型拟合效果，需要客观指标来评估[@RN46]，常见的有：

-   R^2，决定系数(multiple correlation coefficient, determination coefficient)，可反映模型的拟合优度(goodness of fit)，代表的是一个或多个因变量与自变量线性组合的总的相关关系，即预测变量能解释结果变量变异的百分比例，范围为0到1，R\^2越大代表拟合的越好。

-   R~adj~^2，校正负相关系数(adjusted multiple correlation coefficient)，又称修正复相关系数，在R^2基础上对方程中自变量个数进行了"惩罚"。只有当有统计学意义的变量被纳入回归方程，R~adj~^2方会增加。

-   AIC，赤池信息准则(Akaike's Information Criterion)，是日本学者赤池于1973年提出[@RN45]。AIC处理统计问题大致分为三个步骤：提出统计模型，由极大似然估计法进行参数估计，根据AIC最小化准则来优化模型。AIC鼓励数据拟合的优良性但应尽量避免出现过拟合的现象。

-   BIC，贝叶斯信息量(Bayesian Information Criterion)，对部分未知的状态用主观概率估计，然后用贝叶斯公式对后验概率进行修正，最后再利用期望值和修正概率做出最优决策。AIC和BIC均引入了对模型参数个数的惩罚项，但BIC的惩罚力度更大，更倾向于选择精简模型。

-   RMSE，均方根误差(root mean squared error)，模型预测的结果与实际观察值间的平均误差，用来衡量观测值与预测值之间的偏差，RMSE越低，效果越好。

-   RSE，残差标准误(residual standard error)，是对回归模型失拟合(lack of fit)的度量，RSE越小，代表方程拟合的越好。

本例中使用学生的学习成绩(api00)和享受膳食补贴的学生比例(meals)、学习英语的学生比例(ell)做3种简单的线性回归方程比较，可使用`performance`包中的`compare_performance`函数来比较几种回归模型的优劣，并做雷达图来更直观地显示。根据AIC和复相关系数R可看出拟合的第一个方程更好(图\@ref(fig:reg-radar))。

```{r reg-radar, fig.cap="回归雷达图"}

# 拟合线性回归方程
lmfit1 = lm(api00 ~ meals + ell, data = API)
lmfit2 = lm(api00 ~ meals, data = API)
lmfit3 = lm(api00 ~ ell, data = API)

# 比较不同模型性能
data = compare_performance(lmfit1, lmfit2, lmfit3, 
                           metrics = "all", rank = TRUE)
data = data[, -c(2, 9)]
data$RMSE = data$RMSE/100
data$Sigma = data$Sigma/100

fig17.8 = 
  ggradar(data,
        base.size = 1,
        background.circle.transparency = 0,
        plot.extent.x.sf = 1.2,
        group.colours = c("#FDAF91FF","#0099B4FF","#ED0000FF"),
        legend.position = "top",
        legend.text.size = 8,
        group.point.size = 4,
        axis.label.offset = 1.1,
        axis.label.size = 4)

ggsave(plot = fig17.8, "figure_tiff/2-13线性回归/图17.8.pdf",width = 6, height= 6, units="in")

```


