data(participation_costs)
key <- distinct(select(eurostat_statfi_key, LMP_TYPE, palveluluokka, lmp_name_fin))
participation_costs <- left_join(participation_costs, key, by = "LMP_TYPE") |> filter_years()

plot_participation_costs_robustness <- function(.palveluluokka,
                                                     point_size = 4, line_width = 1, text_size = 15) {

  participation_costs |>
    filter(palveluluokka == .palveluluokka) |>
    ggplot(aes(x = time, y = value, color = group, shape = group)) +
    geom_line(size = line_width) +
    geom_point(size = point_size) +
    scale_y_continuous(labels = axis_text_format) +
    scale_color_manual(values = color_palette, labels = labels_duration_method) +
    scale_shape_manual(values = shapes, labels = labels_duration_method) +
    labs(x = NULL, y = "Osallistumisen \n kokonaiskustannus, euroa",
         color = "Keston laskutapa", shape = "Keston laskutapa") +
    geom_hline(yintercept = 0, color = "black", linetype = "dashed") +
    facet_wrap(~lmp_name_fin, scales = "free_y") +
    theme_almpsfin(text_size) +
    guides(color = guide_legend(nrow = 2),
           shape = guide_legend(nrow = 2))
}

heights <- c("tyollistaminen" = 8, "valmennus" = 8, "kokeilu" = 4, "muu" = 4)

for(luokka in unique(eurostat_statfi_key$palveluluokka)) {

  plot_participation_costs_robustness(luokka)
  ggsave(paste0("plots/costs/", luokka, "_robustness.pdf"), width = 10, height = heights[luokka])

}
