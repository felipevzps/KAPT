#!/bin/bash

#$ -q all.q
#$ -V
#$ -cwd
#$ -pe smp 1
#$ -t 1

module load miniconda3
conda activate conda-cache/busco-379626b8a96e73f18d9ee54550a9f47b

database_path="/Storage/data2/felipe.peres/KAPT/busco_database/"


# downloading rhodophyta_odb12 database
/usr/bin/time -v busco --datasets_version odb12 --download rhodophyta --download_path $database_path
