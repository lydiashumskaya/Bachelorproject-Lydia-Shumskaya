#dowload table from: https://figshare.com/articles/dataset/High-resolution_analyses_of_associations_between_medications_microbiome_and_mortality_in_cancer_patients/21657806/1?file=38397710

import pandas as pd

#Loading data about patients 
df_patient = pd.read_csv("tblpatient.csv")
diseases = df_patient["disease_simple"]

#loading meta data
df_meta = pd.read_csv("tblmeta_data.csv")

disease_range = {}
for disease in diseases:
    if disease in disease_range:
        disease_range[disease] += 1
    else:
        disease_range[disease] = 1

print(disease_range)#Conclusion: 2 groups, AML and others. I will go with AML. 

#Getting patient ID 
patient_id_with_AML = df_patient[df_patient["disease_simple"] == "AML"]["PatientID"]

#Getting sample ID, day relative to HCT and Accession number of AML patients
aml_samples = df_meta[df_meta["PatientID"].isin(patient_id_with_AML)][["PatientID", "sampleid", "day_relative_to_hct", "Accession"]]

print(aml_samples)

#Making a dictionary with Patient ID and day_relative_to_hct
relative_days_per_patient ={}

for _, row in aml_samples.iterrows():
    patient = row["PatientID"]
    day_relative = row["day_relative_to_hct"]
    
    if patient in relative_days_per_patient:
        relative_days_per_patient[patient].append(day_relative)
    else:
        relative_days_per_patient[patient] = [day_relative]
        

for patient, days in relative_days_per_patient.items():
    print(f"{patient}: {', '.join(map(str, days))}")

#what is the next step 
