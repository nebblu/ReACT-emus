#!/bin/bash

#SBATCH --job-name=boosttrain
#SBATCH --constraint=4TBdatadisk
#SBATCH --ntasks=1
#SBATCH --time=10:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=8G


. /usr/local/anaconda/3.9/etc/profile.d/conda.sh

conda activate cp_env

# If bash is your shell
export OMP_NUM_THREADS=$SLURM_JOB_CPUS_PER_NODE

python3 training_boost.py
