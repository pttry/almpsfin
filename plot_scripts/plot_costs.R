plot_costs_by_palveluluokka <- function(.palveluluokka, df, y_lab = NULL,
                                        point_size = 4, line_width = 1, text_size = 15) {

  palveluluokka_name <- unique(filter(eurostat_statfi_key, palveluluokka == .palveluluokka)$palveluluokka_name)

  key <- distinct(select(eurostat_statfi_key, LMP_TYPE, palveluluokka, lmp_name_fin))
  df <- left_join(df, key, by = "LMP_TYPE") |> filter_years()

  x_range <- range(df$time)

  df |>
    filter(palveluluokka == .palveluluokka) |>
    ggplot(aes(x = time, y = value, col = lmp_name_fin, shape = lmp_name_fin)) +
    geom_line(size = line_width) +
    geom_point(size = point_size) +
    scale_x_continuous(breaks = seq(min(x_range), max(x_range), by = 2)) +
    scale_y_continuous(labels = axis_text_format) +
    scale_color_manual(values = color_palette) +
    scale_shape_manual(values = shapes) +
    coord_cartesian(xlim = x_range) +
    labs(x = NULL, y = y_lab,
         color = palveluluokka_name, shape = palveluluokka_name) +
    geom_hline(yintercept = 0, color = "black", linetype = "dashed") +
    theme_almpsfin(text_size) +
    guides(color = guide_legend(ncol = 2),
           shape = guide_legend(ncol = 2))
}

data(participation_costs)
participation_costs <- filter(participation_costs, group == "computed_Euroopan komissio")
p <- lapply(unique(eurostat_statfi_key$palveluluokka), plot_costs_by_palveluluokka,
            participation_costs, "Osallistumisen \n kokonaiskustannus, euroa")
p <- ggpubr::ggarrange(plotlist = p, ncol = 1)
ggsave(paste0("plots/costs/participation_costs.pdf"), width = 10, height = 15)

data(total_costs)
p <- lapply(unique(eurostat_statfi_key$palveluluokka), plot_costs_by_palveluluokka,
            total_costs, "Kokonaisvuosikustannus \n (milj. euroa)")
p <- ggpubr::ggarrange(plotlist = p, ncol = 1)
ggsave(paste0("plots/costs/total_costs.pdf"), width = 10, height = 15)

data(annual_per_stock_costs)
p <- lapply(unique(eurostat_statfi_key$palveluluokka), plot_costs_by_palveluluokka,
            annual_per_stock_costs, "Vuosikustannus per STK, euroa")
p <- ggpubr::ggarrange(plotlist = p, ncol = 1)
ggsave(paste0("plots/costs/annual_per_stock_costs.pdf"), width = 10, height = 15)

