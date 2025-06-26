#!/bin/bash

#Author: Lydia Shumskaya
#Script was written using the GNU Bash Reference Manual as reference: https://www.gnu.org/software/bash/manual/bash.pdf
#Project: Predicted number of MHCII-binding gut microbiome peptides in AML patients decrease after allo-HCT

#Description:
#Script that extracts and renames prokka.faa file from IMP3 output directory

#IMP3 output directory is the input
echo "Enter the output directory:"
read output_directory

#Extract accession number from IMP3 output directory name
accession_number=$(echo "$output_directory" | grep -o 'SRR[0-9]\+')

#Define path to prokka.faa in IMP3 output and the fasta directory
input_fasta="$output_directory/Analysis/annotation/prokka.faa"
fasta_directory="/scratch/14212781/SRA/fasta"

#Make the fasta directory if it is not on the node yet
mkdir -p "$fasta_directory"

#Define path to prokka.faa file in fasta directory
output_fasta="$fasta_directory/${accession_number}_prokka.faa"

#Rename and move the prokka.faa file  
if [ -f "$input_fasta" ]; then
    cp "$input_fasta" "$output_fasta"
    echo "The prokka.faa file is renamed and moved to $output_fasta"
else
    echo "The prokka.faa file is not present in the IMP3 output"
fi

