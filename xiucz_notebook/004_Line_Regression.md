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
```
