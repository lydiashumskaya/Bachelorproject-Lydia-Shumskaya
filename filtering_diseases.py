#dowload table from: https://figshare.com/articles/dataset/High-resolution_analyses_of_associations_between_medications_microbiome_and_mortality_in_cancer_patients/21657806/1?file=38397710

import pandas as pd

#loading data about patients 
df = pd.read_csv("tblpatient.csv")
diseases = df["disease_simple"]

disease_range = {}
for disease in diseases:
    if disease in disease_range:
        disease_range[disease] += 1
    else:
        disease_range[disease] = 1

print(disease_range)