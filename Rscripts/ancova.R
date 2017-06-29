library(HH)
mydf = read.table("tp.txt", sep = "\t", header = T)
head(mydf)
  Taxonomy group med p__Bacteroidetes p__Firmicutes p__Proteobacteria p__Fusobacteria p__Verrucomicrobia p__Actinobacteria p__Cyanobacteria p__Tenericutes p__Lentisphaerae
1    aa002   pre ctr        0.7667950     0.2184745       0.009307208       0.0000000        0.004653604       0.000209937      0.000244927    0.000279916          3.5e-05
2    aa006   pre ctr        0.6793562     0.2475157       0.069594122       0.0000000        0.000000000       0.003358992      0.000174948    0.000000000          0.0e+00
3    aa009   pre ctr        0.5317355     0.3692092       0.080685794       0.0000000        0.018019594       0.000349895      0.000000000    0.000000000          0.0e+00
4    aa011   pre ctr        0.5857593     0.3389083       0.047935619       0.0000000        0.000000000       0.027221833      0.000104969    0.000000000          0.0e+00
5    aa028   pre ctr        0.4454864     0.3118614       0.178866340       0.0543387        0.000000000       0.009377187      0.000070000    0.000000000          0.0e+00
6    aa034   pre ctr        0.6463611     0.3337299       0.017984605       0.0000000        0.001364591       0.000349895      0.000000000    0.000174948          3.5e-05

pre_group <- mydf[mydf$group == "pre",]
post_group <- mydf[mydf$group == "post",]
colnames(post_group) <- paste(colnames(post_group), "_post", sep = "")
combine_group <- cbind(pre_group,post_group)
species_names <- colnames(pre_group)[grep(pattern="p__|Other", colnames(pre_group))]

pvalue_result <- vector()
pvalue_result <- data.frame()
for (i in species_names) {
i_pre = combine_group[,i]
i_pre_loc = grep(i,colnames(combine_group))[1]
i_post = combine_group[, grep(paste(i, "_post", sep = ""), colnames(combine_group))]
i_post_loc = grep(i,colnames(combine_group))[2]
i_data = combine_group[,c(3,i_pre_loc,i_post_loc)]
colnames(i_data) = c("med", "pre", "post")
ancova_list <- unlist(summary(ancova(post ~ pre + med, data = i_data)))
pvalue <- ancova_list[names(ancova_list) == "Pr(>F)2"]
pvalue <- as.numeric(pvalue)
print(i)
print(pvalue)
pvalue_result <- rbind( pvalue_result, data.frame( species = i,  pvalue = pvalue ))
#append(pvalue_result,pvalue)
#print(pvalue_result)
}
pvalue_result
#
