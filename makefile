ALL: mapsR.pdf

mapsR.pdf: mapsR.Rmd
	Rscript --no-init-file -e "rmarkdown::render('mapsR.Rmd', 'all')"
