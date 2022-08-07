data(statfi_tiedot_key)

luo_durations <- function(df, var_name, time_var, df_name = deparse(substitute(df))) {
  df |>
    mutate(tiedot = statficlassifications::key_recode(tiedot, statfi_tiedot_key),
           time_var = time_var,
           table = df_name) |>
    filter(tiedot %in% c("KESTO")) |>
    rename_with(~"code_statfi", var_name) |>
    relocate(time, time_var, code_statfi, tiedot, value, table)
}


# Työvoimakoulutus

data(tyonv_12v8)    # vrk, koulutuspäiviä
data(tyonv_12u2)    # vrk, koulutuspäiviä
data_tyovoimakoulutus <- rbind(luo_durations(tyonv_12u2, "valtionosuuskoulutus_vos", "kuukausi"),
                               luo_durations(tyonv_12v8, "valtionosuuskoulutus_vos", "vuosi")) # |>
                       #  mutate(value = value/5 * 7)

# Työllistäminen

data(tyonv_12u6)    # vk, päättyneen työllistämisen kesto
data(tyonv_12va)    # vk, päättyneen työllistämisen kesto

data_tyollistaminen <- rbind(luo_durations(tyonv_12u6, "tyollistamisen_laji", "kuukausi"),
                             luo_durations(tyonv_12va, "tyollistamisen_laji", "vuosi")) |>
                       mutate(value = 7*value)

# Valmennus

data(tyonv_12v9)    # vrk, valmennuspäiviä

data_valmennus <- rbind(luo_durations(tyonv_12v9, "valmennus", "vuosi")) #|>
                 # mutate(value = value/5 * 7)

# Kokeilut

data(tyonv_12uv)    # vk kokeilujen keskim kesto

data_kokeilu <- rbind(luo_durations(tyonv_12uv, "arviointi_kokeilut", "vuosi")) |>
                mutate(value = 7*value)

# Muut palvelut

data(tyonv_12u9)    # vk päättyneiden keskim kesto
data(tyonv_12uu)     # vk päättyneiden keskim kesto

data_muu <- rbind(luo_durations(tyonv_12u9, "muut_palvelut", "kuukausi"),
                  luo_durations(tyonv_12uu, "muut_palvelut", "vuosi")) |>
            mutate(value = 7*value)

data <- rbind(data_tyovoimakoulutus,
              data_tyollistaminen,
              data_valmennus,
              data_kokeilu,
              data_muu)

statfi_durations <- filter(data, code_statfi != "SSS")
statfi_durations <- select(statfi_durations, -tiedot)

usethis::use_data(statfi_durations, overwrite = TRUE)
