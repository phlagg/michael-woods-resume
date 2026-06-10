######################
#      Makefile      #
######################

filename=resume_cv
output_filename=Michael_Woods$(shell date +'_%b%Y')

# Standard Docker container execution wrapper
DOCKER_RUN = docker run --rm -v "$(PWD):/src" -w /src -u "$(shell id -u):$(shell id -g)" michael-woods-resume-latex-builder

.PHONY: pdf monitor text clean

# 1. Compile the PDF with proper date suffix and layout formatting
pdf: clean
	$(DOCKER_RUN) latexmk -pdfxe -cd -jobname=$(output_filename) -interaction=nonstopmode -outdir=out -auxdir=aux $(filename).tex

# 2. Continuous live preview (watches files and auto-updates the PDF)
monitor:
	$(DOCKER_RUN) latexmk -pdfxe -cd -jobname=$(output_filename) -pvc -interaction=nonstopmode -outdir=out -auxdir=aux $(filename).tex

# 3. Generate clean, unformatted plain text layout
text: pdf
	$(DOCKER_RUN) pdftotext -layout out/$(output_filename).pdf out/$(output_filename).txt

# 4. Clean up all generated assets and logging folders
clean:
	rm -f ${filename}.{ps,log,aux,out,dvi,bbl,blg,snm,toc,nav,fdb_latexmk,fls}
	rm -rf aux out
