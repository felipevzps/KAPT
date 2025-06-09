#!/bin/bash

#$ -q all.q
#$ -V
#$ -cwd
#$ -pe smp 1
#$ -t 1

samples=`ls -1 samples_test/*.csv | head -n $SGE_TASK_ID | tail -n1`
bioproject=`basename ${samples/.csv}`

module load nextflow

/usr/bin/time -v nextflow run workflows/KAPT.nf -c config/nextflow.config -resume -profile sge --samples_csv $samples --output_dir "../results/${bioproject}" --report_dir "report/${bioproject}"
