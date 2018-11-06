getdoc:
	Rscript --no-init-file -e "rmarkdown::render('mapsR.Rmd', 'all')"

pres:
	cd docs; \
	Rscript --no-init-file  -e 'rmarkdown::render("index.Rmd", "all")'

buildcsv:
	ssconvert -S docs/data/megantic_soil_SIG.xlsx docs/data/%s.csv
