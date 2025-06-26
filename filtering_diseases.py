"""
Author: Lydia Shumskaya 
Project: "Predicted number of MHCII-binding gut microbiome peptides in AML patients decrease after allo-HCT"

Discription: 
This script filters and extracts accession numbers of 
shotgun metagenomic sequenced samples from AML patient based on the metadata.

tblmeta_data.csv and tblpatient.csv can be downloaded from:
https://figshare.com/articles/dataset/High-resolution_analyses_of_associations_between_medications_microbiome_and_mortality_in_cancer_patients/21657806/1?file=38397710
""" 

import pandas as pd

#Loading data about patients
df_patient = pd.read_csv("tblpatient.csv")
diseases = df_patient["disease_simple"]

disease_types ={}
for i in diseases:
    if i in disease_types:
        disease_types[i] += 1
    else:
        disease_types[i] = 1

print(disease_types) #There are 464 AML patients and 879 patients with other diseases

#Loading meta data
df_meta = pd.read_csv("tblmeta_data.csv")
print(len(df_meta["sampleid"])) #There are 9640 samples in total 

#Getting patient IDs for AML patients
patient_id_with_AML = df_patient[df_patient["disease_simple"] == "AML"]["PatientID"]

#Getting sample ID, day relative to HCT, and Accession number of AML patients
aml_samples = df_meta[df_meta["PatientID"].isin(patient_id_with_AML)][["PatientID", "day_relative_to_hct", "Accession_shotgun"]]

#Removing samples that are not shotgun metagenomic sequenced 
aml_samples = aml_samples.dropna(subset=["Accession_shotgun"])

#Creating a dictionary for easier filtering  
temp_patient_samples = {}
for _, row in aml_samples.iterrows():
    patient = row["PatientID"]
    day_relative = row["day_relative_to_hct"]
    accession = row["Accession_shotgun"]
    
    if patient in temp_patient_samples:
        temp_patient_samples[patient].append((day_relative, accession))
    else:
        temp_patient_samples[patient] = [(day_relative, accession)]

#Filtering patients who have at least one sample before and after HCT, and more than one sample
filtered_relative_days_per_patient = {
    patient: data for patient, data in temp_patient_samples.items()
    if len(data) > 1 and any(d[0] < 0 for d in data) and any(d[0] > 0 for d in data)
}

#Printing the filtered dictionary
for patient, data in filtered_relative_days_per_patient.items():
    formatted_data = ", ".join([f"({day}, {accession})" for day, accession in data])
    print(f"{patient}: {formatted_data}")
    

#Extracting and saving filtered accession numbers
filtered_accessions = {
    accession 
    for data in filtered_relative_days_per_patient.values() 
    for _, accession in data}
print(len(filtered_accessions)) #after filtering there are 157 samples left 

with open("accessions.txt", "w") as f:
    for accession in filtered_accessions:
        f.write(accession + "\n")



