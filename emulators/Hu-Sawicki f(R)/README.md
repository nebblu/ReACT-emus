This CosmoPower emulator was trained on 100,000 boost predictions: 

> $B(k,z) = \frac{\mathcal{R}(k,z) \times P_{\rm HMCode2020}^{\rm pseudo}(k,z)}{P_{\rm HMCode2020}^{\rm \Lambda CDM}(k,z)}$ . 

The priors are as follows: 

- $\Omega_m \in [0.24,0.35]$,
- $\Omega_b \in [0.04,0.06]$,
- $h \in [0.63,0.75]$,
- $n_s \in [0.9,1.01]$,
- $10^{9} A_s \in [1.7,2.5]$,
- $\Omega_\nu \in [0,0.00317]$,
- $|f_{\rm R0}| \in [10^{-10}, 10^{-4}]$. 

The emulator produces predictions in the range $k\in[0.01,3]~h/{\rm Mpc}$ and for $z\in[0,2]$. 

For an example script on how to use the emulator in a python notebook, see emulator_pipelines/cosmopower/training_boost.py.

This emulator differs slightly from the public emulator presented in https://arxiv.org/abs/2305.06350 in that it computes the boost with respect to an HMcode2020 LCDM spectrum whose $\Omega_{m} = \Omega_{b} + \Omega_{cdm} + \Omega_\nu$, whereas the emulator presented in https://arxiv.org/abs/2305.06350 computes the boost with respect to an HMcode2020 LCDM spectrum whose $\Omega_{m} = \Omega_{b} + \Omega_{cdm}$. The two agree in the $\Omega_\nu = 0$ case. Note that the emulator ranges are also slightly different. 

The emulator of https://arxiv.org/abs/2305.06350 can be found here: https://github.com/cosmopower-organization/reactemu-fr 
