#!/bin/bash

for i in {1..10}

	do

	#run blasr searching the pacbio reads against the reference (the reference changes in each round of assembly)
	blasr /media/Scratch/Donovan/MitoGenome/AllPacBioCombined_2Mreads.fastq /media/Scratch/Donovan/MitoGenome/Mito_Iterator_genes_only/seed$(($i-1)).fasta -nproc 60 > /media/Scratch/Donovan/MitoGenome/Mito_Iterator_genes_only/seed$i.blasr.out

	#filter recovered read hits by the lenght of the match to the genome (here, at least 500bp hit length)
	awk '{a=$8-$7;print $0,a;}' /media/Scratch/Donovan/MitoGenome/Mito_Iterator_genes_only/seed$i.blasr.out | sort -n -r -k14,14 | awk '$14>500' | sort -uk1,1 > /media/Scratch/Donovan/MitoGenome/Mito_Iterator_genes_only/seed$i.blasr.sort.out

	#pull out names of reads that hit the genome with min hit length
	cut -d ' ' -f1,1 /media/Scratch/Donovan/MitoGenome/Mito_Iterator_genes_only/seed$i.blasr.sort.out > /media/Scratch/Donovan/MitoGenome/Mito_Iterator_genes_only/seed$i.blasr.sort.list.out.fixed

	#search the earlier hit list versus the newest hit list to find what is unique in the second list
	grep -F -x -v -f /media/Scratch/Donovan/MitoGenome/Mito_Iterator_genes_only/seed$(($i-1)).blasr.sort.list.out.fixed /media/Scratch/Donovan/MitoGenome/Mito_Iterator_genes_only/seed$i.blasr.sort.list.out.fixed > /media/Scratch/Donovan/MitoGenome/Mito_Iterator_genes_only/newreads$i

	#pull back the fastq for each new hit to the genome
	seqtk subseq /media/Scratch/Donovan/MitoGenome/AllPacBioCombined_2Mreads.fastq /media/Scratch/Donovan/MitoGenome/Mito_Iterator_genes_only/newreads$i > /media/Scratch/Donovan/MitoGenome/Mito_Iterator_genes_only/seed$i.blasr.sort.list.out.fixednew.fastq

	#fix the format of the fastq file to build the genome from – fixes multiline fastq to four line fastq.
	seqtk seq -l0 /media/Scratch/Donovan/MitoGenome/Mito_Iterator_genes_only/seed$i.blasr.sort.list.out.fixednew.fastq > /media/Scratch/Donovan/MitoGenome/Mito_Iterator_genes_only/round$i.fastq
	rm /media/Scratch/Donovan/MitoGenome/Mito_Iterator_genes_only/seed$i.blasr.sort.list.out.fixednew.fastq

	#add the reads from the previous round to the new file newreads.fastq
	cat /media/Scratch/Donovan/MitoGenome/Mito_Iterator_genes_only/round$(($i-1)).fastq >> round$i.fastq

	#run Canu to de novo assemble all reads
	/Programs/canu/Linux-amd64/bin/canu -p rd$i -d /media/Scratch/Donovan/MitoGenome/Mito_Iterator_genes_only/Rd$i genomeSize=2000k  -pacbio-raw /media/Scratch/Donovan/MitoGenome/Mito_Iterator_genes_only/round$i.fastq

	#put the new reference genome in the right place with the correct name to run the next round of assemlby.  For example round1 genome will now server to initiate the round2 assembly.
	cp /media/Scratch/Donovan/MitoGenome/Mito_Iterator_genes_only/Rd$i/rd$i.contigs.fasta /media/Scratch/Donovan/MitoGenome/Mito_Iterator_genes_only/seed$i.fasta


	done
