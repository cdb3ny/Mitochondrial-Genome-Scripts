# Mitochondrial-Genome-Scripts
# The code associated with this repository was used to assemble the primary genome discussed in Kovar et al., in review with Genome Biology and Evolution. 

# There are two shell scripts included herein

#MONONUCLEOTIDE COUNTING
# The first tools is a simple script to count mononucleotide repeats in a genome (a fasta file).  A commented explanation is included with the script.

#ITERATIVE GENOME ASSEMBLER
# the second tool is a script of a pipeline for the iterative assembly of mitochondrial (or similar genomes) from long read (PacBio data)

#Requirements: The following code employed a Linux Ubuntu Server run from the command line.

#You must have the following non-standard software installed and included in your path to run the script:

#CANU (Koren S, Walenz BP, Berlin K, Miller JR, Phillippy AM. Canu: scalable and accurate long-read assembly via adaptive k-mer weighting and repeat separation. Genome Research 2017; doi: https://doi.org/10.1101/gr.215087.116)

#Blasr (https://github.com/PacificBiosciences/blasr)

#Seqtk (https://github.com/lh3/seqtk)
You must have the follow files under these names in a single input/output folder that will be used for the run.
“seed0.fasta” – this is the initial reference genome(s) needed to start the first round of assembly. If you use multiple starting references they should be in this single file as separate fasta sequences.
“round0.fastq” – this file must exist but be completely empty.
“seed0.blasr.sort.list.out.fixed” – this file must exist but be completely empty

#The forloop in this bash script includes 10 cycles of assembly. Each round identifies the reads matching the starting genome and assembles on the available data. See the full manuscript for more information.

#If you want to use this script, you will need to substitute all of your own appropriate paths to folders and starting files.

