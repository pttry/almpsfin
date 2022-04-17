get_statfi_data <- function(url, query){

  px_data <- pxweb::pxweb_get(url = url, query = query)

  codes_names <-   purrr::map(rlang::set_names(px_data$pxweb_metadata$variables,
                                               sapply(px_data$pxweb_metadata$variables, "[[", "code")),
                              ~rlang::set_names(.x$valueTexts, .x$values))

  to_name <- names(codes_names)


  px_df <- as.data.frame(px_data,
                         column.name.type = "code",
                         variable.value.type = "code") %>%

  # All longer
    tidyr::pivot_longer(where(is.numeric),
                        names_to = setdiff(names(codes_names), names(.)),
                        values_to = "values") %>%
    statfitools::clean_times2() %>%
    codes2names(codes_names, to_name) %>%
    dplyr::mutate(across(where(is.character), ~forcats::as_factor(.x))) %>%
    statfitools::clean_names() %>%
    relocate(time) %>%
    relocate(values, .after = last_col()) %>%
    droplevels()

  px_df
}

codes2names <- function(.data, codes_names, to_name = names(codes_names)){
  .data <- dplyr::mutate(.data, across(any_of(to_name) & where(is.character),
                                       ~factor(.x,
                                               levels = names(codes_names[[cur_column()]]),
                                               labels = codes_names[[cur_column()]]),
                                       .names = "{.col}_name"))

  .data <- dplyr::rename_with(.data, .cols = any_of(to_name) & where(is.character), ~paste0(.x, "_code"))
  dplyr::mutate(.data, across(contains("_code"), ~forcats::as_factor(.x)))
}



