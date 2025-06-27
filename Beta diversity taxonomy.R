#Author: Lydia Shumskaya
#In house script was used as reference
#A tutorial for using the lme function from the nlme package was used as reference: 
#https://www.crumplab.com/psyc7709_2019/book/docs/a-tutorial-for-using-the-lme-function-from-the-nlme-package-.html
#Project: "Predicted number of MHCII-binding gut microbiome peptides in AML patients decrease after allo-HCT"

#Description:
#Analysis on taxonomic level, including bray-curtis beta diversity, PCoA plots, 
#PERMANOVA, Shannon diversity and linear mixed-effects model

#loading packages 
library(vegan)
library(ape)
library(tidyr)
library(nlme)
library(ggplot2)

#importing motus and metadata 
motus = t(as.matrix(read.delim("all.motus.tsv",row.names=1)))
sample_info = read.csv("Sample storage.csv", fileEncoding = "UTF-8")

#separating column 
colnames(sample_info)[1] = "raw"
sample_info = separate(sample_info, raw,
                        into = c("SampleID", "Node", "Patient", "Day"),
                        sep = ";")

#set day column to numeric
sample_info$Day = as.numeric(sample_info$Day)

dim(motus) #there are 117 samples, 1577 taxa

#set metadata rownames to match motus
rownames(sample_info) = sample_info$SampleID
sample_info = sample_info[rownames(motus), ]

#calculating bray-curtis and PCoA 
bc = vegdist(motus)
pcoa = pcoa(bc)
pcoa_val = 100*c(pcoa$values[pcoa$values[,2]>0,2]/sum(pcoa$values[pcoa$values[,2]>0,2]))

#PCoA plot 0: no colors
plot(pcoa$vector[,1:2],
     pch = 20,
     xlab=paste0("PC1 (",round(pcoa_val[1],digits = 1),"%)"),
     ylab=paste0("PC2 (",round(pcoa_val[2],digits = 1),"%)"),
     main = "PCoA of taxonomic profiles from microbiome samples of AML patients")
box()

#PCoA plot 1: Pre- vs post-allo-HCT
group_col = ifelse(sample_info$Day < 0, "tomato1", "royalblue1")
plot(pcoa$vectors[,1:2],
     col = group_col,
     pch = 19,
     xlab = paste0("PC1 (", round(pcoa_val[1], 1), "%)"),
     ylab = paste0("PC2 (", round(pcoa_val[2], 1), "%)"),
     main = "PCoA of taxonomic profiles from microbiome samples of AML patients",
     cex.main = 0.9)
legend("topright", legend = c("Pre-allo-HCT", "Post-allo-HCT"),
       col = c("tomato1", "royalblue1"), pch = 19, bty = "n", cex = 0.6)
box()

#check number of samples before vs after allo-HCT
table(sample_info$Day < 0)

#PERMANOVA: before vs after allo-HCT 
sample_info$Group = ifelse(sample_info$Day < 0, "Pre-allo-HCT", "Post-allo-HCT")
permanova_result1 = adonis2(bc ~ Group, data = sample_info, permutations = 999)
print(permanova_result1)

#PCoA plot 2: color by patient
patient_colors = rainbow(length(unique(sample_info$Patient)))
names(patient_colors) = unique(sample_info$Patient)

plot(pcoa$vectors[,1:2],
     col = patient_colors[sample_info$Patient],
     pch = 19,
     xlab = paste0("PC1 (", round(pcoa_val[1], 1), "%)"),
     ylab = paste0("PC2 (", round(pcoa_val[2], 1), "%)"),
     main = "PCoA of taxonomic profiles from microbiome samples of AML patients",
     cex.main = 0.9)
legend("topright", legend = names(patient_colors),
       col = patient_colors, pch = 16, bty = "n", cex = 0.4)
box()

#PERMANOVA: color by patient 
permanova_result2 = adonis2(bc ~ Patient, data = sample_info, permutations = 999)
print(permanova_result2)

#Compute Shannon diversity
sample_info$Group = factor(sample_info$Group, levels = c("Pre-allo-HCT", "Post-allo-HCT"))
sample_info$shannon = diversity(motus, index = "shannon")

ggplot(sample_info, aes(x = Group, y = shannon, fill = Group)) +
  geom_violin(trim = FALSE) +
  geom_boxplot(width = 0.1, outlier.shape = NA, alpha = 0.9) +
  scale_fill_manual(values = c("Pre-allo-HCT" = "tomato1", "Post-allo-HCT" = "royalblue1")) +
  theme_minimal() +
  theme(
    legend.position = "none",
    panel.grid = element_blank(),
    panel.border = element_rect(color = "black", fill = NA, size = 1)
  ) +
  labs(title = "Shannon diversity of microbial taxa pre- and post-allo-HCT in AML patients",
       x = "Sampling time point", y = "Shannon diversity index") 

#Linear mixed-effects model 
sample_info$Patient = factor(sample_info$Patient)
lme_mod = lme(fixed  = shannon ~ Group, random = ~ 1 | Patient, data   = sample_info)

#print results 
summary(lme_mod)
anova(lme_mod)
