## 
数值变量 --> 观测变量  
分类变量 --> 控制变量

## 前提条件
* 方差分析模型是线性可加模型，模型中的分量直接应该有线性关系；
* 独立方差性：样本必须来自于一个正态分布总体，并且样本间是相互独立的；
* 等方差性或方差齐性：抽样的总体必须是等方差的。
## 单因素方差分析
### 
```r
> head(Orange)
Tree  age circumference1
1  118            302    
1  484            583    
1  664            874    
1 1004           1155    
1 1231           1206    
1 1372           142
```
Tree,age 控制变量  
circumference 观测变量

### 正态性检验
```r
library("multcomp")
attach(cholesterol)
head(cholesterol)
```
```r
> for (i in levels(cholesterol$trt)){print(shapiro.test(response[trt==i]))}

        Shapiro-Wilk normality test
data:  response[trt == i]
W = 0.93063, p-value = 0.4541

        Shapiro-Wilk normality test
data:  response[trt == i]
W = 0.9432, p-value = 0.5892

        Shapiro-Wilk normality test
data:  response[trt == i]
W = 0.95487, p-value = 0.7262

        Shapiro-Wilk normality test
data:  response[trt == i]
W = 0.93406, p-value = 0.489

        Shapiro-Wilk normality test
data:  response[trt == i]
W = 0.98085, p-value = 0.9696
```
shapiro.test函数输出一个p值，照惯例，p<0.05说明总体不太可能是正太分布，否则不能提供这么个证据，也就是说这个检验比较保守，倾向于错误的过分证明正态性。
http://blog.csdn.net/yucan1001/article/details/23539639  
http://blog.csdn.net/troubleisafriend/article/details/48008189

### 方差齐次性检验（homoskedasticity）
* Bartlett检验
* Levene检验（由car包提供）
* fligner.test(dati, groups)
```r
>  bartlett.test(response ~ trt,data = cholesterol)

        Bartlett test of homogeneity of variances

data:  response by trt
Bartlett's K-squared = 0.57975, df = 4, p-value = 0.9653

> library(car)
> leveneTest(response ~ trt,data = cholesterol)
Levene's Test for Homogeneity of Variance (center = median)
      Df F value Pr(>F)
group  4  0.0755 0.9893
      45  

> fligner.test(response ~ trt,data = cholesterol)

        Fligner-Killeen test of homogeneity of variances

data:  response by trt
Fligner-Killeen:med chi-squared = 0.74277, df = 4, p-value = 0.946
             
```
无论Bartlett检验还是Levene检验，两者的P值都大于0.05，因此接受原假设：样本之间的方差是相同的，因此可以接着做方差分析了。  
**注意：**如果发现不是样本件非等方差，那么就需要用Welch的ANOVA分析法.函数为oneway.test()，参数为var.equal=FALSE

### 方差分析
```r
## 
> fit <- aov(response ~ trt)
> fit
Call:
   aov(formula = response ~ trt)

Terms:
                      trt Residuals
Sum of Squares  1351.3690  468.7504
Deg. of Freedom         4        45

Residual standard error: 3.227488
Estimated effects may be unbalanced
> summary(fit)
            Df Sum Sq Mean Sq F value   Pr(>F)    
trt          4 1351.4   337.8   32.43 9.82e-13 ***
Residuals   45  468.8    10.4                     
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
## 
> anova(lm(formula = response ~ trt))
Analysis of Variance Table

Response: response
          Df  Sum Sq Mean Sq F value    Pr(>F)    
trt        4 1351.37  337.84  32.433 9.819e-13 ***
Residuals 45  468.75   10.42                      
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

```
### 多重比较
#### 多重t检验
```r
> pairwise.t.test(response,trt,p.adjust.method = "none")

        Pairwise comparisons using t tests with pooled SD 

data:  response and trt 

       1time   2times  4times  drugD  
2times 0.02133 -       -       -      
4times 3.8e-05 0.03435 -       -      
drugD  3.5e-08 0.00011 0.04432 -      
drugE  1.1e-13 2.3e-10 3.8e-07 0.00035

P value adjustment method: none 
```

#### 同时置信区间：Tukey法
Tukey区间计算比较复杂，但是克服了多重t检验不修正时存在过多显著性差异，修正后可能又太少的问题。
```r
> TukeyHSD(fit)
  Tukey multiple comparisons of means
    95% family-wise confidence level

Fit: aov(formula = response ~ trt)

$trt
                  diff        lwr       upr     p adj
2times-1time   3.44300 -0.6582817  7.544282 0.1380949
4times-1time   6.59281  2.4915283 10.694092 0.0003542
drugD-1time    9.57920  5.4779183 13.680482 0.0000003
drugE-1time   15.16555 11.0642683 19.266832 0.0000000
4times-2times  3.14981 -0.9514717  7.251092 0.2050382
drugD-2times   6.13620  2.0349183 10.237482 0.0009611
drugE-2times  11.72255  7.6212683 15.823832 0.0000000
drugD-4times   2.98639 -1.1148917  7.087672 0.2512446
drugE-4times   8.57274  4.4714583 12.674022 0.0000037
drugE-drugD    5.58635  1.4850683  9.687632 0.0030633

> plot(TukeyHSD(fit))
```

## Reference_Info
https://mp.weixin.qq.com/s/Kn7Mq-9g_X7ogs9RjgX22Q
