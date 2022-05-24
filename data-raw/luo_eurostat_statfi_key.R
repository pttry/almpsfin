# luokat lmp_name_fin-muuttujassa tulevat TEM:ltä saadusta avaimesta.

eurostat_statfi_key <- tibble::tribble(
      ~LMP_TYPE,   ~code_statfi,    ~lmp_name_fin,                                      ~palveluluokka,
      "21_FI6",         "0",            "Työvoimakoulutus",                             "muu", # "tyovoimakoulutus",   # Normaali koulutus
      "21_FI6",         "1",            "Työvoimakoulutus",                             "muu", # "tyovoimakoulutus",   # Valtionosuuskoulutus(VOS)
      "7_FI11",         "65",           "Starttiraha",                                  "tyollistaminen",
      "7_FI11",         "62",           "Starttiraha",                                  "tyollistaminen",
      "7_FI55",         "61",           "Starttiraha ei-työttömille",                   "tyollistaminen",
      "24_FI7",         "51",           "Oppisopimuskoulutus työttömille",              "tyollistaminen",
      "24_FI7",         "55",           "Oppisopimuskoulutus työttömille",              "tyollistaminen",
      "24_FI7",         "56",           "Oppisopimuskoulutus työttömille",              "tyollistaminen",
      "24_FI7",         "58",           "Oppisopimuskoulutus työttömille",              "tyollistaminen",
      "24_FI7",         "68",           "Oppisopimuskoulutus työttömille",              "tyollistaminen",
      "24_FI7",         "87",           "Oppisopimuskoulutus työttömille",              "tyollistaminen",
      "24_FI7",         "88",           "Oppisopimuskoulutus työttömille",              "tyollistaminen",
      "24_FI7",         "89",           "Oppisopimuskoulutus työttömille",              "tyollistaminen",
      "41_FI10",        "80",           "Palkkatuki yksityiselle",                      "tyollistaminen",
      "41_FI10",        "81",           "Palkkatuki yksityiselle",                      "tyollistaminen",
      "41_FI10",        "6T",           "Palkkatuki yksityiselle",                      "tyollistaminen",
      "41_FI10",        "6V",           "Palkkatuki yksityiselle",                      "tyollistaminen",
      "41_FI10",        "60",           "Palkkatuki yksityiselle",                      "tyollistaminen",
      "41_FI10",        "69",           "Palkkatuki yksityiselle",                      "tyollistaminen",
      "6_FI9",          "54",           "Palkkatuki kunnalle",                          "tyollistaminen",
      "6_FI9",          "57",           "Palkkatuki kunnalle",                          "tyollistaminen",
      "6_FI9",          "5T",           "Palkkatuki kunnalle",                          "tyollistaminen",
      "6_FI9",          "5V",           "Palkkatuki kunnalle",                          "tyollistaminen",
      "6_FI9",          "53",           "Palkkatuki kunnalle",                          "tyollistaminen",
      "6_FI9",          "50",           "Palkkatuki kunnalle",                          "tyollistaminen",
      "6_FI8",          "40",           "Valtiolle työllistäminen",                     "tyollistaminen",
      "6_FI8",          "41",           "Valtiolle työllistäminen",                     "tyollistaminen",
      "11_FI59",        "3",            "Työnhakuvalmennus",                            "valmennus",
      "11_FI60",        "5",            "Uravalmennus",                                 "valmennus",
      "11_FI61",        "4",            "Työhönvalmennus",                              "valmennus",
      "21_FI63",        "36",           "Koulutuskokeilu",                              "kokeilu",
      "22_FI62",        "20",           "Työkokeilu",                                   "kokeilu",
      "22_FI62",        "21",           "Työkokeilu",                                   "kokeilu",
      "22_FI66",        "22",           "Rekrytointikokeilu",                           "kokeilu",
      "6_FI36",         "05",           "Kuntouttava työtoiminta",                      "muu",
      "21_FI17",        "06",           "Omaehtoinen opiskelu työttömyysetuudella",     "muu",
      "43_FI16",        "02",           "Työnvuorottelu",                               "muu",
      "22_FI12",        "71",           "Työelämävalmennus",                            "valmennus",
      "22_FI12",        "64",           "Työelämävalmennus",                            "valmennus",
      "22_FI15",        "70",           "Työharjoittelu",                               "tyollistaminen",
      "43_FI13",        "73",           "Osa-aikatyöllistetty",                        "tyollistaminen"

)

usethis::use_data(eurostat_statfi_key, overwrite = TRUE)
