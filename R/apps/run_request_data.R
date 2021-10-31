# requests all data
# checks for data you already have and doesn't request that unless you have that set to truncate
#

source("R/components/request_data.R")
library(glue)

main <- function() {
  # check existing datasets
  # get the setdiff between existing and full list
  # run request data on the setdiff
  df_list <- request_data(FULL_REQUEST_LIST)

  # write new datasets to existing

}

# Run the app
main()
