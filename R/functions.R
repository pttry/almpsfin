axis_text_format <- function(x) {
  ifelse(x <= 1, format(x, decimal.mark = ",", scientific = FALSE, trim = TRUE),
                 format(x, big.mark = " "))
}

adj_inflation <- function(x, time, year = NULL) {

  pxweb_query_list <-  list("Vuosi"=c("*"), "Tiedot"=c("*"))
  px_data <-
    pxweb::pxweb_get(url = "https://pxnet2.stat.fi/PXWeb/api/v1/fi/StatFin/hin/khi/vv/statfin_khi_pxt_11xm.px",
                     query = pxweb_query_list)
  indeksi <- as.data.frame(px_data, column.name.type = "text", variable.value.type = "text")
  if(is.null(year)) year <- tail(indeksi$Vuosi, 1)

  indeksi$Pisteluku <- indeksi$Pisteluku / indeksi$Pisteluku[indeksi$Vuosi == year]
  indeksi <- indeksi[match(time, indeksi$Vuosi), ]

  x / indeksi$Pisteluku


}

filter_years <- function(data) {

  new_data <- data.frame()

  for(palvelu in unique(data$lmp_name_fin)) {
    data_temp <- data |> filter(lmp_name_fin == palvelu, time %in% unlist(palveluiden_vuodet[palvelu]))
    new_data <- rbind(new_data, data_temp)
  }
  new_data
}

theme_almpsfin <- function(text_size = 15) {
  list(theme_bw(),
       theme(legend.box = "vertical",
             legend.box.just = "left",
             legend.position = "bottom",
             legend.justification = "left",
             legend.title = element_text(size = text_size),
             legend.text = element_text(size = text_size),
             axis.title = element_text(size = text_size),
             axis.text = element_text(size = text_size),
             strip.text = element_text(size = text_size, hjust = 0),
             strip.background = element_blank()))
}
