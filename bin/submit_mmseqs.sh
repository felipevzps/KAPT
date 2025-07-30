#!/bin/bash

#$ -q all.q
#$ -V
#$ -cwd
#$ -pe smp 20
#$ -t 1

concatened_proteins_fasta="../results/all_proteins.fasta"
concatened_proteins_db="../results/all_proteins.db"
clustered_proteins_db="../results/clustered_proteins.db"
representative_proteins_db="../results/representative_proteins.db"
representative_proteins_fasta="../results/representative_proteins.fasta"
directory_for_temporary_files="../results/tmp"

module load miniconda3
conda activate mmseqs2

# create temporary directory
mkdir -p ../results/tmp

# convert fasta database into the MMSeqs2 database format
mmseqs createdb ${concatened_proteins_fasta} ${concatened_proteins_db}

# generate a clustering of the database 
mmseqs cluster ${concatened_proteins_db} ${clustered_proteins_db} ${directory_for_temporary_files} --min-seq-id 0.9 --cov-mode 2 --cluster-mode 2 -c 0.8 --threads $NSLOTS

# extract representative sequences from the clustering
mmseqs createsubdb ${clustered_proteins_db} ${concatened_proteins_db} ${representative_proteins_db}

# convert representative proteins database to fasta 
mmseqs convert2fasta ${representative_proteins_db} ${representative_proteins_fasta}

# remove intermediary files
rm -rf ${directory_for_temporary_files} ${concatened_proteins_db} ${clustered_proteins_db} ${representative_proteins_db} 
