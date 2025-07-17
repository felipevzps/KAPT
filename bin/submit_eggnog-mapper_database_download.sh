#!/bin/bash

#$ -q all.q
#$ -V
#$ -cwd
#$ -pe smp 1
#$ -t 1

module load eggnog-mapper/2.1.9

eggnog_db_path="/Storage/data2/felipe.peres/KAPT/eggnog_database/"

# tutorial: https://github.com/eggnogdb/eggnog-mapper/wiki/eggNOG-mapper-v2.1.5-to-v2.1.12#user-content-v219

# downloading eggNOG-mapper databases
/usr/bin/time -v download_eggnog_data.py --data_dir $eggnog_db_path -y
