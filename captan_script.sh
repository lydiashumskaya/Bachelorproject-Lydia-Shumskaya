#!/bin/bash -i

#Author: Lydia Shumskaya
#Script was written using the GNU Bash Reference Manual as reference: https://www.gnu.org/software/bash/manual/bash.pdf
#Script was written using the CAPTAn documentation from GitLab: https://gitlab.com/xavier-lab-computation/public/captan
#Project: Predicted number of MHCII-binding gut microbiome peptides in AML patients decrease after allo-HCT

#Description:
#This script runs CAPTAn core, context or merge depending on the input.


#Activate conda to access CAPTAn
conda activate /zfs/omics/projects/metatools/TOOLS/miniconda3/envs/captan37/

#Assign input
IN_FA=$1
MODE=$2

#Define paths to CAPTAn core, context and output dictionary
MODEL_CORE_DIR=/zfs/omics/projects/metatools/TOOLS/captan/models/models_core
MODEL_CTX_DIR=/zfs/omics/projects/metatools/TOOLS/captan/models/models_context
OUT_DIR=output_CAPTAn_$(basename "$IN_FA" .faa)

#Make output directory 
mkdir -p "$OUT_DIR"

#Run CAPTAn with chosen model 
case "$MODE" in
    core)
        captan-core --models "$MODEL_CORE_DIR" --input "$IN_FA" --output "$OUT_DIR" --details
        ;;
    context)
        captan-context --models "$MODEL_CTX_DIR" --input "$IN_FA" --output "$OUT_DIR" --details
        ;;
    merge)
        captan-merge --models "$MODEL_CTX_DIR" --input "$IN_FA" --output "$OUT_DIR" --details
        ;;
    *)
        exit 1
        ;;
esac



