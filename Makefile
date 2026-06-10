######################
#      Makefile      #
######################

filename=resume_cv
output_filename=Michael_Woods_Resume.pdf

pdf:
	xelatex ${filename}
	xelatex ${filename}

text: html
	html2text -width 100 -style pretty ${filename}/${filename}.html | sed -n '/./,$$p' | head -n-2 >${filename}.txt

html:
	@#latex2html -split +0 -info "" -no_navigation ${filename}
	htlatex ${filename}

view:
	while inotifywait --event modify,move_self,close_write ${filename}.tex; \
		do xelatex -halt-on-error ${filename} &&   xelatex -halt-on-error \
		${filename}; done

clean:
	rm -f ${filename}.{ps,log,aux,out,dvi,bbl,blg,snm,toc,nav,fdb_latexmk,fls} -rf aux
docker:
	docker run --rm -v "$(PWD):/src" -w /src -u "$(id -u):$(id -g)" kjarosh/latex:2025.1-full latexmk -pdfxe -outdir=pdf -auxdir=aux ${filename}.tex ${output_filename}
monitor:
	docker run --rm -v "$(PWD):/src" -w /src -u "$(id -u):$(id -g)" kjarosh/latex:2025.1-full latexmk -pdfxe -outdir=pdf -auxdir=aux ${filename}.tex -pvc
