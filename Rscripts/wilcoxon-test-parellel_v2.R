
setwd("F:\\000000000\\20170607")
## 参数
output.prefix <- "xiu_test"
path.matrix <- "mgs.sig.abund.txt"
path.phenotype <- "group-info.txt"
number.cores <- round(as.numeric(8, 0))
threshold.fdr <- 0.05
phenotype <- c("H", "D")

## 输入丰度文件
mydata <- read.table(path.matrix, header = T, sep = "\t", comment.char = "!", row.names = 1, stringsAsFactors = F)

## 样本表型信息
group.info <- read.table(path.phenotype, header = T, sep = "\t", stringsAsFactors = F)
mydata.factor <- sapply(colnames(mydata), FUN = function(x) {with(group.info, Group[Sample == x])} )

head(mydata)
head(group.info)
library(reshape2)
mydata_tmp <- as.data.frame(t(mydata))
mydata_tmp$Sample <- rownames(mydata_tmp)
all.data <- merge(group.info, mydata_tmp, by.x = "Sample", by.y = "Sample")
all.data <- all.data[,c(2,12:ncol(all.data))]

library(FSA)
head(all.data)
#apply(all.data[, 2:ncol(all.data)], MARGIN = 2,FUN = function(x) {kruskal.test(as.numeric(x)~ factor(all.data$Group))$p.value})
mypvalues <- sapply(2:ncol(all.data), FUN = function(x) {kruskal.test(as.numeric(all.data[,x])~ factor(all.data$Group))$p.value})
mypvalues.adjust <- p.adjust(mypvalues, method = "fdr")

## wilcoxon 检验
library(parallel)
mydata
mypvalues <- unlist(mclapply(2:nrow(mydata), function(i) {wilcox.test(as.numeric(mydata[i,])~mydata.factor)$p.value}))
mypvalues.adjust <- p.adjust(mypvalues, method = "fdr")

## 组内均值及组间差值
mean.healthy <- rowMeans(mydata[, names(mydata.factor)[mydata.factor == phenotype[1]]])
mean.disease <- rowMeans(mydata[, names(mydata.factor)[mydata.factor == phenotype[2]]])
mean.diff <- mean.disease - mean.healthy

## 输出文件
result <- data.frame(gene = rownames(mydata), pvalue = mypvalues, fdr = mypvalues.adjust,
                     mean.healthy = mean.healthy, mean.disease = mean.disease, mean.diff = mean.diff)
write.table(x = result, file = paste(output.prefix, ".stats.txt", sep = ""),
            row.names = F, sep = "\t", quote = F)
write.table(x = mydata[mypvalues.adjust < threshold.fdr & mean.diff > 0,],
            file = paste(output.prefix, ".p", as.character(threshold.fdr), ".up.txt", sep = ""),
            col.names = F, row.names = T, sep = "\t", quote = F)
write.table(x = mydata[mypvalues.adjust < threshold.fdr & mean.diff < 0,],
            file = paste(output.prefix, ".p", as.character(threshold.fdr), ".down.txt", sep = ""),
            col.names = F, row.names = T, sep = "\t", quote = F)
write.table(x = t(c("gene", colnames(mydata))), file = paste(output.prefix, ".header.txt", sep = ""),
row.names = F, col.names = F, sep = "\t", quote = F)

