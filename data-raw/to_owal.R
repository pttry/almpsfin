filepath <- "C:/Users/juhoa/Desktop"

data("statfi_participants")
data("eurostat_statfi_key")
statfi_participants <- left_join(statfi_participants, eurostat_statfi_key)
writexl::write_xlsx(statfi_participants, file.path(filepath, "statfi_participants.xlsx"))


data(lmp_participants)
lmp_participants <- left_join(lmp_participants, key, by = "LMP_TYPE")   |> filter_years()
writexl::write_xlsx(lmp_participants, file.path(filepath, "lmp_participants.xlsx"))

data("annual_per_stock_costs")
annual_per_stock_costs <- left_join(annual_per_stock_costs, key, by = "LMP_TYPE")   |> filter_years()
writexl::write_xlsx(annual_per_stock_costs, file.path(filepath, "annual_per_stock_costs.xlsx"))

data("total_costs")
annual_per_stock_costs <- left_join(annual_per_stock_costs, key, by = "LMP_TYPE")   |> filter_years()
writexl::write_xlsx(annual_per_stock_costs, file.path(filepath, "total_costs.xlsx"))

data(participation_costs)
key <- distinct(select(eurostat_statfi_key, LMP_TYPE, palveluluokka, lmp_name_fin))
participation_costs <- left_join(participation_costs, key, by = "LMP_TYPE") |> filter_years()

participation_costs <- mutate(participation_costs, cost = value)
writexl::write_xlsx(participation_costs, file.path(filepath, "participation_costs.xlsx"))
