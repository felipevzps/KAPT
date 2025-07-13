#!/bin/bash

#$ -q all.q
#$ -V
#$ -cwd
#$ -pe smp 1
#$ -t 1

# use busco available in the cluster
module load BUSCO/5.7.0

database_path="/Storage/data2/felipe.peres/KAPT/busco_database/"

# downloading rhodophyta_odb12 database
/usr/bin/time -v busco --datasets_version odb12 --download rhodophyta_odb12 --download_path $database_path
