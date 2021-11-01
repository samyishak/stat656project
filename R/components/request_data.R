# source utilities.request
source("R/utilities/request_data_functions.R")

FULL_REQUEST_LIST = list(
  # glassnode requests ####
  btc_active_addresses   = list(start="2020-01-01", end="2020-01-31", freq="d"),
  btc_price_usd          = list(start="2020-01-01", end="2020-01-31", freq="d"),
  # quandl requests ####
  btc_bitfinex           = list(start="2020-01-01", end="2020-01-31", freq="d"),
  # fred requests ####
  inflation_compensation = list(start="2020-01-01", end="2020-01-31", freq="w")
  # end ####
)

request_data <- function(request_list) {
  df_list <- list()
  for (request in names(request_list)) {
    message(glue::glue("Requesting data for {request}"))
    elem <- rlang::exec(
      request,
      start=request_list[[request]][["start"]],
      end=request_list[[request]][["end"]],
      freq=request_list[[request]][["freq"]]
    ) %>% list()
    names(elem) <- request
    df_list <- append(df_list, elem)
  }
  return(df_list)
}
