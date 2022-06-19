data(lmp_expenditures)
data(lmp_participants)

lmp_expenditures <- lmp_expenditures |>
  mutate(value = adj_inflation(value, time, year = 2021))

lmp_participants <- filter_years(lmp_participants)

plot_tot_expenditures_per_STK <- function(.palveluluokka, palveluluokka_name = deparse(substitute(.palveluluokka)),
                                          point_size = 2, line_width = 1) {

  lmp_participants |>
    select(STK_FLOW, LMP_TYPE, time, value) |>
    spread(STK_FLOW, value) |>
    right_join(lmp_expenditures, by = c("LMP_TYPE", "time")) |>
    filter(EXPTYPE == "XTOT") |>
    mutate(exp_per_STK = value * 10^6 / STK) |>
    left_join(distinct(select(eurostat_statfi_key, LMP_TYPE, palveluluokka)), by = "LMP_TYPE") |>
    filter(lmp_name_fin %in% tutkittavat_palvelut, palveluluokka == .palveluluokka, time >= 2005) |>
    mutate(exp_per_STK = ifelse(exp_per_STK == 0, NA, exp_per_STK)) |>
    ggplot(aes(x = time, y = exp_per_STK, col = lmp_name_fin, shape = lmp_name_fin)) +
    geom_line(size = line_width) +
    geom_point(size = point_size) +
    scale_x_continuous(breaks = seq(2005,2019, by = 2)) +
    scale_y_continuous(labels = axis_text_format) +
    labs(x = NULL, y = "Vuosikustannus per STK, euroa",
         color = palveluluokka_name, shape = palveluluokka_name) +
    # coord_cartesian(ylim = c(0,30000)) +
    geom_hline(yintercept = 0, color = "black", linetype = "dashed") +
    theme(legend.box = "vertical",
          legend.box.just = "left",
          legend.position = "bottom")

}

point_size = 4
line_width = 1.5
p2 <- plot_tot_expenditures_per_STK("tyollistaminen", "Työllistäminen", point_size, line_width) + guides(color = guide_legend(nrow = 2), shape = guide_legend(nrow = 2))
p3 <- plot_tot_expenditures_per_STK("valmennus", "Valmennukset",  point_size, line_width)
p4 <- plot_tot_expenditures_per_STK("kokeilu", "Kokeilut", point_size, line_width)
p5 <- plot_tot_expenditures_per_STK("muu", "Muut palvelut",  point_size, line_width) + guides(color = guide_legend(nrow = 2), shape = guide_legend(nrow = 2))

p <- gridExtra::grid.arrange(p2, p3, p4, p5, ncol = 1)
save_plot("aikakustannukset", plot = p, width = 10, height = 15)
