#!/bin/bash
echo "Initializing training data"
echo ""

# Start in home directory
cd "$(dirname "$0")"

echo "$(dirname "$0")"

# Script to produce HMCode_pseudo/HMCode_LCDM x reaction (preset for f(R))

# Read in minimum and maximum scale, and number of bins to logarithmically sample in range
kmin=`awk 'NR==1 {print $3}' parameters.dat`
kmax=`awk 'NR==2 {print $3}' parameters.dat`
NK=`awk 'NR==3 {print $3}' parameters.dat`

# Read in camb, ReACT, HMCode2020 and EuclidEmulator2 directories
cambdir=`awk 'NR==4 {print $3}' parameters.dat`
reactdir=`awk 'NR==5 {print $3}' parameters.dat`
hmcodedir=`awk 'NR==6 {print $3}' parameters.dat`

# Command line arguments
## process number is first argument in terminal command
procno=$1
## total number of processes
noproc=$2
## total number of cosmologies in parameter file
nocos=$3
## starting cosmology (default would be 1)
startcos=$4

## Output file indexing
boostindex=$(($procno))

## Create output file
touch boost$boostindex.dat

#Move file to the cosmopower data directory
mv boost$boostindex.dat data/

# Make a working directory for react output in the react directory
mkdir ${reactdir}/examples/working_cp


# Start the loop over parameter values
#1:process number
#2:number of processes
#3:number of cosmologies

echo "Process number: ${procno}"
echo "Number of cosmologies: ${nocos}"
echo "Number of processes: ${noproc}"


noofiters=$(( $nocos/$noproc ))

echo "Number of cosmologies per process: ${noofiters}"

startp=$(( $procno*$noofiters-$noofiters+$startcos))
endp=$(( $procno*$noofiters + $startcos - 1 ))

echo "From ${startp} to ${endp} "

# We loop over cosmologies specified in the cosmo.txt file
for iteration in $(seq $startp 1 $endp)
#for iteration in $(seq 1 1 1)
do


# PART 1: SETUP

# Create MGCAMB files - f(R)+mnu cosmology, LCDM+mnu cosmology and LCDM cosmology
cp templates/mgcamb.ini_template mgcamb_params_$iteration.ini
cp templates/mgcamb_lcdm.ini_template mgcamb_lcdm_params_$iteration.ini
cp templates/mgcamb_lcdm_nonu.ini_template mgcamb_lcdm_nonu_params_$iteration.ini


echo "Creating training data number: ${iteration}"
echo ""

# Create a cosmology file using  params/create_params.py

# Assumed format of the file:
#Index, Omega_m, Omega_b, Omega_nu, H0, n_s, AS, |f_R0|, redshift
omm=`awk 'NR=='${iteration}' {print $2}' params/cosmo.txt`
omb=`awk 'NR=='${iteration}' {print $3}' params/cosmo.txt`
omnu=`awk 'NR=='${iteration}' {print $4}' params/cosmo.txt`
hubble=`awk 'NR=='${iteration}' {print $5}' params/cosmo.txt`
hnorm=100
smallh=`awk 'NR=='${iteration}' {print $5/'${hnorm}'}' params/cosmo.txt`
ns=`awk 'NR=='${iteration}' {print $6}' params/cosmo.txt`
As=`awk 'NR=='${iteration}' {print $7}' params/cosmo.txt`
param1=`awk 'NR=='${iteration}' {print $8}' params/cosmo.txt`
z1=`awk 'NR=='${iteration}' {print $9}' params/cosmo.txt`


# Additional parameters

#Omega_cdm
#let "omcdm = ${omm} - ${omnu} - ${omb}"
omcdm=`awk 'NR=='${iteration}' {print $2-'${omb}'-'${omnu}'}' params/cosmo.txt`

# Omega_cdm without massive neutrinos (needed for LCDM spectrum)
omcdmnonu=`awk 'NR=='${iteration}' {print $2-'${omb}'}' params/cosmo.txt`

# Omega_Lambda
ol=`awk 'NR=='${iteration}' {print '1'-$2}' params/cosmo.txt`

# Small Ob, Onu, Oc
ombh2=`awk 'NR=='${iteration}' {print $3*'${smallh}'*'${smallh}'}' params/cosmo.txt`
omnuh2=`awk 'NR=='${iteration}' {print $4*'${smallh}'*'${smallh}'}' params/cosmo.txt`
omch2=`awk 'NR=='${iteration}' {print '${omcdm}'*'${smallh}'*'${smallh}'}' params/cosmo.txt`

# Oc+Onu for LCDM spectrum
omch2nonu=`awk 'NR=='${iteration}' {print '${omcdmnonu}'*'${smallh}'*'${smallh}'}' params/cosmo.txt`



# PART 2: Get linear transfers for nu-f(R), nu-LCDM and LCDM cosmologies with MGCAMB

#edit modified camb .ini file with relevant params
sed -i  "s/omch2 =/omch2 = ${omch2}/g" mgcamb_params_$iteration.ini
sed -i  "s/ombh2 =/ombh2 = ${ombh2}/g" mgcamb_params_$iteration.ini
sed -i  "s/omnuh2 =/omnuh2 = ${omnuh2}/g" mgcamb_params_$iteration.ini
sed -i  "s/hubble =/hubble = ${hubble}/g" mgcamb_params_$iteration.ini
sed -i  "s/scalar_amp(1) =/scalar_amp(1) = ${As}/g" mgcamb_params_$iteration.ini
sed -i  "s/scalar_spectral_index(1) =/scalar_spectral_index(1) = ${ns}/g" mgcamb_params_$iteration.ini
sed -i  "s/F_R0 =/F_R0 = ${param1}/g" mgcamb_params_$iteration.ini
sed -i  "s/transfer_redshift(1) =/transfer_redshift(1) = ${z1}/g" mgcamb_params_$iteration.ini


#edit LCDM  camb .ini file with relevant params
sed -i  "s/omch2 =/omch2 = ${omch2}/g" mgcamb_lcdm_params_$iteration.ini
sed -i  "s/ombh2 =/ombh2 = ${ombh2}/g" mgcamb_lcdm_params_$iteration.ini
sed -i  "s/omnuh2 =/omnuh2 = ${omnuh2}/g" mgcamb_lcdm_params_$iteration.ini
sed -i  "s/hubble =/hubble = ${hubble}/g" mgcamb_lcdm_params_$iteration.ini
sed -i  "s/scalar_spectral_index(1) =/scalar_spectral_index(1) = ${ns}/g" mgcamb_lcdm_params_$iteration.ini
sed -i  "s/scalar_amp(1) =/scalar_amp(1) = ${As}/g" mgcamb_lcdm_params_$iteration.ini
sed -i  "s/transfer_redshift(1) =/transfer_redshift(1) = ${z1}/g" mgcamb_lcdm_params_$iteration.ini


#edit LCDM without massive neutrinos (for ratio) camb .ini file with relevant params at z=0
sed -i "s/omch2 =/omch2 = ${omch2nonu}/g" mgcamb_lcdm_nonu_params_$iteration.ini
sed -i "s/ombh2 =/ombh2 = ${ombh2}/g" mgcamb_lcdm_nonu_params_$iteration.ini
sed -i "s/hubble =/hubble = ${hubble}/g" mgcamb_lcdm_nonu_params_$iteration.ini
sed -i "s/scalar_spectral_index(1) =/scalar_spectral_index(1) = ${ns}/g" mgcamb_lcdm_nonu_params_$iteration.ini
sed -i "s/scalar_amp(1) =/scalar_amp(1) = ${As}/g" mgcamb_lcdm_nonu_params_$iteration.ini


#filenames
sed -i  "s/output_root =/output_root = mg_$iteration/g" mgcamb_params_$iteration.ini
sed -i  "s/output_root =/output_root = lcdm_$iteration/g" mgcamb_lcdm_params_$iteration.ini
sed -i  "s/output_root =/output_root = lcdm_nonu_$iteration/g" mgcamb_lcdm_nonu_params_$iteration.ini


# Move the files to the MGCAMB directory for running
mv mgcamb_params_$iteration.ini ${cambdir}
mv mgcamb_lcdm_params_$iteration.ini ${cambdir}
mv mgcamb_lcdm_nonu_params_$iteration.ini ${cambdir}


# Go to the MGCAMB directory
cd ${cambdir}

echo "Running MGCAMB with parameters:"
echo ""
echo "H0='${hubble}'"
echo "ns='${ns}'"
echo "Omega_b='${omb}'"
echo "Omega_m='${omm}'"
echo "Omega_nu='${omnu}'"
echo "Omega_L='${ol}'"
echo "As='${As}'"
echo "|f_R0| ='${param1}'"
echo "Computed at redshift: '${z1}' "
echo "Number of k values ='${NK}'"
echo ""

# Run MGCAMB
./camb mgcamb_params_$iteration.ini # > /dev/null

./camb mgcamb_lcdm_params_$iteration.ini # > /dev/null

./camb mgcamb_lcdm_nonu_params_$iteration.ini # > /dev/null



#Clip the headers from transfer functions and rename them
tail -n +2 mg_${iteration}_transfer.dat > mg_${iteration}_transfer.tmp && mv mg_${iteration}_transfer.tmp test_$iteration\_transfer.dat
tail -n +2 lcdm_$iteration\_transfer.dat > lcdm_${iteration}_transfer.tmp && mv lcdm_${iteration}_transfer.tmp test_$iteration\_transfer_lcdm.dat
tail -n +2 lcdm_nonu_$iteration\_transfer.dat > lcdm_nonu_$iteration\_transfer.tmp && mv lcdm_nonu_$iteration\_transfer.tmp test_$iteration\_transfer_lcdm_nonu.dat

# Move them to the ReACT transfers folder
mv test_$iteration\_transfer.dat ${reactdir}/examples/transfers
mv test_$iteration\_transfer_lcdm.dat ${reactdir}/examples/transfers
mv test_$iteration\_transfer_lcdm_nonu.dat ${reactdir}/examples/transfers


# Clean up
rm mgcamb_params_$iteration.ini
rm mgcamb_lcdm_params_$iteration.ini
rm mgcamb_lcdm_nonu_params_$iteration.ini
rm test_$iteration\_*
rm lcdm_$iteration\_*
rm lcdm_nonu_$iteration\_*
rm mg_$iteration\_*

# PART 3: Get halo model reaction and linear pseudo spectra with ReACT

# Go to the react directory
cd ${reactdir}/examples


# Create the ReACT file to compute the reaction
echo "Editing ml_test_$iteration.cpp ... "
echo ""

cp pipe_cosmopower_parallel/templates/ml_test.cpp_template ml_test_$iteration.cpp

sed -i "s/int iteration =/int iteration = ${iteration};/g" ml_test_$iteration.cpp

sed -i "s/double redshift =/double redshift = ${z1};/g" ml_test_$iteration.cpp

sed -i "s/int Nk =/int Nk = ${NK};/g" ml_test_$iteration.cpp
sed -i "s/double kmax =/double kmax = ${kmax};/g" ml_test_$iteration.cpp
sed -i "s/double kmin =/double kmin = ${kmin};/g" ml_test_$iteration.cpp

sed -i "s/double h =/double h = ${smallh};/g" ml_test_$iteration.cpp
sed -i "s/double n_s =/double n_s = ${ns};/g" ml_test_$iteration.cpp
sed -i "s/double Omega_m =/double Omega_m = ${omm};/g" ml_test_$iteration.cpp
sed -i "s/double Omega_b =/double Omega_b = ${omb};/g" ml_test_$iteration.cpp
sed -i "s/double Omega_nu =/double Omega_nu = ${omnu};/g" ml_test_$iteration.cpp
sed -i "s/double As =/double As = ${As};/g" ml_test_$iteration.cpp
sed -i "s/double p1 =/double p1 = ${param1};/g" ml_test_$iteration.cpp


echo "Running ReACT ... "
echo ""

g++ -I/${reactdir}/include -lgsl -lstdc++ -L/${reactdir}/lib -lcopter ml_test_$iteration.cpp -o test_$iteration

time ./test_$iteration

# Clean up
rm test_$iteration
rm transfers/test_$iteration\_transfer.dat
rm transfers/test_$iteration\_transfer_lcdm.dat
rm transfers/test_$iteration\_transfer_lcdm_nonu.dat
rm ml_test_$iteration.cpp


# PART 4: Get non-linear LCDM and pseudo spectra with HMCODE2020

echo ""

# Move pseudos and lcdm linear spectra to hmcode directory
mv working_cp/pseudo_$iteration.txt ${hmcodedir}
mv working_cp/lcdm_$iteration.txt ${hmcodedir}


# Go to the HMCode2020 directory
cd ${hmcodedir}


# Specific scalefactor for hmcode
a1=$(awk "BEGIN {print 1/($z1 + 1)}")

echo "Running HMCode2020 for redshift ${z1}"
echo ""

# Run HMCode to get pseudos
./bin/HMcode ${omm} ${omb} ${smallh} ${ns} 0.8 -1.0 pseudo_${iteration}.txt 1e8 ${a1} ${NK} ${kmin} ${kmax} hmcode_${iteration}.txt > /dev/null

# clip header
tail -n +2 hmcode_${iteration}.txt > hmcode_$iteration.tmp && mv hmcode_$iteration.tmp hmcode_$iteration.dat


# Move pseudos to the ReACT working directory for combination with the reaction
mv hmcode_$iteration.dat ${reactdir}/examples/working_cp

echo "Running HMCode2020 for redshift ${z1}"
echo ""

# Run HMCode to get LCDM
./bin/HMcode ${omm} ${omb} ${smallh} ${ns} 0.8 -1.0 lcdm_${iteration}.txt 1e8 ${a1} ${NK} ${kmin} ${kmax} hmcode_lcdm_${iteration}.txt > /dev/null

# clip header
tail -n +2 hmcode_lcdm_${iteration}.txt > hmcode_lcdm_$iteration.tmp && mv hmcode_lcdm_$iteration.tmp hmcode_lcdm_$iteration.dat

# Move LCDM spectra  to the ReACT directory
mv hmcode_lcdm_$iteration.dat ${reactdir}/examples/working_cp

# Clean up
echo "Clearing HMcode directory"

rm pseudo_$iteration.txt
rm hmcode_$iteration.txt
rm lcdm_$iteration.txt
rm hmcode_lcdm_$iteration.txt


# PART 5: Combine pseudo with reaction and LCDM non-linear to get Boost

# Back to pipeline directory
cd ${reactdir}/examples


# get combine script from template
cp pipe_cosmopower_parallel/templates/combine.cpp_template combine_$iteration.cpp

echo "Editing combine_$iteration.cpp ... "
echo ""

# Edit combine file
sed -i  "s/int batchno =/int batchno = ${boostindex};/g" combine_$iteration.cpp
sed -i  "s/int iteration =/int iteration = ${iteration};/g" combine_$iteration.cpp
sed -i  "s/double H0 =/double H0 = ${hubble};/g" combine_$iteration.cpp
sed -i  "s/double ns =/double ns = ${ns};/g" combine_$iteration.cpp
sed -i  "s/double Omega_m =/double Omega_m = ${omm};/g" combine_$iteration.cpp
sed -i  "s/double Omega_b =/double Omega_b = ${omb};/g" combine_$iteration.cpp
sed -i  "s/double Omega_nu =/double Omega_nu = ${omnu};/g" combine_$iteration.cpp
sed -i  "s/double As =/double As = ${As};/g" combine_$iteration.cpp
sed -i  "s/double p1 =/double p1 = ${param1};/g" combine_$iteration.cpp
sed -i  "s/double z =/double z = ${z1};/g" combine_$iteration.cpp


echo "Running combine script for P-non-lin ${iteration}"

g++ -I/${reactdir}/include -lgsl -lstdc++ -L/${reactdir}/lib -lcopter combine_$iteration.cpp -o combine_$iteration

time ./combine_$iteration

echo "Cleaning up"

# Clean up
rm combine_$iteration.cpp
rm combine_$iteration

rm working_cp/reaction_$iteration.dat
rm working_cp/hmcode_$iteration.dat
rm working_cp/hmcode_lcdm_$iteration.dat

echo "Done"
echo ""
echo ""
echo ""

# back to CP directory 
cd pipe_cosmopower_parallel 


done
