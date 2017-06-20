author  <- ""
version <- ""

Usage_and_Arguments <- function(author, version){
      cat(paste("
      Author: ", author, " 
      Version: ", version, "
      Description: 对丰度矩阵各行进行组间 wilcoxon 检验，并分别输出丰度显著上下调的物种丰度矩阵
      Usage:
         Rscript wilcoxon-test-parallel.R <output.prefix> <input-matrix.txt> <phenotype.txt> <cores>
      Example:
         Rscript wilcoxon-test-parallel.R ./xiu_test ~/relative_abundance.txt ~/.txt 8
"))
}

## 输出帮助文档
args <- commandArgs(TRUE)
if (length(args) == 0 || args[1] == "-h" || args[1] == "--help"){
   Usage_and_Arguments(author, version)
   q()
}

## 参数
output.prefix <- "test"
path.matrix <- "mgs.sig.abund.txt"
path.phenotype <- "group-info.txt"
number.cores <- round(as.numeric(8, 0))
threshold.fdr <- 0.05
phenotype <- c("H", "D")

## 输入丰度文件
mydata <- read.table(path.matrix, header = T, sep = "\t", comment.char = "!", row.names = 1, stringsAsFactors = F)

## 样本表型信息
myphenotype <- read.table(path.phenotype, header = T, sep = "\t", stringsAsFactors = F)
mydata.factor <- sapply( colnames(mydata), FUN = function(x) {with(myphenotype, Group[Sample == x])} )

## wilcoxon 检验
library(parallel)
mypvalues <- unlist(mclapply(1:nrow(mydata), function(i) {wilcox.test(as.numeric(mydata[i,])~mydata.factor)$p.value}, mc.cores = number.cores))
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
