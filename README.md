# Edit and create maps with R

Originally, I created this repository to gather material about the creation
and edition of maps with R. Well, things have dramatically changed recently,
[sf](https://github.com/r-spatial/sf) has become the new standard for vector
files and so the document is a bit outdated (there is still some relevant
material though).

Now, I use this repository to edit a short & sweet tutorial about how
to turn R as a GIS and listing valuable resources:

- I participated to the creation of this online tutorial: https://insileco.github.io/tuto/rinspace/rinspace_homepage/
- https://geocompr.robinlovelace.net/
- http://rspatial.org/intr/index.html
- https://freegisdata.rtwilson.com/


## How to obtain the practical guide from the Rmd file

Use the R code below

```R
install.packages("rmarkdown")
# pdf
rmarkdown::render("pathto/MapswithR/mapsR.Rmd", "pdf_document")
# html
rmarkdown::render("pathto/MapswithR/mapsR.Rmd", "html_document")
# both
rmarkdown::render("pathto/MapswithR/mapsR.Rmd", "all")
```

or the makefile

```sh
make
```

Last compilation of the document on November 6th, 2018, `sessionInfo()` is
provided below.

<details>
```R
R> sessionInfo()
R version 3.5.1 (2018-07-02)
Platform: x86_64-pc-linux-gnu (64-bit)
Running under: Debian GNU/Linux buster/sid

Matrix products: default
BLAS: /usr/lib/x86_64-linux-gnu/openblas/libblas.so.3
LAPACK: /usr/lib/x86_64-linux-gnu/libopenblasp-r0.3.3.so


locale:
 [1] LC_CTYPE=en_US.UTF-8       LC_NUMERIC=C               LC_TIME=en_CA.UTF-8        LC_COLLATE=en_US.UTF-8     LC_MONETARY=en_CA.UTF-8
 [6] LC_MESSAGES=en_US.UTF-8    LC_PAPER=en_CA.UTF-8       LC_NAME=C                  LC_ADDRESS=C               LC_TELEPHONE=C
[11] LC_MEASUREMENT=en_CA.UTF-8 LC_IDENTIFICATION=C

attached base packages:
[1] methods   datasets  stats     graphics  grDevices utils     base

other attached packages:
 [1] rgdal_1.3-6         rgeos_0.3-28        raster_2.8-4        sp_1.3-1            magrittr_1.5        graphicsutils_1.2-0
 [7] knitr_1.20          rmarkdown_1.10      devtools_1.13.6     inSilecoMisc_0.1.2

loaded via a namespace (and not attached):
 [1] Rcpp_0.12.19     codetools_0.2-15 lattice_0.20-38  digest_0.6.18    crayon_1.3.4     withr_2.1.2      rprojroot_1.3-2  grid_3.5.1

 [9] backports_1.1.2  evaluate_0.12    tools_3.5.1      compiler_3.5.1   memoise_1.1.0    htmltools_0.3.6
```
</details>
