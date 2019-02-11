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

# load(file = file.path(intermediate, "loaded_test_data.Rda"))
# df = df_list_data[[1]]
