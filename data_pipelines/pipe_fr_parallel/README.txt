## Pipeline for producing the ReACT-HMCode2020 boost data for Hu-Sawicki f(R) 

# Files in top level 
 
1. `create_params.py': Python script used to generate a cosmo.txt file. This file contains the parameter sets for the individual boots examples. These are constructed using a latin hypercube over the prior ranges specified in this file. 

2. `parameters.dat': Some general parameters needed by the pipeline: k-ranges, number of bins, paths to MGCAMB, ReACT and HMcode2020. 


3. `run_cp_fr_camb.sh': The data production pipeline for the f(R) boost. This can be run as a test as 

> ./run_cp_fr_camb.sh 1 1 a b 

where a is the total number of boosts you want to produce and b is the starting index, where the index is referenced from the cosmo.txt file in the data/ folder. This .txt file needs to be produced before running the pipeline. 


4. `txt_to_npy.ipynb': Python notebook to convert the pipeline's boost{I}.txt outputs to .npy files used by CosmoPower. 

5. `HMcode_wob.f90': This is an edited HMcode2020 source code that allows a scale factor specification to the command line call to HMcode. Place this in your HMCode2020 src/ directory as HMcode.f90 before running run_cp_fr_camb.sh. 

6. `cp_boosts.sbatch': An example job script for running run_cp_fr_camb.sh on a cluster. 

# templates

Contains the various templates needed by run_cp_fr_camb.sh. See https://arxiv.org/abs/2105.12114 and https://arxiv.org/abs/2305.06350 for details on the various components of the boost: 
 
1. `mgcamb.ini_template':  An MGCAMB parameter file which is edited by run_cp_fr_camb.sh to include the desired cosmological parameters and fr0. This is needed for a MGCAMB run to produce the f(R) linear power spectrum with massive neutrinos.

2. `mgcamb_lcdm.ini_template': An MGCAMB parameter file which is edited by run_cp_fr_camb.sh to include the desired cosmological parameters. This is needed for a CAMB run to produce the LCDM linear power spectrum with massive neutrinos. 

3. `mgcamb_lcdm_nonu.ini_template': An MGCAMB parameter file which is edited by run_cp_fr_camb.sh to include the desired cosmological parameters. This is needed for a CAMB run to produce the LCDM linear power spectrum without massive neutrinos.

4. `ml_test.cpp_template': A ReACT file used to compute the halo model reaction. The template has modg = True and so includes 1-loop effects. To speed up the pipeline you can turn this to False without sacrificing too much accuracy (see https://arxiv.org/abs/2210.01094). 

5. `combine.cpp_template': A c++ file that combines all the ready components to produce the boost:  R x Pseudo/ PLCDM . It saves this boost, along with the associated cosmological and fr0 parameters  into a row in a boost{I}.txt file in the data folder, where i is an index. 


# data

Folder to store the completed boost.txt files. 


