# Function to Implement IPTW Estimator with Simple Logistic Model for Propensity
# score weights. Allow for extension to stabilized or truncated weights
#
#
#
library(tidyverse)
raw <- file.path("../data/raw/TestDatasets_lowD/")
intermediate <- file.path("../data/intermediate")
source("R/utility_funs.R")

simple_ipw <- function(dataframe, stabilized = NULL, truncated = NULL,
                       trunc_lower = 0.05, trunc_upper = 0.95){
  family = learn_outcome_family(dataframe)
  
  #Update later - this is simple 
  prop_df = dataframe[ , -1]
  fit_prop <- glm("A ~ .", family = family, data = prop_df)
  
  #Get Predicted Probability of Txt for Each Subject
  probA = predict(fit_prop, data = prop_df, type = "response")
  
  #Get Weight for Each Subject

  
  #Truncation vs Stabilization
  if(is.null(truncated) & is.null(stabilized)){
    weights = (dataframe$A==1)*(1/probA) +
      (dataframe$A==0)*(1/(1-probA))
  } else if (is.null(truncated) & !is.null(stabilized)){
    #MHT Weights
    unstab_weights = (dataframe$A==1)*(1/probA) +
      (dataframe$A==0)*(1/(1-probA))
    denom_A1 = ((dataframe$A==1)*(mean(dataframe$A)))/(unstab_weights)
    denom_A0 = ((dataframe$A==0)*(1-mean(dataframe$A)))/(unstab_weights)
    ### Fill this in
    ###
    ###
  } else if (!is.null(truncated) & is.null(stabilized)){
    #Truncated Weights at 5th and 95th quartiles
    untruncated_weights = (dataframe$A==1)*(1/probA) +
      (dataframe$A==0)*(1/(1-probA))
    weights = bound_wt(untruncated_weights, lower_bound = trunc_lower,
                       upper_bound = trunc_upper)
  }
  
  #Now Estimate Weighted Average Difference
  Ey1 = dataframe$Y*(dataframe$A==1)*weights
  Ey0 = dataframe$Y*(dataframe$A==0)*weights
  
  ATE = mean(Ey1) - mean(Ey0)
  return(ATE)
}

load(file = file.path(intermediate, "loaded_test_data.Rda"))
estimated_ATEs <- lapply(df_list_data, FUN = simple_ipw)
#Compare to Truth
compare_to_truth(true_ATEs, estimated_ATEs)
