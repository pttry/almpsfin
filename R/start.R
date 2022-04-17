data("eurostat_statfi_key")
tutkittavat_palvelut <-  c("Työvoimakoulutus",  "Starttiraha", "Palkkatuki yksityiselle", "Palkkatuki kunnalle",
                           "Työnhakuvalmennus", "Uravalmennus", "Työhönvalmennus",
                           "Koulutuskokeilu", "Työkokeilu",#"Rekrytointikokeilu",
                           "Kuntouttava työtoiminta", "Omaehtoinen opiskelu työttömyysetuudella",
                           "Oppisopimuskoulutus työttömille")
theme_set(theme_bw() +
          theme(legend.position = "bottom"))
arvioitavat_vuodet = list("kuntouttava_tyotoiminta" = 2012:2017,
                          "omaehtoinen_opiskelu" = 2012:2017,
                          "palkkatuki_kunta" = 2005:2017,
                          "palkkatuki_yksityinen" = 2005:2017,
                          "starttiraha" = 2005:2017,
                          "tyovoimakoulutus" = 2005:2017,
                          "valmennus_tai_kokeilu" = 2012:2017)

ggplot2::theme_update(legend.position = "bottom",
                      #legend.justification = "left",
                      legend.title = element_text(size = 15),
                      legend.text = element_text(size = 15),
                      axis.title = element_text(size = 15),
                      axis.text = element_text(size = 15),
                      strip.text = element_text(size = 15))

update_geom_defaults("line", list(size = 1))
update_geom_defaults("text", list(color = "black", size = 6))

color_palette <- c("#F8766D", "#00BA38", "#619CFF",  "#C77CFF", "#93AA00")
shapes <- c(15,16,17,18,8)
