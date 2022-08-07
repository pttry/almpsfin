data(durations)
durations <- filter_years(durations)

plot_kestot <- function(.palveluluokka,
                        point_size = 4, line_width = 1, text_size = 15) {

  durations |> filter(palveluluokka == .palveluluokka) |>
    ggplot(aes(x = time, y = value, color = group, shape = group)) +
    geom_line(size = line_width) +
    geom_point(size = point_size) +
    scale_color_manual(values = color_palette, labels = labels_duration_method) +
    scale_shape_manual(values = shapes, labels = labels_duration_method) +
    labs(x = NULL, y = "Keskimääräinen kesto, kk",
         color = NULL, shape = NULL) +
    facet_wrap(~lmp_name_fin, scales = "free_y") +
    theme_almpsfin(text_size)
}

write_selite <- function(.palveluluokka, df) {

  df <- df |> select(lmp_name_fin, table, type) |>
        left_join(select(eurostat_statfi_key, lmp_name_fin, palveluluokka), by = "lmp_name_fin") |>
        filter(palveluluokka == .palveluluokka) |>
        distinct()

  df_actual <- filter(df, type == "actual")
  df_computed <- filter(df, type == "computed")
  tables_actual <- unique(df_actual$table)
  tables_computed <- unique(df_computed$table)

 selite <- paste0("Datalähde: Tilastokeskus, todellinen: päättyneiden osallistumisten kesto tauluissa ", paste(tables_actual, collapse = ", "),
                   ". Tilastokeskus, laskettu: laskettu varanto- ja virtasuureista tauluissa ", paste(tables_computed, collapse = ", "), ".")
 selite <- gsub("_", "\\\\_", selite)
}

heights <- c("tyollistaminen" = 8, "valmennus" = 8, "kokeilu" = 4, "muu" = 4)
data("datalahde_durations")

for(luokka in unique(eurostat_statfi_key$palveluluokka)) {

  plot_kestot(luokka)
  ggsave(paste0("plots/durations/", luokka, ".pdf"), width = 10, height = heights[luokka])
  selite <- write_selite(luokka, datalahde_durations)
  stringi::stri_write_lines(selite, paste0("plots/durations/", luokka, "_selite.txt"))

}

