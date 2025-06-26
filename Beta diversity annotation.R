#Author: Lydia Shumskaya
#In house script was used as reference 
#Project: "Predicted number of MHCII-binding gut microbiome peptides in AML patients decrease after allo-HCT"

#Description:
#Analysis on functional annotation level, including bray-curtis beta diversity, PCoA plots, 
#PERMANOVA, Shannon diversity and linear mixed-effects model

#loading packages 
library(vegan)
library(ape)
library(tidyr)

#importing annotation matrix and metadata 
annotation = t(as.matrix(read.delim("annotation_matrix.tsv",row.names=1)))
sample_info = read.csv("Sample storage.csv", fileEncoding = "UTF-8")

#separating coloumn 
colnames(sample_info)[1] = "raw"
sample_info = separate(sample_info, raw,
                       into = c("SampleID", "Node", "Patient", "Day"),
                       sep = ";")

#set day coloumn to numeric
sample_info$Day = as.numeric(sample_info$Day)

dim(annotation) #there are 117 samples and 12602 functional annotations

#remove '_mg' from annotation to match metadata
rownames(sample_info) = sample_info$SampleID
rownames(annotation) = gsub("_mg$", "", rownames(annotation))
sample_info = sample_info[rownames(annotation), ]

#calculating bray-curtis dissimilarity matrix 
bc = vegdist(annotation)
pcoa = pcoa(bc)
pcoa_val = 100*c(pcoa$values[pcoa$values[,2]>0,2]/sum(pcoa$values[pcoa$values[,2]>0,2]))

#PcoA plot 0: no colors
plot(pcoa$vector[,1:2],
     pch = 20,
     xlab=paste0("PC1 (",round(pcoa_val[1],digits = 1),"%)"),
     ylab=paste0("PC2 (",round(pcoa_val[2],digits = 1),"%)"),
     main = "PCoA of functional annotation from microbiome samples of AML patients")
box()

#PCoA plot 1: before vs after allo-HCT
group_col = ifelse(sample_info$Day < 0, "tomato1", "royalblue1")
plot(pcoa$vectors[,1:2],
     col = group_col,
     pch = 19,
     xlab = paste0("PC1 (", round(pcoa_val[1], 1), "%)"),
     ylab = paste0("PC2 (", round(pcoa_val[2], 1), "%)"),
     main = "PCoA of functional annotation from microbiome samples of AML patients",
     cex.main = 0.9)
legend("topright", legend = c("Pre-allo-HCT", "Post-allo-HCT"),
       col = c("tomato1", "royalblue1"), pch = 19, bty = "n", cex = 0.6)
box()

#PERMANOVA: Pre- vs post-allo-HCT 
sample_info$Group = ifelse(sample_info$Day < 0, "Before", "After")
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
     main = "PCoA of functional annotation from microbiome samples of AML patients",
     cex.main = 0.9)
legend("topright", legend = names(patient_colors),
       col = patient_colors, pch = 16, bty = "n", cex = 0.4)
box()


#PERMANOVA: color by patient 
permanova_result2 = adonis2(bc ~ Patient, data = sample_info, permutations = 999)
print(permanova_result2)