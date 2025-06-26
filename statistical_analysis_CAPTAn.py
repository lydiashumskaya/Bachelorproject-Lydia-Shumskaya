"""
Author: Lydia Shumskaya 
Project: "Predicted number of MHCII-binding gut microbiome peptides in AML patients decrease after allo-HCT"

Discription: 
Statistical analysis of unweighted CAPTAn merge score distributions. Score distributions are visualised with a violin plot. 
""" 

import pandas as pd 
from scipy.stats import mannwhitneyu
import seaborn as sns 
import matplotlib.pyplot as plt

#loading CAPTAn output
df_before = pd.read_csv("combined_before_CAPTAn.csv")
df_after = pd.read_csv("combined_after_CAPTAn.csv")

#extracting scores 
before_scores = df_before["Score"]
after_scores = df_after["Score"]

#Mann-Whitney-U test 
mwu_stat, p_value = mannwhitneyu(before_scores, after_scores, alternative = 'two-sided')
print(f"Mann-Whitney U statistic: {mwu_stat}")
print(f"P-value: {p_value}")

#concatinate data for violin plot 
df_before["Condition"] = "Pre-allo-HCT"
df_after["Condition"] = "Post-allo-HCT"
df_combined = pd.concat([df_before, df_after])

#plot violin plot
sns.violinplot(x = "Condition", y = "Score", data = df_combined, inner = "box", 
               palette={"Pre-allo-HCT": "red", "Post-allo-HCT": "blue"})
plt.title("CAPTAn-merge score distributions pre- and post-allo-HCT")
plt.ylabel("CAPTAn-merge score")
plt.show()