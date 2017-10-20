ALL: mapsR.pdf

mapsR.pdf: mapsR.Rmd
	Rscript --no-init-file -e "rmarkdown::render('mapsR.Rmd', 'all')"


pres:
	cd docs; \
	Rscript --no-init-file  -e 'rmarkdown::render("index.Rmd", "all")'
