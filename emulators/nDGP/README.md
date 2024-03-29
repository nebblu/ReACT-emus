This CosmoPower emulator was trained on 83591 and tested on 13191 boost predictions: 

$B(k,z) = \frac{\mathcal{R}(k,z) \times P_{\rm HMCode2020}^{\rm pseudo}(k,z)}{P_{\rm HMCode2020}^{\rm \Lambda CDM}(k,z)}$ . 

The priors are as follows: 

- $\Omega_{\rm m} \in [0.2899,     0.3392]$,
- $\Omega_{\rm b} \in [0.04044,    0.05686]$,
- $h \in [0.629,      0.731]$,
- $n_s \in [0.9432,0.9862]$,
- $10^{9} A_s \in [1.5,2.7]$,
- $\Omega_\nu \in [0., 0.00317]$,
- $\log_{10}{\Omega_{rc}} \in [-3., 2.]$,
- $z\in[0,2.4]$.

The emulator generates predictions for \(300\) wave numbers \(k\), defined as:
\[ k = k_{\text{min}} \cdot \exp(i \cdot \frac{\log(k_{\text{max}}/k_{\text{min}})}{N_{\text{kp}}-1}) \text{ for } i \text{ in range}(N_{\text{kp}}) \]
where:
- \(k_{\text{min}} = 0.01\),
- \(k_{\text{max}} = 5.0\),
- \(N_{\text{kp}} = 300\).




