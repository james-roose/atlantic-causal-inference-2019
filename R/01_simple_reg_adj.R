# Script to take in a dataframe of outcome and covariates, and apply a simple
# logistic or OLS regression using GLM to calculate ATE
#
#
#
library(tidyverse)
raw <- file.path("../data/raw/TestDatasets_lowD/")
intermediate <- file.path("../data/intermediate")
source("utility_funs.R")

simple_reg_adj <- function(dataframe){
  #Learn Family ie Binary or Continuous Outcome
  family = learn_outcome_family(dataframe)
  
  #Fit model with no interactions
  fit <- glm("Y ~ A + .", family = family, data = dataframe)
  
  #Calculate ATE from the fitted regression object
  newdata1 = dataframe
    newdata1$A = 1
  newdata0 = dataframe
    newdata0$A = 0
  Ey1 <- mean(predict(fit, newdata = newdata1,
                      type = "response" ) )
  Ey0 <- mean(predict(fit, newdata = newdata0,
                      type = "response"))
  Ey1 - Ey0
}

load(file = file.path(intermediate, "loaded_test_data.Rda"))
estimated_ATEs <- lapply(df_list_data, FUN = simple_reg_adj)

#Compare to Truth
diff = unlist(estimated_ATEs) - unlist(true_ATEs)
diff