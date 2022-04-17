# tyonv_12u4

base_url <- "https://pxnet2.stat.fi/PXWeb/api/v1/fi/"
data(taulut)

for(i in 1:dim(taulut)[1]) {

url <- paste0(base_url, taulut$table_location[i])
query <- taulut$query[i][[1]]

data <- get_statfi_data(url ,query)
data <- select(data, !contains("name"))
data <- data[,sapply(names(data), function(x) {length(unique(data[[x]])) > 1})]
data <- rename(data, value = values)
names(data) <- sapply(names(data), function(x) {gsub("_code", "", x)})
data_name <- sapply(url,
                    function(x) {paste(stringr::str_match(x, "statfin_\\s*(.*?)\\s*pxt_\\s*(.*?)\\s*.px")[,2:3], collapse = "")},
                    USE.NAMES = FALSE)

assign(data_name, data)
do.call("use_data", list(as.name(data_name), overwrite = TRUE))

}


