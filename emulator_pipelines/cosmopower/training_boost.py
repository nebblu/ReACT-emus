import tensorflow as tf
import numpy as np
import matplotlib.pyplot as plt
import os
import cosmopower as cp
from cosmopower import cosmopower_NN
import time

# checking that we are using a GPU
device = 'gpu:0' if tf.test.is_gpu_available() else 'cpu'
print('using', device, 'device \n')
# setting the seed for reproducibility - comment this when training your own model!
#np.random.seed(1)
#tf.random.set_seed(2)


####################################
########TRAINING SET################
####################################

# Initialize an empty list to store the individual arrays
arrays = []

# Loop through the indices from 1 to 6
for i in range(1, 5):  # This will loop from 1 to 6 (200k)
    filename = f"data/my_fr_boosts/boosts{i}.npy"
    # Load the .npy file and append to the list
    arrays.append(np.load(filename, allow_pickle=True))

# Concatenate the individual arrays along the first axis
training_data1 = np.vstack(arrays)
training_parameters = {'Omega_m' : training_data1[:,1],
                       'Omega_b' : training_data1[:,2],
                       'Omega_nu' : training_data1[:,3],
                       'H0' : training_data1[:,4],
                       'ns' : training_data1[:,5],
                       'As' : training_data1[:,6],
                       'fR0' : training_data1[:,7],
                       'z' : training_data1[:,8],
                      }


training_boosts= np.log10(training_data1[:,9:309])

print("Omega_m range:",np.amin(training_data1[:,1]),np.amax(training_data1[:,1]))
print("Omega_b range:",np.amin(training_data1[:,2]),np.amax(training_data1[:,2]))
print("Omega_nu range:",np.amin(training_data1[:,3]),np.amax(training_data1[:,3]))
print("H0 range:",np.amin(training_data1[:,4]),np.amax(training_data1[:,4]))
print("n_s range:",np.amin(training_data1[:,5]),np.amax(training_data1[:,5]))
print("A_s range:",np.amin(training_data1[:,6]),np.amax(training_data1[:,6]))
print("fR0 range:",np.amin(training_data1[:,7]),np.amax(training_data1[:,7]))
print("z range:",np.amin(training_data1[:,8]),np.amax(training_data1[:,8]))

print("Size of training data:", len(training_boosts))


####################################
########TESTING SET################
####################################

test_data = np.load('data/my_fr_boosts/boosts8.npy')
test_boosts= test_data[:,9:309]

# Create dictionary for params and their values
test_parameters = {'Omega_m' : test_data[:,1],
                       'Omega_b' : test_data[:,2],
                       'Omega_nu' :  test_data[:,3],
                       'H0' : test_data[:,4],
                       'ns' : test_data[:,5],
                       'As' : test_data[:,6],
                       'fR0' : test_data[:,7],
                       'z' : test_data[:,8],
                      }


####################################
########INSTANIATION################
####################################
model_params ={"Omega_m","Omega_b","Omega_nu","H0","ns","As","fR0","z"}
kvals = np.loadtxt('data/kvals.txt')

cp_nn = cosmopower_NN(parameters=model_params,
                      modes=kvals,
                      n_hidden = [512, 512, 512, 512], # 4 hidden layers, each with 512 nodes
                      verbose=True, # useful to understand the different steps in initialisation and training
                      )


####################################
########TRAINING################
####################################
'''
with tf.device(device):
    # train
    cp_nn.train(training_parameters=training_parameters,
                training_features=training_boosts,
                filename_saved_model='react_boost_spph_nn_wide_100k_mt',
                # cooling schedule
                validation_split=0.1, #percentage of samples from the training set that will be used for validation
                learning_rates=[1e-2, 1e-3, 1e-4],
                batch_sizes=[1000, 1000, 1000],
                gradient_accumulation_steps = [1, 1, 1],
                # early stopping set up
                patience_values = [100,100,100],
                max_epochs = [1000,1000,1000],
                )


'''
####################################
########TESTING################
####################################

cp_nn = cosmopower_NN(restore=True,
                      restore_filename='react_boost_spph_nn_wide_100k_mt',
                      )


start = time.time()
predicted_testing_boost = cp_nn.predictions_np(test_parameters)
end = time.time()
print(end-start)


diff = np.abs((predicted_testing_boost - test_boosts)/test_boosts)
percentiles = np.zeros((4, diff.shape[1]))
percentiles[0] = np.percentile(diff, 68, axis = 0)
percentiles[1] = np.percentile(diff, 95, axis = 0)
percentiles[2] = np.percentile(diff, 99, axis = 0)
percentiles[3] = np.percentile(diff, 99.9, axis = 0)
np.savetxt('BoostSalmon_new.txt', np.c_[kvals, percentiles[0], percentiles[1], percentiles[2]])
'''
'''
from matplotlib import rc
plt.figure(figsize=(12, 9))
plt.fill_between(kvals, 0, percentiles[2,:], color = 'salmon', label = '99%', alpha=0.8)
plt.fill_between(kvals, 0, percentiles[1,:], color = 'red', label = '95%', alpha = 0.7)
plt.fill_between(kvals, 0, percentiles[0,:], color = 'darkred', label = '68%', alpha = 1)
#plt.ylim(0, 0.2)
plt.legend(frameon=False, fontsize=30, loc='upper left')
plt.ylabel(r'$\frac{|B_\mathrm{emu} - B_\mathrm{test}|} {B_\mathrm{test}}$', fontsize=50)
plt.xlabel(r'$k$',  fontsize=50)
plt.xscale('log')
ax = plt.gca()
#ax.xaxis.set_major_locator(plt.MaxNLocator(10))
#ax.yaxis.set_major_locator(plt.MaxNLocator(5))
plt.setp(ax.get_xticklabels(), fontsize=25)
plt.setp(ax.get_yticklabels(), fontsize=25)
plt.tight_layout()
plt.savefig('plots/accuracy_react_boost_spph_nn_wide_100k_mt.png')
