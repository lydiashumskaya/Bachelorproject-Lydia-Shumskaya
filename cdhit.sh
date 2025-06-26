#!/bin/bash

#Author: Lydia Shumskaya
#Script was written using the GNU Bash Reference Manual as reference: https://www.gnu.org/software/bash/manual/bash.pdf
#Script was written using the CD-HIT User's Guide as reference: https://www.bioinformatics.org/cd-hit/cd-hit-user-guide.pdf
#Project: Predicted number of MHCII-binding gut microbiome peptides in AML patients decrease after allo-HCT

#Description:
#Script that runs CD-HIT with a minimum sequence identity threshold of 90%,
#requiring at least 10% coverage of the longer sequence and full coverage of the shorter sequence

INPUT="$1"
BASENAME=$(basename "$INPUT" .faa)
OUTPUT="${BASENAME}_cdhit.faa"

/zfs/omics/software/bin/cd-hit \
  -i "$INPUT" \
  -o "$OUTPUT" \
  -c 0.9 \
  -G 0 \
  -aL 0.1 \
  -aS 1 \
  -d 0 \
  -T 8 \
  -M 16000 \
  -g 0 \
  -sc 1 \
  -bak 1

