#!/bin/bash
#test
#this script assumes the genome files are fasta files with names as follows anyname.fa
#the awk step should convert any multiline fasta genomes into single line fasta (it will have no effect on single line fasta) and save the copy with the suffix .fa.fa
#the next four steps count the number of bases in each mononucleotide class at least 8bp long and sends the output to a text file named after the genome
#the RESULT variable summs up all the nucleotides in total and sends them to a file called "Mononucleotide.out"  
#the Mononucleotide.out file will have as many lines as genomes.  Each line will include a genome name followed by the number of bases occupied by these mononucleotide repeats.

for i in insert_a_space_separated_liste_genome_file_prefixes_here
do
awk '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);}  END {printf("\n");}' < $i.fa > $i.fa.fa
grep -i -o 'TTTTTTTTT*' $i.fa.fa | wc -c >> $i.txt
grep -i -o 'AAAAAAAAA*' $i.fa.fa | wc -c >> $i.txt
grep -i -o 'CCCCCCCCC*' $i.fa.fa | wc -c >> $i.txt
grep -i -o 'GGGGGGGGG*' $i.fa.fa | wc -c >> $i.txt
RESULT=$(awk '{ sum += $1 } END { print sum }' $i.txt)
echo $i "$RESULT" >> Mononucleotides.out
done


