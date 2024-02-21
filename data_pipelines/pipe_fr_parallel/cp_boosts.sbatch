#!/bin/bash

#SBATCH --job-name=produce_react_spectra
##SBATCH --constraint=4TBdatadisk
#SBATCH --ntasks=245
#SBATCH --time=2:00:00
#SBATCH --cpus-per-task=1
##SBATCH --mem-per-cpu=1G
#SBATCH --output="err_out/output-bacon_data.log"
#SBATCH --error="err_out/error-bacon_data.log"


module load anaconda

. /usr/local/anaconda/3.9/etc/profile.d/conda.sh

conda activate react

##Modules
module load gcc/12.1.0


## ReACT paths
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/bbose/sundials/instdir/lib:/home/bbose/ACTio-ReACTio/reactions/lib:${LD_LIBRARY_PATH}


srun="srun --exclusive -N1 -n1"
parallel="parallel --delay 0.2 -j ${SLURM_NTASKS}"

echo "Slurm tasks: ${SLURM_NTASKS}"

cd pipe_fr_parallel

## We iterate over first index which is the process number (1 to ntasks)
## Second index gives the total number of processes = ntasks
## Third index is the total number of cosmologies you want to run
## Fourth index is the starting cosmology
## NOTE: 3rd+4th index should not exceed total number of cosmologies in data/cosmo.txt, i.e. the total cosmologies in the param file

total_cosmos=400000
start_cosmo=1

$parallel "$srun ./run_cp_fr_camb.sh {1} ${SLURM_NTASKS} ${total_cosmos} ${start_cosmo}" ::: $(seq 1 ${SLURM_NTASKS})
