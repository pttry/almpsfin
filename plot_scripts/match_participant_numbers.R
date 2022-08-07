match_palvelut <- function(codes_eurostat, codes_statfi) {

  data1 <- data_statfi |>
    filter(code_statfi %in% codes_statfi) |>
    group_by(time, tiedot, aggregated, STK_type, table) |>
    summarize(value = sum(value, na.rm = TRUE)) |>
    ungroup() |>
    mutate(lahde_legend = paste("StatFin:", paste(unique(codes_statfi), collapse = ", ")),
           lahde_selite = "statfi")

  data2 <- data_eurostat |>
    filter(LMP_TYPE %in% codes_eurostat) |>
    group_by(time, tiedot, aggregated, STK_type) |>
    summarize(value = sum(value, na.rm = TRUE)) |>
    ungroup() |>
    mutate(lahde_legend = paste("Euroopan komission aineisto:", paste(unique(codes_eurostat), collapse = ", ")),
           lahde_selite = "eurostat",
           table = NA)

  rbind(data1, data2)

}

plot_match <- function(df) {

  df |> unite(data_type, aggregated, STK_type) |>
    ggplot(aes(x = time, y = value, color = lahde_legend, linetype = lahde_legend, shape = lahde_legend)) +
    geom_line(size = 1) +
    geom_point(size = 2) +
    facet_wrap(~tiedot, labeller = as_labeller(labels)) +
    scale_y_continuous(labels = axis_text_format) +
    scale_shape_manual(name = "Lähde ja palvelun koodi", values = c(3,4)) +
    scale_color_manual(name = "Lähde ja palvelun koodi", values = color_palette) +
    scale_linetype_discrete(name = "Lähde ja palvelun koodi") +
    scale_x_continuous(breaks = seq(2008, 2020, by = 4)) +
    labs(y = NULL, x = NULL) +
    theme_bw() +
    theme(legend.position = "bottom",
          legend.title = element_text(size = 15),
          legend.text = element_text(size = 15),
          axis.title = element_text(size = 15),
          axis.text = element_text(size = 15),
          strip.text = element_text(size = 15, hjust = 0),
          strip.background = element_blank())
}

labels <- c("STK" = "Palvelussa olevat", "ENT" = "Aloittaneet", "EXIT" = "Lopettaneet")

write_selite <- function(df) {

  data_selite <-
    df |>
    filter(!is.na(table)) |>
    filter(time == 2015) |>
    group_by(tiedot)

  data_selite <- data_selite |>
    mutate(tiedot = statficlassifications::key_recode(tiedot, labels, tiedot)) |>
    mutate(selite = paste0(tiedot, ": ", "StatFin työnvälitystilasto, taulu ", table,
                           ifelse(aggregated, ", vuosittaiset määrät laskettu kuukausiaineistosta", ""),
                           ifelse(aggregated & tiedot == "Palvelussa olevat", ifelse(STK_type == "mean", " kuukausikeskiarvona",
                                                                       ifelse(STK_type == "end", " vuoden viimeisen kuukauden tietona", "")), ""),
                           ifelse(aggregated & tiedot != "Palvelussa olevat", " kuukausitietojen summana", ""), "."))

  selite <-  paste0(paste0(data_selite$selite, collapse = " "))
  gsub("_", "\\\\_", selite)

}

data(statfi_participants)
data_statfi <- statfi_participants |>
  filter(time_var == "vuosi",
         tiedot %in% c("STK", "STK_mean", "STK_end", "ENT", "EXIT")) |>
  mutate(time = lubridate::year(time)) |>
  filter(time <= 2020) |>
  arrange(aggregated) |>
  group_by(time, time_var, code_statfi, tiedot) |>
  filter(row_number() == 1) |>
  ungroup()

data(lmp_participants)
data_eurostat <- lmp_participants |>
  filter(time >= 2006) |>
  select(STK_FLOW, LMP_TYPE, time, value) |>
  rename(tiedot  = STK_FLOW) |>
  select(time, tiedot, value, LMP_TYPE) |>
  mutate(aggregated = FALSE,
         STK_type = ifelse(tiedot == "STK", "end", NA))

palvelut <- unique(eurostat_statfi_key$lmp_name_fin)
stringi::stri_write_lines(paste0(palvelut, collapse = ", "), paste0("plots/eurostat_statfin/palvelut.txt"))

for(palvelu in palvelut) {

  df <- filter(eurostat_statfi_key, lmp_name_fin == palvelu)
  matched_data <- match_palvelut(df$LMP_TYPE, df$code_statfi)
  plot_match(matched_data)
  ggsave(paste0("plots/eurostat_statfin/", palvelu, ".pdf"), width = 10, height = 4)
  selite <- write_selite(matched_data)
  stringi::stri_write_lines(selite, paste0("plots/eurostat_statfin/", palvelu, "_selite.txt"))

  Sys.sleep(0.01); print(palvelu)
}


data(eurostat_statfi_key)
key <- select(eurostat_statfi_key, LMP_TYPE, code_statfi, lmp_name_fin, palveluluokka_name)
table <- paste(unlist(lapply(1:dim(key)[1], function(x) {paste(key[x,], collapse = " & ")})), collapse = " \\\\ ")
table <- gsub("_", "\\\\_", table)
stringi::stri_write_lines(table, paste0("plots/eurostat_statfin/key.txt"))
