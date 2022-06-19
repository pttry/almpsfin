data(lmp_expenditures)
lmp_expenditures <- lmp_expenditures |>
  mutate(value = adj_inflation(value, time, year = 2021))

plot_tot_expenditures <- function(.palveluluokka, palveluluokka_name = deparse(substitute(.palveluluokka)),
                                  point_size = 2, line_width = 1) {

  lmp_expenditures  |>
    filter(EXPTYPE == "XTOT") |>
    left_join(distinct(select(eurostat_statfi_key, LMP_TYPE, palveluluokka)), by = "LMP_TYPE") |>
    filter(lmp_name_fin %in% tutkittavat_palvelut, palveluluokka == .palveluluokka, time >= 2005) |>
    mutate(value = ifelse(value == 0, NA, value)) |>
    ggplot(aes(x = time, y = value, col = lmp_name_fin, shape = lmp_name_fin)) +
    geom_line(size = line_width) +
    geom_point(size = point_size) +
    scale_x_continuous(breaks = seq(2005,2019, by = 2)) +
    geom_hline(yintercept = 0, color = "black", linetype = "dashed") +
    labs(x = NULL, y = "Kokonaisvuosikustannus \n (milj. euroa)",
         color = palveluluokka_name, shape = palveluluokka_name) +
    theme(legend.box = "vertical",
          legend.box.just = "left",
          legend.position = "bottom")

}

point_size = 4
line_width = 1
p2 <- plot_tot_expenditures("tyollistaminen", "Työllistäminen", point_size, line_width) + guides(color = guide_legend(nrow = 2), shape = guide_legend(nrow = 2))
p3 <- plot_tot_expenditures("valmennus", "Valmennukset", point_size, line_width)
p4 <- plot_tot_expenditures("kokeilu", "Kokeilut", point_size, line_width)
p5 <- plot_tot_expenditures("muu", "Muut palvelut", point_size, line_width) + guides(color = guide_legend(nrow = 2), shape = guide_legend(nrow = 2))

p <- gridExtra::grid.arrange(p2, p3, p4, p5, ncol = 1)

save_plot("kokonaiskustannukset", plot = p, width = 10, height = 15)

