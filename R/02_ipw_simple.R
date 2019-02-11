# Function to Implement IPTW Estimator with Simple Logistic Model for Propensity
# score weights. Allow for extension to stabilized or truncated weights
#
#
#
library(tidyverse)
raw <- file.path("../data/raw/TestDatasets_lowD/")
intermediate <- file.path("../data/intermediate")
source("utility_funs.R")


simple_ipw <- function(dataframe, stabilized = F, truncated = F){
  family = learn_outcome_family(dataframe)
  
  #Update later - this is simple 
  prop_df = dataframe[ , -1]
  fit_prop <- glm("A ~ .", family = family, data = prop_df)
  
  #Get Predicted Probability of Txt for Each Subject
  probA = predict(fit_prop, data = prop_df, type = "response")
  
  #Get Weight for Each Subject
  weights = dataframe$A*(1/probA)
  
  #Now Estimate Weighted Average Difference
  Ey1 = dataframe$Y*(dataframe$A==1)*weights
  Ey0 = dataframe$Y*(dataframe$A==0)*weights
  
  ATE = mean(Ey1) - mean(Ey0)
  return(ATE)
}

load(file = file.path(intermediate, "loaded_test_data.Rda"))
estimated_ATEs <- lapply(df_list_data, FUN = simple_ipw)

#Compare to Truth
diff = unlist(estimated_ATEs) - unlist(true_ATEs)
diff