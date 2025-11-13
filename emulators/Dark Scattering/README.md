This CosmoPower emulator was trained on 1,200,000 boost predictions: 

$B(k,z) = \frac{\mathcal{R}(k,z) \times P_{\rm HMCode2020}^{\rm pseudo}(k,z)}{P_{\rm HMCode2020}^{\rm \Lambda CDM}(k,z)}$ . 

The priors are as follows: 

- $\Omega_m \in [0.22,0.37]$,
- $\Omega_b \in [0.03,0.08]$,
- $H_0 \in [63,84]$,
- $n_s \in [0.8,1.1]$,
- $10^{9} A_s \in [1.7,2.5]$,
- $\Omega_\nu \in [0,0.00317]$,
- $w_0 \in [-1.3,-0.5]$,
- $w_a \in [-2.0,0.5]$,
- $\xi \in [0, 150]$,


The emulator produces predictions in the range $k\in[0.01,5]~h/{\rm Mpc}$ and for $z\in[0,2.5]$. 


Another emulator for the nonlinear power spectrum based on ReACT for the [Dark Scattering](https://arxiv.org/abs/1412.1080) model of momentum exchange between dark matter and dark energy can be found at [this repository](https://github.com/karimpsi22/DS-emulators.git).

The associated research paper: https://arxiv.org/abs/2402.18562 
