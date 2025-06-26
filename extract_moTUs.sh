#!/bin/bash

#Author: Lydia Shumskaya
#Script was written using the GNU Bash Reference Manual as reference: https://www.gnu.org/software/bash/manual/bash.pdf
#Project: Predicted number of MHCII-binding gut microbiome peptides in AML patients decrease after allo-HCT

#Description:
#Script that extracts and renames mg.mOTU.counts.tsv file from IMP3 output directory

#IMP3 output directory is the input
echo "Enter the output directory:"
read output_directory

#Extract accession number from IMP3 output directory name
accession_number=$(echo "$output_directory" | grep -o 'SRR[0-9]\+')

#Define path to mg.mOTU.counts.tsv in IMP3 output and the mOTUs directory
input_motus="$output_directory/Analysis/taxonomy/mOTUs/mg.mOTU.counts.tsv"
motus_directory="/scratch/14212781/SRA/mOTUs"

#Make the mOTUs directory if it is not on the node yet
mkdir -p "$motus_directory"

#Define path to mg.mOTU.counts.tsv file in mOTUs directory
output_motus="$motus_directory/${accession_number}_mg.mOTU.counts.tsv"

#Rename and move the mg.mOTU.counts.tsv file
if [ -f "$input_motus" ]; then
    cp "$input_motus" "$output_motus"
    echo "The mg.mOTU.counts.tsv file is renamed and moved to $output_fasta"
else
    echo "The mg.mOTU.counts.tsv file is not present in the IMP3 output"
fi

