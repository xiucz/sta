## 简单相关系数
```r
> head(iris)
  Sepal.Length Sepal.Width Petal.Length Petal.Width Species
1          5.1         3.5          1.4         0.2  setosa
2          4.9         3.0          1.4         0.2  setosa
3          4.7         3.2          1.3         0.2  setosa
4          4.6         3.1          1.5         0.2  setosa
5          5.0         3.6          1.4         0.2  setosa
6          5.4         3.9          1.7         0.4  setosa
> cor(iris[,-5], use = "everything", method = "pearson")
             Sepal.Length Sepal.Width Petal.Length Petal.Width
Sepal.Length    1.0000000  -0.1175698    0.8717538   0.8179411
Sepal.Width    -0.1175698   1.0000000   -0.4284401  -0.3661259
Petal.Length    0.8717538  -0.4284401    1.0000000   0.9628654
Petal.Width     0.8179411  -0.3661259    0.9628654   1.0000000
```
```
## use="everything" 表示某变量存在缺失值时，不计算它和其他变量的相关系数；
## use="complete.obs"
## method = "pearson" 表示计算简单相关系数；
## method = "spearman"
## method = "kendall"
```
```
> library(Hmisc)
> res <- rcorr(as.matrix(iris[,-5]))
             Sepal.Length Sepal.Width Petal.Length Petal.Width
Sepal.Length         1.00       -0.12         0.87        0.82
Sepal.Width         -0.12        1.00        -0.43       -0.37
Petal.Length         0.87       -0.43         1.00        0.96
Petal.Width          0.82       -0.37         0.96        1.00

n= 150 


P
             Sepal.Length Sepal.Width Petal.Length Petal.Width
Sepal.Length              0.1519      0.0000       0.0000     
Sepal.Width  0.1519                   0.0000       0.0000     
Petal.Length 0.0000       0.0000                   0.0000     
Petal.Width  0.0000       0.0000      0.0000                  
```
```
flattenCorrMatrix <- function(cormat, pmat) { 
  ut <- upper.tri(cormat) data.frame( row = rownames(cormat)[row(cormat)[ut]], 
  column = rownames(cormat)[col(cormat)[ut]], cor =(cormat)[ut], p = pmat[ut] )
  }

flattenCorrMatrix(res$r, res$P)
```
cor.test(iris[,1], iris[,3])

pairs(iris[,-5])

## 可视化

### symnum()
```

```
### corrplot()

### scatter plots
```
library(PerformanceAnalytics)#加载包
chart.Correlation()
```

### heatmap



## 偏相关系数
```r
> library(corpcor)
> c <- cor(iris[,-5], use = "everything", method = "pearson")
> cor2pcor(c)
           [,1]       [,2]       [,3]       [,4]
[1,]  1.0000000  0.6285707  0.7190656 -0.3396174
[2,]  0.6285707  1.0000000 -0.6152919  0.3526260
[3,]  0.7190656 -0.6152919  1.0000000  0.8707698
[4,] -0.3396174  0.3526260  0.8707698  1.0000000
```


## 典型相关分析
研究整体的相关系数
