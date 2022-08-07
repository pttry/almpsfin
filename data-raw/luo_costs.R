data(lmp_expenditures)
data(lmp_participants)

lmp_expenditures <- lmp_expenditures |>
  mutate(value = adj_inflation(value, time, year = 2021))

total_costs <- lmp_expenditures  |>
    filter(EXPTYPE == "XTOT")

usethis::use_data(total_costs, overwrite = TRUE)

annual_per_stock_costs <- lmp_participants |>
  select(STK_FLOW, LMP_TYPE, time, value) |>
  spread(STK_FLOW, value) |>
  right_join(total_costs, by = c("LMP_TYPE", "time")) |>
  mutate(exp_per_STK = value * 10^6 / STK) |>
  select(LMP_TYPE, time, exp_per_STK, flag, flag_name) |>
  rename(value = exp_per_STK)

usethis::use_data(annual_per_stock_costs, overwrite = TRUE)

data(durations)

avg_durations <- durations |>
   rename(duration = value) |>
   left_join(distinct(select(eurostat_statfi_key, lmp_name_fin, LMP_TYPE)), by = "lmp_name_fin") |>
   select(-lmp_name_fin)

participation_costs <- annual_per_stock_costs |>
  left_join(avg_durations, by = c("LMP_TYPE", "time")) |>
  mutate(exp = value / 12 * duration) |>
  select(-palveluluokka, -value) |>
  rename(value = exp)

usethis::use_data(participation_costs, overwrite = TRUE)
