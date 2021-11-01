# Gathers data that isn't already available locally
# Merges all data on date

source("R/components/request_data.R")

output_path <- "data/raw"
dir.create(output_path, showWarnings=FALSE, recursive=TRUE)

# check local for existing datasets
existing_df_names <- stringr::str_remove(list.files(output_path), "\\.rds$")

# get the setdiff between existing and full list
new_requests <- setdiff(names(FULL_REQUEST_LIST), existing_df_names)

# request data on the setdiff
df_list <- request_data(FULL_REQUEST_LIST[new_requests])

# write new datasets to local
for (df_name in names(df_list)) {
  readr::write_rds(df_list[[df_name]], file.path(output_path, glue::glue("{df_name}.rds")))
}

rm(df_list)

# read all dataframes
all_df_paths <- list.files(output_path, full.names=TRUE) %>%
  stringr::str_subset("_all_data", negate=TRUE)
df_list <- list()
for (df_path in all_df_paths) {
  elem <- readr::read_rds(df_path) %>% list()
  df_list <- append(df_list, elem)
}

# merge datasets
df <- df_list %>% purrr::reduce(full_join, by="date")

# write merged dataset
readr::write_rds(df, file.path(output_path, "_all_data.rds"))
