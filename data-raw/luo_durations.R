
# Euroopan komissio, laskettu

data(lmp_participants)

eurostat_durations <- lmp_participants |>
  select(STK_FLOW, LMP_TYPE, time, value) |>
  left_join(eurostat_statfi_key, by = "LMP_TYPE") |>
  group_by(STK_FLOW, lmp_name_fin, palveluluokka, time) |>
  summarize(value = sum(value, na.rm = TRUE)) |>
  ungroup() |>
  spread(STK_FLOW, value) |>
  mutate(value = 12*STK / (0.5 * (EXIT + ENT))) |>
  select(-ENT, -EXIT, -STK) |>
  mutate(lahde = "Euroopan komissio",
         type = "computed")

# StatFin, laskettu

data(statfi_participants)

statfi_durations_computed <- statfi_participants |>
  select(time, time_var, code_statfi, tiedot, value, STK_type, aggregated, table) |>
  left_join(eurostat_statfi_key, by = "code_statfi") |>
  group_by(lmp_name_fin, time, time_var, tiedot, STK_type, aggregated, palveluluokka, table) |>
  summarize(value = sum(value, na.rm = TRUE)) |>
  ungroup() |>
  mutate(STK_type = ifelse(is.na(STK_type), "NA", STK_type)) |>
  filter(time_var == "vuosi", STK_type != "end") |>
  arrange(aggregated) |>
  group_by(time, time_var, lmp_name_fin, tiedot) |>
  filter(row_number() == 1) |>
  ungroup() |>
  select(tiedot, lmp_name_fin, palveluluokka, time, value, table)

datalahde_computed <- statfi_durations_computed |>
             select(lmp_name_fin, table) |>
             distinct() |>
             mutate(type = "computed")

statfi_durations_computed <- statfi_durations_computed  |>
  select(-table) |>
  distinct() |>
  spread(tiedot, value) |>
  mutate(value = 12*STK / (0.5 * (EXIT + ENT))) |>
  select(lmp_name_fin, palveluluokka, time, value) |>
  mutate(type = "computed",
         lahde = "Tilastokeskus",
         time = as.double(substring(time, 1,4)))

# Statfin, todellinen

data(statfi_durations)

entries <- statfi_participants |>
  filter(tiedot == "ENT", time_var== "vuosi") |>
  select(code_statfi, value, time, aggregated) |>
  arrange(aggregated) |>
  group_by(time, code_statfi) |>
  filter(row_number() == 1) |>
  ungroup() |>
  rename(ENT = value) |>
  select(-aggregated)

statfi_durations_actual <- statfi_durations |>
  filter(time_var == "vuosi") |>
  left_join(eurostat_statfi_key, by = "code_statfi") |>
  left_join(entries, by = c("code_statfi", "time")) |>
  group_by(time, lmp_name_fin, palveluluokka, table) |>
  mutate(ENT = ifelse(is.na(ENT), 0, ENT)) |>
  summarize(value = weighted.mean(value, ENT, na.rm = TRUE)) |>
  mutate(value = value / 30) |>
  mutate(type = "actual",
         lahde = "Tilastokeskus",
         time = as.double(substring(time, 1,4))) |>
  ungroup()

datalahde_actual <- statfi_durations_actual |>
                    select(lmp_name_fin, table) |>
                    distinct() |>
                    mutate(type = "actual")

datalahde_durations <- rbind(datalahde_computed, datalahde_actual)

usethis::use_data(datalahde_durations, overwrite = TRUE)


statfi_durations_actual <- select(statfi_durations_actual, -table)

eurostat_durations <- select(eurostat_durations, names(statfi_durations_actual))
statfi_durations_computed <- select(statfi_durations_computed, names(statfi_durations_actual))

durations <- rbind(statfi_durations_actual,
                   statfi_durations_computed,
                   eurostat_durations)

durations <- unite(durations, group, type, lahde)

usethis::use_data(durations, overwrite = TRUE)

