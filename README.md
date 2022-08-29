# almpsfin
Euroopan komission Työllisyys, sosiaaliasiat ja osallisuus -pääosasto kerää tietoa työvoimapalvelujen osallistujamääristä ja kustannuksista Euroopan unionissa. Tämä projekti, 

1. esittää kuinka Euroopan komission aineiston työvoimapalvelujen luokitus vastaa Tilastokeskuksen StatFin-palvelun työvoimapalvelujen luokitusta: [https://github.com/pttry/almpsfin/blob/main/text/palvelut_key.pdf](https://github.com/pttry/almpsfin/blob/main/text/palvelut_key.pdf)

2. laskee ja esittää eri työvoimapalvelujen kokonais- ja osallistumiskohtaiset kustannukset: [https://github.com/pttry/almpsfin/blob/main/text/kustannukset.pdf](https://github.com/pttry/almpsfin/blob/main/text/kustannukset.pdf)

Aineisto: [https://webgate.ec.europa.eu/empl/redisstat/databrowser/product/page/LMP_EXPME$FI](https://webgate.ec.europa.eu/empl/redisstat/databrowser/product/page/LMP_EXPME$FI)

Metadata: [https://ec.europa.eu/employment_social/employment_analysis/lmp/lmp_esms.htm](https://ec.europa.eu/employment_social/employment_analysis/lmp/lmp_esms.htm)

Menetelmät: [https://ec.europa.eu/social/main.jsp?catId=738&langId=en&pubId=8126&furtherPubs=yes](https://ec.europa.eu/social/main.jsp?catId=738&langId=en&pubId=8126&furtherPubs=yes)

Paketti ladataan ja asennetaan seuraavasti:

``` r
install.packages("devtools")
devtools::install_github("https://github.com/pttry/pttdatahaku")
library(pttdatahaku)
```
