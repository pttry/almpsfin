data("eurostat_statfi_key")

palveluiden_vuodet = list("Kuntouttava työtoiminta" = 2006:2020,
                          "Omaehtoinen opiskelu työttömyysetuudella" = 2010:2020,
                          "Palkkatuki kunnalle" = 1997:2020,
                          "Palkkatuki yksityiselle" = 1997:2020,
                          "Starttiraha" = 1997:2020,
                          "Työvoimakoulutus" = 1997:2020,
                          "Koulutuskokeilu" = 2014:2020,
                          "Työkokeilu" = 2013:2020,
                          "Työelämävalmennus" = 2006:2014,
                          "Työhönvalmennus" = 2013:2020,
                          "Uravalmennus" = 2013:2020,
                          "Työnhakuvalmennus" = 2013:2020,
                          "Oppisopimuskoulutus työttömille" = 1997:2018)

color_palette <- c("#F8766D", "#00BA38", "#619CFF",  "#C77CFF", "#93AA00")
shapes <- c(15,16,17,18,8)

labels_duration_method = c("Tilastokeskus, todellinen", "Tilastokeskus, laskettu", "Euroopan komissio, laskettu")

