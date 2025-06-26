#!/bin/bash
#Author: Lydia Shumskaya
#Script was written using the GNU Bash Reference Manual as reference: https://www.gnu.org/software/bash/manual/bash.pdf
#Project: Predicted number of MHCII-binding gut microbiome peptides in AML patients decrease after allo-HCT

#Description: Script that extracts and renames mg.CDS_counts.tsv file from IMP3 output directory

#IMP3 output directory is the input
echo "Enter the output directory:"
read output_directory

#Extract accession number from IMP3 output directory name
accession_number=$(echo "$output_directory" | grep -o 'SRR[0-9]\+')

#Define path to mg.CDS_counts.tsv in IMP3 output and the counts directory
input_counts="$output_directory/Analysis/annotation/mg.CDS_counts.tsv"
counts_directory="/home/14212781/personal/GFF_counts/counts"

#Make the counts directory
mkdir -p "counts_directory"

#Define path to counts file in counts directory
output_counts="$counts_directory/${accession_number}_mg.CDS_counts.tsv"

#Rename and move the counts file
if [ -f "$input_counts" ]; then
    cp "$input_counts" "$output_counts"
    echo "The mg.CDS_counts.tsv file is renamed and moved to $output_counts"
else
    echo "The mg.CDS_counts.tsv file is not present in the IMP3 output"
fi


