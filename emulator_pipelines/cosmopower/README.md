## Training and testing scripts for cosmopower produced boosts 
 
# data

The folder contains the indexed boost{I}.npy files with the boost values and their associated cosmological and beyond-LCDM parameters. It also contains a **kvals.txt** file giving the k-modes at which the boost is calculated. The default (see data_pipelines/pipe_fr_parallel) is 300 bins sampled logarithmically between 0.01 h/Mpc and 3 h/Mpc. 


# plots

Folder for storing plots. 

# training_boost.py 

Python script that trains a CosmoPower emulator on indexed boost{i}.npy files in the data/ directory. It also tests the emulator on a test set identified by the user and produces an accuracy plot. Edit the file according to whether you want to train or test the emulator. 

# cp_boosts_train.sbatch

Example job script for training on a cluster that uses SLURM. 

