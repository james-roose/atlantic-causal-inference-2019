# atlantic-causal-inference-2019
Project using Data from Atlantic Causal Inference 2019 Data Challenge (https://sites.google.com/view/ACIC2019DataChallenge/home)

A number of simple estimation approaches are implemented for benchmarking, including G-computation estimation using a simple linear model outcome regression, and IPW using simple logistic regression propensity score models (with and without stabilizing or truncating weights). Doubly Robust AIPTW and TMLE methods are implemented.

The focus of this project is the implementation of Cross-Validated TMLE (CV-TMLE) with a well-developed rich Super Learner (i.e. ensemble learning) library. In addition, the GenMatch algorithm is also employed and its performance compared to that of CV-TMLE on the available test data.

Performance is evaluated by considering the bias of the ATE estimate when compared to the true ATE in the "*_cf.csv" files.

The goal is to create a set of potential teaching/reference examples.
