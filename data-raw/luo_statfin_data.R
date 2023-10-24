data(taulut)

for(i in 1:dim(taulut)[1]) {

url <- statfidata::statfi_parse_url(taulut$table_location[i])
query <- taulut$query[i][[1]]
data <- statfidata::get_statfi_data(url = url, query = query)

data_name <- statfidata::get_table_code(url)
assign(data_name, data)

do.call("use_data", list(as.name(data_name), overwrite = TRUE))

}


