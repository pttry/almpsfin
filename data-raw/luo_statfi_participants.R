data(statfi_tiedot_key)

luo_participants <- function(df, var_name, time_var, df_name = deparse(substitute(df))) {
  df |>
    mutate(tiedot = statficlassifications::key_recode(tiedot, statfi_tiedot_key),
           time_var = time_var,
           table = df_name) |>
    filter(tiedot %in% c("STK", "ENT", "EXIT")) |>
    rename_with(~"code_statfi", var_name) |>
    relocate(time, time_var, code_statfi, tiedot, value, table)
}


# Työvoimakoulutus

data(tyonv_12u2)
data(tyonv_12v7)
data_tyovoimakoulutus <- rbind(luo_participants(tyonv_12u2, "valtionosuuskoulutus_vos", "kuukausi"),
                               luo_participants(tyonv_12v7, "valtionosuuskoulutus_vos", "vuosi"))
data_tyovoimakoulutus$palveluluokka <- "tyovoimakoulutus"

# Työllistäminen

data(tyonv_12u6)
data(tyonv_12va)

data_tyollistaminen <- rbind(luo_participants(tyonv_12u6, "tyollistamisen_laji", "kuukausi"),
                             luo_participants(tyonv_12va, "tyollistamisen_laji", "vuosi"))
data_tyollistaminen$palveluluokka <- "tyollistaminen"

# Valmennus

data(tyonv_12u1)
data(tyonv_12v9)
tyonv_12u1 <- mutate(tyonv_12u1, tiedot = "VALMENNUSLOP")

data_valmennus <- rbind(luo_participants(tyonv_12u1, "valmennus", "kuukausi"),
                        luo_participants(tyonv_12v9, "valmennus", "vuosi"))
data_valmennus$palveluluokka <- "valmennus"

# Kokeilut

data(tyonv_12u8)
data(tyonv_12uv)

data_kokeilu <- rbind(luo_participants(tyonv_12u8, "arviointi_kokeilut", "kuukausi"),
                      luo_participants(tyonv_12uv, "arviointi_kokeilut", "vuosi"))
data_kokeilu$palveluluokka <- "kokeilu"

# Muut palvelut

data(tyonv_12u9)
data(tyonv_12uu)

data_muu <- rbind(luo_participants(tyonv_12u9, "muut_palvelut", "kuukausi"),
                  luo_participants(tyonv_12uu, "muut_palvelut", "vuosi"))
data_muu$palveluluokka <- "muu"


data <- rbind(data_tyovoimakoulutus,
              data_tyollistaminen,
              data_valmennus,
              data_kokeilu,
              data_muu)

data <- filter(data, code_statfi != "SSS")

data_kk <- filter(data, time_var == "kuukausi", tiedot != "KESTO") |>
  spread(tiedot, value) |>
  mutate(time = as.Date(paste0(lubridate::year(time), "-01-01"))) |>
  group_by(time, code_statfi, palveluluokka, table) |>
  summarize(STK_mean = mean(STK, na.rm = TRUE),
            STK_end = STK[c( rep(FALSE, 11), TRUE )],
            ENT = sum(ENT, na.rm = TRUE),
            EXIT = sum(EXIT, na.rm = TRUE)) |>
  ungroup() |>
  gather(tiedot, value, -time, -code_statfi, -palveluluokka,- table) |>
  mutate(time_var = "vuosi") |>
  relocate(time, time_var, code_statfi, tiedot, value, table, palveluluokka) |>
  mutate(STK_type = ifelse(tiedot == "STK_mean", "mean", ifelse(tiedot == "STK_end", "end", NA)),
         tiedot = ifelse(tiedot == "STK_mean", "STK", ifelse(tiedot == "STK_end", "STK", tiedot)))

data_kk$aggregated <- TRUE
data <- mutate(data, STK_type = ifelse(tiedot == "STK", "end", NA))
data$aggregated <- FALSE

statfi_participants <- rbind(data, data_kk)

usethis::use_data(statfi_participants, overwrite = TRUE)
