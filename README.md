# Bachelorproject Lydia Shumskaya

## Predicted number of MHCII-binding gut microbiome peptides in AML patients decrease after allo-HCT
 
## Lydia Shumskaya
 
## Supervised by Dr. rer. nat. A.U.S. Heintz Buschart

## Description  
This repository contains the scripts used to analyze microbial metagenomic data to compare MHCII binding prediction in AML patients before and after allogeneic hematopoietic stem cell transplantation (allo-HCT).

## Requirements  
- **R version:** 4.3.3
- **Python version:** 3.12.4
- **Bash version:** 4.4.20   
- **R packages:**  
  - vegan  
  - ape  
  - tidyr  
  - robCompositions  
  - compositions
- **Python libraries:**
  - pandas
  - scipy.stats
  - seaborn
  - matplotlib.pyplot
  - numpy
- **Bash packages:**
  - BLASTp
  - CD-HIT
  - IMP3
  - CAPTAn
  
## Scripts summary  

| Script                         | Description                                                                                                                   |
|--------------------------------|-------------------------------------------------------------------------------------------------------------------------------|
| `Beta_diversity_taxonomy.R`    | Statistical analysis on taxonomic level, including Bray-Curtis beta diversity, PCoA, PERMANOVA, Shannon diversity, and linear mixed-effects model |
| `Beta_diversity_annotation.R`  | Statistical analysis on functional annotation level, including Bray-Curtis beta diversity, PCoA, and PERMANOVA                 |
| `Beta_diversity_annotation_unix.R` | Differentially abundant functions analysis using ANCOM with optimized iteration settings                                    |
| `ancom_reduced_iterations.R`   | Differentially abundant functions analysis using ANCOM with reduced iteration counts                                            |
| `filtering_diseases.py`        | Filters and extracts accession numbers of shotgun metagenomic sequenced samples from AML patients based on metadata           |
| `statistical_analysis_CAPTAn.py`         | Statistical analysis of unweighted CAPTAn merge score distributions; visualised with a violin plot                        |
| `statistical_analysis_CAPTAn_multiplied.py` | Statistical analysis of weighted CAPTAn merge score distributions; visualised with a violin plot                      |
| `captan_script.sh`             | Runs CAPTAn core, context, or merge depending on the input                                                                     |
| `cdhit.sh`                    | Runs CD-HIT with minimum sequence identity threshold of 90%, requiring at least 10% coverage of the longer sequence and full coverage of the shorter sequence |
| `check_markers.sh`             | Performs BLASTp on predicted protein sequences to find human AML protein markers                                               |
| `extract_annotation.sh`        | Extracts and renames mg.KEGG.counts.tsv file from IMP3 output directory                                                       |
| `extract_counts.sh`            | Extracts and renames mg.CDS_counts.tsv file from IMP3 output directory                                                       |
| `extract_fasta.sh`             | Extracts and renames prokka.faa file from IMP3 output directory                                                              |
| `extract_moTUs.sh`             | extracts and renames mg.mOTU.counts.tsv file from IMP3 output directory                                                              |
| `prep.assembly.anno.tax.yaml`             | IMP3 config file                                                             |
