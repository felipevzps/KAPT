#!/bin/bash

#$ -q all.q
#$ -V
#$ -cwd
#$ -pe smp 1
#$ -t 1

# use busco available in the cluster
module load BUSCO/5.7.0

busco_db_path="/Storage/data2/felipe.peres/KAPT/busco_downloads/"

# downloading rhodophyta_odb12 database
/usr/bin/time -v busco --datasets_version odb12 --download rhodophyta_odb12 --download_path $busco_db_path
