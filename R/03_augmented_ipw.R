#### Augmented IPTW Estimator
#
# Function to Implemented Augmented (Doubly Robust) IPW Estimator
#
#

# Outcome Model: simple OLS regression with interactions

# Propensity Score Model: Logistic Regression

library(tidyverse)
raw <- file.path("../data/raw/TestDatasets_lowD/")
intermediate <- file.path("../data/intermediate")
source("R/utility_funs.R")

augmented_iptw <- function(dataframe){
  O = dataframe
  family = learn_outcome_family(O)
  
  # Fit Propensity Score Model
  
  prop_df = O[ , -1] # Update this code later
  fit_prop <- glm("A ~ .", family = family, data = prop_df)
  
  #Get Predicted Probability of Txt for Each Subject
  probA = predict(fit_prop, data = prop_df, type = "response")
  
  # Fit Outcome Model
  fit <- glm("Y ~ A + .", family = family, data = O)
  # Predicted Outcomes Under Txt and Control
  txt = control = O
  txt$A = 1
  control$A = 0
  fitY1 = predict(fit, newdata = txt, type = "response")
  fitY0 = predict(fit, newdata = control, type = "response")
  
  # Estimate A-IPTW
  Ey1 <- mean( (O$A == 1)/probA - 
                ( ( ( (O$A == 1) - probA)/probA)*fitY1))
    
  Ey0 <- mean( (O$A == 0)/(1-probA) - 
                 ( ( ( (O$A == 0) - (1-probA))/(1-probA))*fitY0))
  Ey1 - Ey0
}

load(file = file.path(intermediate, "loaded_test_data.Rda"))
estimated_ATEs <- lapply(df_list_data, FUN = augmented_iptw)
#Compare to Truth
compare_to_truth(true_ATEs, estimated_ATEs)

