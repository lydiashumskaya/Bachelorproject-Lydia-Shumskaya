#Author: Lydia Shumskaya
#In house script was used as reference 
#Project: "Predicted number of MHCII-binding gut microbiome peptides in AML patients decrease after allo-HCT"

#Description:
#Differentially abundant functions analysis using ANCOM with reduced iterations 

#loading packages 
library(robCompositions)
library(compositions)
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

#remove '_mg' from annotation to match metadata
rownames(sample_info) = sample_info$SampleID
rownames(annotation) = gsub("_mg$", "", rownames(annotation))
sample_info = sample_info[rownames(annotation), ]

#Differential abundance analysis 

source("ancom_v2.1_noTidy.R")

#make sampling time points binary 
sample_info$Group = sample_info$Day < 0 

#preprocessing data 
processed = feature_table_pre_process(feature_table = t(annotation), 
                                    meta_data = sample_info, 
                                    sample_var = "SampleID", 
                                    group_var = "Group", 
                                    out_cut = 0.01, 
                                    zero_cut = 0.95, 
                                    lib_cut = 800, 
                                    neg_lb = T)

#find differtially abundant functions
differential = ANCOM(feature_table=processed$feature_table, 
                      meta_data=processed$meta_data, 
                      struc_zero=processed$structure_zeros, 
                      main_var="Group", 
                      p_adj_method= "BH", 
                      alpha= 0.05, 
                      adj_formula =NULL,
                      rand_formula = "~ 1 | Patient",
                      control = lmeControl(maxIter = 20, msMaxIter = 40, opt = "optim"))

plot(differential$fig)

#Get names of differentially abundant functions
differential$out$taxa_id[which(differential$out$detected_0.9 & !is.infinite(differential$out$W))]
#structural zeroes:
length(differential$out$taxa_id[is.infinite(differential$out$W)])
