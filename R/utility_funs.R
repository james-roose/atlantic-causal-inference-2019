# Set of Utility Functions for Package
#
#
#
#

learn_outcome_family <- function(dataframe){
  # Add other checks here later
  
  if (count(unique(dataframe[, "Y"])) == 2){
    family = "binomial"
  } else if  (count(unique(dataframe[, "Y"])) != 2)  {
    family = "gaussian"
  } else {stop("Error ")}
  
  return(family)
}

# Function to Bound Weights Between Absolute Limits or Quantiles of
# the weight distribution
bound_wt <- function(wt, lower_bound, upper_bound, type="quantile"){
  if (type == "quantile"){
    u = quantile(wt, probs = upper_bound, names = F)
    l = quantile(wt, probs = lower_bound, names = F)
    wt = ifelse(wt > l & wt < u, wt, ifelse(wt > l, u, l))
  } else if (type == "absolute"){
    u = upper_bound
    l = lower_bound
    wt = ifelse(wt > l & wt < u, wt, ifelse(wt > l, u, l))
  }
  wt
}

# bound outcomes

# Compare to Truth
compare_to_truth <- function(truth, est){
  to_return = rbind(unlist(est), unlist(truth),
                    unlist(est) - unlist(truth))
  rownames(to_return) = c("est", "truth", "bias")
  return(to_return)
}

