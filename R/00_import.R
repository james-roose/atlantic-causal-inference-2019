# Functions to Load Data and Store in Intermediate Location
#
#
# install.packages("tidyverse")
library(tidyverse)

raw <- file.path("../data/raw/TestDatasets_lowD/")
intermediate <- file.path("../data/intermediate")

# Add some checks to see if data is available else point to online location
df_list_data = lapply(list.files(raw, pattern = "*[[:digit:]].csv",
                                 full.names = T), FUN = read_csv)
names(df_list_data) = lapply(list.files(raw, pattern = "*[[:digit:]].csv"),
                             FUN = function(x) x )

df_list_cf = lapply(list.files(raw, pattern = "*cf.csv", full.names = T),
                    FUN = read_csv)
names(df_list_cf) = lapply(list.files(raw, pattern = "*cf.csv"),
                           FUN = function(x) x)

# True ATEs
get_ATE <- function(df){df[1,1]}
true_ATEs = lapply(df_list_cf, FUN = get_ATE)

# Save Results in Intermediate File Location
save(df_list_cf, df_list_data, true_ATEs,
     file = file.path(intermediate, "loaded_test_data.Rda"))

