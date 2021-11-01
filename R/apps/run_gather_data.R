# requests all data
# checks for data you already have and doesn't request that unless you have that set to truncate
#

source("R/components/request_data.R")

main <- function() {

  output_path <- "data/raw"
  dir.create(output_path, showWarnings=FALSE, recursive=TRUE)

  # check local for existing datasets
  existing_dfs <- stringr::str_remove(list.files(output_path), "\\.rds$")

  # get the setdiff between existing and full list
  new_requests <- setdiff(names(FULL_REQUEST_LIST), existing_dfs)

  # request data on the setdiff
  df_list <- request_data(FULL_REQUEST_LIST[new_requests])

  # write new datasets to local
  for (df_name in names(df_list)) {
    readr::write_rds(df_list[[df_name]], file.path(output_path, glue::glue("{df_name}.rds")))
  }
}

# Run the app
main()
