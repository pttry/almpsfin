# Työvoimakoulutus

data(statfi_tiedot_key)
data(tyonv_12u2)
data1 <- tyonv_12u2 |>
         mutate(tiedot = statficlassifications::key_recode(tiedot, statfi_tiedot_key),
                time_var = "kuukausi",
                table = "tyonv_12u2") |>
         rename(code_statfi = valtionosuuskoulutus_vos) |>
         relocate(time, time_var, code_statfi, tiedot, value, table)

data(tyonv_12v7)
data2 <- tyonv_12v7 |>
         mutate(tiedot = statficlassifications::key_recode(tiedot, statfi_tiedot_key),
                time_var = "vuosi",
                table = "tyonv_12v7") |>
         rename(code_statfi = valtionosuuskoulutus_vos) |>
         relocate(time, time_var, code_statfi, tiedot, value, table)

data_tyovoimakoulutus <- rbind(data1, data2)
data_tyovoimakoulutus$palveluluokka <- "tyovoimakoulutus"

# Työllistäminen

data(tyonv_12u6)
data1 <- tyonv_12u6 |>
         mutate(tiedot = statficlassifications::key_recode(tiedot, statfi_tiedot_key),
                time_var = "kuukausi",
                table = "tyonv_12u6") |>
         rename(code_statfi = tyollistamisen_laji)  |>
         relocate(time, time_var, code_statfi, tiedot, value, table)

data(tyonv_12va)
data2 <- tyonv_12va |>
         mutate(tiedot = statficlassifications::key_recode(tiedot, statfi_tiedot_key),
                time_var = "vuosi",
                table = "tyonv_12va") |>
         rename(code_statfi = tyollistamisen_laji) |>
         relocate(time, time_var, code_statfi, tiedot, value, table)

data_tyollistaminen <- rbind(data1, data2)
data_tyollistaminen$palveluluokka <- "tyollistaminen"


# Valmennus

data(tyonv_12u1)
data1 <- tyonv_12u1 |>
         mutate(tiedot = "VALMENNUSLOP") |>
         mutate(tiedot = statficlassifications::key_recode(tiedot, statfi_tiedot_key),
                time_var = "kuukausi",
                table = "tyonv_12u1") |>
         rename(code_statfi = valmennus) |>
         relocate(time, time_var, code_statfi, tiedot, value, table)

data(tyonv_12v9)
data2 <- tyonv_12v9 |>
         mutate(tiedot = statficlassifications::key_recode(tiedot, statfi_tiedot_key),
                time_var = "vuosi",
                table = "tyonv_12v9") |>
         rename(code_statfi = valmennus) |>
         relocate(time, time_var, code_statfi, tiedot, value, table)

data_valmennus <- rbind(data1, data2)
data_valmennus$palveluluokka <- "valmennus"

# Kokeilut

data(tyonv_12u8)
data1 <- tyonv_12u8 |>
         mutate(tiedot = statficlassifications::key_recode(tiedot, statfi_tiedot_key),
                time_var = "kuukausi",
                table = "tyonv_12u8") |>
         rename(code_statfi = arviointi_kokeilut) |>
         relocate(time, time_var, code_statfi, tiedot, value, table)

data(tyonv_12uv)
data2 <- tyonv_12uv |>
         filter(tiedot != "KOKAVGEDTYKESTOALK_TAJO") |> droplevels() |>
         mutate(tiedot = statficlassifications::key_recode(tiedot, statfi_tiedot_key),
                time_var = "vuosi",
                table = "tyonv_12uv") |>
         rename(code_statfi = arviointi_kokeilut) |>
         relocate(time, time_var, code_statfi, tiedot, value, table)

data_kokeilu <- rbind(data1, data2)
data_kokeilu$palveluluokka <- "kokeilu"

# Muut palvelut

data(tyonv_12u9)
data1 <- tyonv_12u9 |>
         mutate(tiedot = statficlassifications::key_recode(tiedot, statfi_tiedot_key),
                time_var = "kuukausi",
                table = "tyonv_12u9") |>
         rename(code_statfi = muut_palvelut) |>
         relocate(time, time_var, code_statfi, tiedot, value, table)

data(tyonv_12uu)
data2 <- tyonv_12uu |>
         filter(tiedot != "MTPAVGEDTYKESTOALK_TAJO") |> droplevels() |>
         mutate(tiedot = statficlassifications::key_recode(tiedot, statfi_tiedot_key),
                time_var = "vuosi",
                table = "tyonv_12uu") |>
         rename(code_statfi = muut_palvelut) |>
         relocate(time, time_var, code_statfi, tiedot, value, table)

data_muu <- rbind(data1, data2)
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
                     TOTAL = sum(TOTAL, na.rm = TRUE),
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
