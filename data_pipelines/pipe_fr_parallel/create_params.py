#!/usr/bin/env/python

# Author: A. Spurio Mancini


import numpy as np
import pyDOE as pyDOE

# number of parameters and samples

n_params           = 8
n_samples          = 400000

# parameter ranges

Omega_m            =   np.linspace(0.2899,     0.3392,       n_samples)
Omega_b            =   np.linspace(0.04044,    0.05686,      n_samples)
Omega_nu           =   np.linspace(0.,         0.00317,      n_samples)
H0                 =   np.linspace(63.75,      73.1,         n_samples)
ns                 =   np.linspace(0.9432,     0.9862,       n_samples)
As                 =   np.linspace(1.9511e-9,  2.2669e-9,    n_samples)
fr0                =   np.linspace(10.**(-10), 10.**(-5.46), n_samples)
z                  =   np.linspace(0.,         2.5,          n_samples)

# LHS grid

AllParams          = np.vstack([Omega_m, Omega_b, Omega_nu, H0, ns, As, fr0, z])
lhd                = pyDOE.lhs(n_params, samples=n_samples, criterion=None)
idx                = (lhd * n_samples).astype(int)

AllCombinations = np.zeros((n_samples, n_params))
for i in range(n_params):
    AllCombinations[:, i] = AllParams[i][idx[:, i]]

print(AllCombinations)

AllCombinations = np.hstack([np.arange(n_samples).reshape((-1,1)), AllCombinations])

# saving

np.savetxt('cosmo.txt', AllCombinations)
