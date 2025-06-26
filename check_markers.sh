#!/bin/bash
#Author: Lydia Shumskaya
#Script was written using the GNU Bash Reference Manual as reference: https://www.gnu.org/software/bash/manual/bash.pdf
#Script was written using the BLAST Command Line Applications User Manual as reference:
#https://www.ncbi.nlm.nih.gov/books/NBK279690/ 
#Project: Predicted number of MHCII-binding gut microbiome peptides in AML patients decrease after allo-HCT

#Description:
#Script that performs a BLASTp on the predicted protein sequences to find human AML protein markers

#make output directories
mkdir -p database blastp_results

#make for loop for each patient
for faa in /home/14212781/personal/fasta/post_prokka/*.faa; do
    base=$(basename "$faa" .faa)
    #Make BLAST database
    makeblastdb -in "$faa" -dbtype prot -out "database/$base" > /dev/null
    #BLASTp on human AML proteins against predicted proteins 
    blastp -query /home/14212781/personal/fasta/all_markers.faa -db "database/$base" -out "blastp_results/$base.out" -outfmt 6
done


