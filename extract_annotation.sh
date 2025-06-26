#!/bin/bash

#Author: Lydia Shumskaya
#Script was written using the GNU Bash Reference Manual as reference: https://www.gnu.org/software/bash/manual/bash.pdf
#Project: Predicted number of MHCII-binding gut microbiome peptides in AML patients decrease after allo-HCT

#Description:
#Script that extracts and renames mg.KEGG.counts.tsv file from IMP3 output directory

#IMP3 output directory is the input
echo "Enter the output directory:"
read output_directory

#Extract accession number from IMP3 output directory name
accession_number=$(echo "$output_directory" | grep -o 'SRR[0-9]\+')

#Define path to mg.KEGG.counts.tsv in IMP3 output and the annotation directory
input_annotation="$output_directory/Analysis/annotation/mg.KEGG.counts.tsv"
annotation_directory="/scratch/14212781/SRA/annotation"

#Make the annotation directory if it is not on the node yet
mkdir -p "$annotation_directory"

#Define path to mg.KEGG.counts.tsv file in annotation directory
output_annotation="$annotation_directory/${accession_number}_mg.KEGG.counts.tsv"

#Rename and move the mg.KEGG.counts.tsv file
if [ -f "$input_annotation" ]; then
    cp "$input_annotation" "$output_annotation"
    echo "The mg.KEGG.counts.tsv file is renamed and moved to $output_fasta"
else
    echo "The mg.KEGG.counts.tsv file is not present in the IMP3 output"
fi
