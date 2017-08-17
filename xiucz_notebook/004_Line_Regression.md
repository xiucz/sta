```
Y = a0 + a1X1 + a2X2 + ...
```
与典型回归分析相似，自变量的纲量大小同样会影响系数大小.为了消除自变量的纲量对系数的影响，不妨将自变量和因变量全部标准化。
```
SL.sc <- scale(iris[,1])
SW.sc <- scale(iris[,2])
PL.sc <- scale(iris[,3])
PW.sc <- scale(iris[,4])
> range(SL.sc);range(SW.sc);range(PL.sc);range(PW.sc )
[1] -1.863780  2.483699
[1] -2.425820  3.080455
[1] -1.562342  1.779869
[1] -1.442245  1.706379
```
标准化数据同样也给出了一个非常重要的范围，在我们将回归方程用于预测时，代入回归方程进行计算的自变量都应该是标准化后的自变量，而且自变量的值不能超出上述代码所给的范围。

## OLS(ordinary least square)
lm(因变量~自变量)
```r
> lm.sc <- lm(SL.sc ~ SW.sc + PL.sc + PW.sc)
> summary(lm.sc)

Call:
lm(formula = SL.sc ~ SW.sc + PL.sc + PW.sc)

Residuals:     Min       1Q   Median       3Q      Max
-1.00012 -0.26555  0.02264  0.23802  1.02129 

Coefficients:              
              Estimate Std. Error t value Pr(>|t|)    
(Intercept) -1.176e-16  3.102e-02   0.000        1    
SW.sc        3.426e-01  3.508e-02   9.765  < 2e-16 ***
PL.sc        1.512e+00  1.209e-01  12.502  < 2e-16 ***
PW.sc       -5.122e-01  1.174e-01  -4.363 2.41e-05 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.3799 on 146 degrees of freedom
Multiple R-squared:  0.8586,    Adjusted R-squared:  0.8557 
F-statistic: 295.5 on 3 and 146 DF,  p-value: < 2.2e-16
```
```
R关于summary()函数的返回结果是一个列表：
Call元素给出来线性回归模型的基础信息；
Residuals元素给出了线性回归模型的残差的5个分位数，用于衡量回归方程的合理程度；
Coefficients给出了每一个自变量的系数和可信程度
```
解读
```
R-squared: 0.8586,  Adjusted R-squared:  0.8557:表明回归方程能够解释原始数据中约85.57%的信息;

模型总体的F值、自由度和P-value: p值用于衡量方程总体的显著成都，该值(2.2e-16)小于0.001,因此该回归方程是可信的；


```

拟合模型后，将这些函数应用于lm()返回的对象，可以得到更多额外模型信息。
```
summary()：展示拟合模型的详细结果；
coefficients()：列出拟合模型的模型参数（截距和斜率）；
confint()：提供模型参数的置信区间（默认95%）；
fitted()：列出拟合模型的预测值；
residuals()：列出拟合模型的残差值；
anova()：生成一个拟合模型的方差分析表，或者比较两个或更多拟合模型的方差分析表；
vcov()：列出模型参数的协方差矩阵；
AIC()：输出赤池信息统计量；
plot()：生成评价拟合模型的诊断图；
predict()：用拟合模型对新的数据集预测响应变量值。
```
