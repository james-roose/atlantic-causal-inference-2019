# Script to Implement a Simple Expository Example of TMLE (for practice)
#
#
#
simple_tmle <- function(dataframe){
  O = dataframe
  txt = control = O
  txt$A = 1
  control$A = 0
  
  family = learn_outcome_family(O)
  # Get Initial Fit Using GLM (temp)
  Qbar <- glm("Y ~ A + .", family = family, data = O)
  QbarAW = predict(Qbar, type = "response")
  Qbar1 = predict(Qbar, newdata = txt, type = "response")
  Qbar0 = predict(Qbar, newdata = txt, type = "response")
  
  # Get Propensity Score Using GLM (temp)
  #Update later - this is simple 
  prop_df = dataframe[ , -1]
  ghat <- glm("A ~ .", family = family, data = prop_df)
  
  ghat1W = predict(ghat, newdata = txt[, -1],  type = "response")
  ghat0W = 1 - ghat1W
  ghatAW = ghat1[which(O$A == 1)] + ghat0W[which(O$A==0)]
  
  # Clever Covariate Calculations
  HAW = (2*O$A-1) / gHatAW
  H1W<- 1/gHat1W
  H0W<- -1/gHat0W
  
  # TMLE
  logitUpdate <- glm(O$Y ~ -1 + offset(qlogis(QbarAW)) + H.AW,
                     family='binomial')
  epsilon <- logitUpdate$coef
  
  # Update 
  QbarAW.star<- plogis(qlogis(QbarAW)+ epsilon*H.AW)
  Qbar1W.star<- plogis(qlogis(Qbar1W)+ epsilon*H.1W)
  Qbar0W.star<- plogis(qlogis(Qbar0W)+ epsilon*H.0W)
  
  # ATE
  mean(Qbar1W.star - Qbar0W.star)
}

load(file = file.path(intermediate, "loaded_test_data.Rda"))
estimated_ATEs <- lapply(df_list_data, FUN = simple_tmle)
#Compare to Truth
compare_to_truth(true_ATEs, estimated_ATEs)
