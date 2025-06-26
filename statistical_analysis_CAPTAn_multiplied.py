"""
Author: Lydia Shumskaya 
Project: "Predicted number of MHCII-binding gut microbiome peptides in AML patients decrease after allo-HCT"

Discription: 
Statistical analysis of weighted CAPTAn merge score distributions. Score distributions are visualised with a violin plot. 
""" 
import pandas as pd 
from scipy.stats import mannwhitneyu
import seaborn as sns 
import matplotlib.pyplot as plt
import numpy as np

#loading CAPTAn output
df_before = pd.read_csv("multiplied_CAPTAn_before.csv")
df_after = pd.read_csv("multiplied_CAPTAn_after.csv")

#extracting scores 
before_scores = df_before["Score_times_count"]
after_scores = df_after["Score_times_count"]

#Mann-Whitney U test 
mwu_stat, p_value = mannwhitneyu(before_scores, after_scores, alternative = 'two-sided')
print(f"Mann-Whitney U statistic: {mwu_stat}")
print(f"P-value: {p_value:.10e}")
print(before_scores.median())
print(after_scores.median())

#concatinate and log transform data for violin plot 
df_before["Condition"] = "Pre-allo-HCT"
df_after["Condition"] = "Post-allo-HCT"
df_combined = pd.concat([df_before, df_after])
df_combined["Log_Score"] = np.log10(df_combined["Score_times_count"] + 1e-10)

#plot violin plot
sns.violinplot(x ="Condition", y = "Log_Score", data = df_combined, inner = "box", 
               palette={"Pre-allo-HCT": "red", "Post-allo-HCT": "blue"})
plt.title("Weighted CAPTAn-merge score distributions pre- and post-allo-HCT")
plt.ylabel(r"$\log_{10}(\mathrm{Weighted\ CAPTAn\text{-}merge\ score} + 10^{-10})$")
plt.show()