# TODO look into function factories

library(dplyr)

# helper functions ####

resolve_freq <- function(freq, format=c("quandl", "fred", "glassnode")) {
  format <- rlang::arg_match(format)
  if (!is.null(freq)) {
    freq <- switch(
      format,
      "quandl"=switch(freq, "d"="daily", "w"="weekly", "m"="monthly"),
      "fred"=switch(freq, "d"="d", "w"="w", "m"="m"),
      "glassnode"=switch(freq, "d"="24h", "w"="1w", "m"="1month")
    )
  }
  return(freq)
}

standardize_request <- function(df) {
  df %>%
    as_tibble() %>%
    arrange(date)
}

resolve_date <- function(date, format=c("quandl", "fred", "glassnode")) {
  format <- rlang::arg_match(format)
  if (!is.null(date)) {
    date <- switch(
      format,
      "quandl"=date,
      "fred"=as.Date(date),
      "glassnode"=as.numeric(as.POSIXct(date))
    )
  }
  return(date)
}

# glassnode data functions ####

request_glassnode_data <- function(id, endpoint, start=NULL, end=NULL, freq=NULL) {
  f <- "glassnode"
  key <- Sys.getenv("GLASSNODE_API_KEY")
  url <- glue::glue("https://api.glassnode.com/{endpoint}")
  query <- list(
    a=id,
    api_key=key,
    s=resolve_date(start, f),
    u=resolve_date(end, f),
    i=resolve_freq(freq, f)
  )

  httr::GET(url=url, query=query) %>%
    httr::content(as="text") %>%
    jsonlite::fromJSON() %>%
    mutate(t = lubridate::as_datetime(t) %>% lubridate::as_date()) %>%
    rename(date = t)
}

btc_active_addresses <- function(...) {
  request_glassnode_data(id='btc', endpoint="v1/metrics/addresses/active_count", ...) %>%
    select(date, btc_active_addresses=v) %>%
    standardize_request()
}

btc_sending_addresses <- function(...) {
  request_glassnode_data(id='btc', endpoint="v1/metrics/addresses/sending_count", ...) %>%
    select(date, btc_sending_addresses=v) %>%
    standardize_request()
}

btc_receiving_addresses <- function(...) {
  request_glassnode_data(id='btc', endpoint="v1/metrics/addresses/receiving_count", ...) %>%
    select(date, btc_receiving_addresses=v) %>%
    standardize_request()
}

btc_new_addresses <- function(...) {
  request_glassnode_data(id='btc', endpoint="v1/metrics/addresses/new_non_zero_count", ...) %>%
    select(date, btc_new_addresses=v) %>%
    standardize_request()
}

btc_price_usd <- function(...) {
  request_glassnode_data(id='btc', endpoint="v1/metrics/market/price_usd_close", ...) %>%
    select(date, btc_price_usd=v) %>%
    standardize_request()
}



# quandl data functions ####

request_quandl_data <- function(id, start=NULL, end=NULL, freq=NULL) {
  f <- "quandl"
  key <- Sys.getenv("NASDAQ_API_KEY")
  Quandl::Quandl.api_key(key)

  Quandl::Quandl(
    code=id,
    start_date=resolve_date(start, f),
    end_date=resolve_date(end, f),
    collapse=resolve_freq(freq, f)
  )
}

gold_price <- function(...) {
  request_quandl_data(id="LBMA/GOLD", ...) %>%
    select(date=Date, gold_price=`USD (PM)`) %>%
    standardize_request()
}

# fred data functions ####

request_fred_data <- function(id, start=NULL, end=NULL, freq=NULL) {
  f <- "fred"
  key <- Sys.getenv("FRED_API_KEY")
  fredr::fredr_set_key(key)

  fredr::fredr(
    series_id=id,
    observation_start=resolve_date(start, f),
    observation_end=resolve_date(end, f),
    frequency=resolve_freq(freq, f)
  )
}

inflation_compensation <- function(...) {
  request_fred_data(id="RESPPALGUOMCXAWXCH52NWW", ...) %>%
    select(date, inflation_compensation = value) %>%
    standardize_request()
}
