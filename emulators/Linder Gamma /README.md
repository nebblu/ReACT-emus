## Time-independent Growth Index Parametrisation with Screening

This CosmoPower emulator was trained on 85653 and tested on 13928 boost predictions: 

$B(k,z) = \frac{\mathcal{R}(k,z) \times P_{\rm HMCode2020}^{\rm pseudo}(k,z)}{P_{\rm HMCode2020}^{\rm \Lambda CDM}(k,z)}$ . 

The priors are as follows: 

- $\Omega_{\rm m} \in [0.2899,     0.3392]$,
- $\Omega_{\rm b} \in [0.04044,    0.05686]$,
- $h \in [0.629,      0.731]$,
- $n_s \in [0.9432,0.9862]$,
- $10^{9} A_s \in [1.5,2.7]$,
- $\Omega_\nu \in [0., 0.00317]$,
- $\gamma \in [0., 1.]$,
- $q_1 \in [-5., 5.]$,
- $z\in[0,2.4]$.

The emulator generates predictions for 350 wave numbers $k$, defined as:

```python
import numpy as np 

kminp = 0.001
kmaxp = 5.
Nkp = 350
k_modes = [ kminp * np.exp(i*np.log(kmaxp/kminp)/(Nkp-1)) for i in range(Nkp)]
```

We recommend to trust the predictions only for $k \geq 0.01$ and impose physically motivated priors on the screening scales in the range of $q_1 \in [0., 1.]$. The unscreened limit corresponds to $q_1 \geq 2$.


The model was presented in https://arxiv.org/abs/2210.01094 .


## Time-dependent Growth Index Parametrisation with Screening

With the same screening model and the time-dependent growth index parametrisation from https://arxiv.org/abs/2304.07281 .

Same conditions and priors as above with the following differences:

- trained on 87622 and tested on 9953 boost predictions,
- $\gamma_0 \in [0., 1.]$,
- $\gamma_1 \in [-0.7, 0.7]$,
- $q_1       \in [-2., 3.]$,
- $k_{\rm min} = 0.01$,
- $k_{\rm max} = 5.0$,
- $N_{\rm kp} = 300$.
