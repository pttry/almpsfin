read_lmp_data <- function(url, years = 1997:2020) {

  data <- read.csv(url)
  var_names <- unlist(strsplit(names(data)[1], "\\."))
  names(data) <- c("var", names(data)[-1])

  data <- separate(data, var, into = var_names, sep = ";") %>%
    gather(time, value, paste0("X", years)) %>%
    mutate(time = gsub("X", "", time)) %>%
    select(-TIME_PERIOD) %>%
    separate(value, into = c("value", "flag"), sep = " ") %>%
    mutate(value = as.double(value),
           time = as.double(time))

  data[data == ":"] <- NA
  data
}

# LMP code-name key

url <- "https://webgate.ec.europa.eu/empl/redisstat/api/dissemination/sdmx/2.1/data/LMP_EXPME$FI/?format=JSON&lang=en"

resp <- httr::GET(url)
cont <- httr::content(resp, "text", encoding = "UTF-8")
x <- jsonlite::fromJSON(cont)
key_list  <- x$dimension$LMP_TYPE$category$label
LMP_TYPE_name_key <- data.frame(LMP_TYPE = names(key_list), lmp_name_en = unlist(key_list))
rownames(LMP_TYPE_name_key) <- NULL

usethis::use_data(LMP_TYPE_name_key, overwrite = TRUE)

flag_key_list <- x$extension$status$label
flag_key <- data.frame(flag = names(flag_key_list), flag_name = unlist(flag_key_list))
rownames(flag_key) <- NULL

# Expenditure by LMP intervention

data <- read_lmp_data("https://webgate.ec.europa.eu/empl/redisstat/api/dissemination/sdmx/2.1/data/LMP_EXPME$FI/?format=CSV")
data <- select(data, -FREQ) |>
        filter(UNIT == "MIO_EUR")

lmp_expenditures <- left_join(data, flag_key, by = "flag")

usethis::use_data(lmp_expenditures, overwrite = TRUE)

# Participants by LMP intervention

data <- read_lmp_data("https://webgate.ec.europa.eu/empl/redisstat/api/dissemination/sdmx/2.1/data/LMP_PARTME$FI/?format=CSV")
data <- filter(data, SEX == "T", AGE == "TOTAL") %>%
        select(-AGE, -SEX, -UNIT, -FREQ)
lmp_participants <- left_join(data, flag_key, by = "flag")

usethis::use_data(lmp_participants, overwrite = TRUE)
