# R/Pandoc/Latex make file, see README.md for details

SHELL=/bin/bash

BUILDDIR=/tmp/latex-build$(subst /,-,$(abspath .))
BIBSOURCE=
COPYPDF=yes
LATEX=pdflatex

# To customize, copy Makefile.local-example to Makefile.local
-include Makefile.local

LATEXOPTIONS=--synctex=1 -shell-escape -interaction=nonstopmode -output-directory=$(BUILDDIR)
LATEXCMD=TEXINPUTS=$(BUILDDIR):figures: $(LATEX) $(LATEXOPTIONS)
BIBTEXCMD=BIBINPUTS=$(BUILDDIR): openout_any=a bibtex
EPSTOPDFCMD=mkdir -p $(BUILDDIR) && epstopdf $< --outfile $@
EPSTOPNGCMD=mkdir -p $(BUILDDIR) && convert $< $@
TIKZTOTEXCMD=( \
	echo '\documentclass[9pt]{scrartcl}'; \
	echo '\usepackage{color}'; \
	echo '\usepackage{tikz}'; \
	echo '\pagestyle{empty}'; \
	echo '\setlength{\hoffset}{-1in}'; \
	echo '\setlength{\voffset}{-1in}'; \
	echo '\setlength{\oddsidemargin}{0pt}'; \
	echo '\setlength{\topmargin}{0pt}'; \
	echo '\setlength{\headheight}{0pt}'; \
	echo '\setlength{\headsep}{0pt}'; \
	echo '\setlength{\footskip}{0pt}'; \
	echo '\setlength{\marginparsep}{0pt}'; \
	echo '\setlength{\marginparwidth}{0pt}'; \
	echo '\setlength{\textwidth}{\paperwidth}'; \
	echo '\setlength{\textheight}{\paperheight}'; \
	echo '\usetikzlibrary{snakes}'; \
	echo '\usetikzlibrary{shapes}'; \
	echo '\usetikzlibrary{patterns}'; \
	echo '\usetikzlibrary{backgrounds}'; \
	echo '\usetikzlibrary{calc}'; \
	echo '\usetikzlibrary{through}'; \
	echo '\usetikzlibrary{intersections}'; \
	echo '\usetikzlibrary{circuits.ee.IEC}'; \
	echo '\colorlet{mygray}{black!25}'; \
	echo '\begin{document}'; \
	echo '\input{$(<F)}'; \
	echo '\end{document}'; \
    ) > $@
PDFPDFPICTURES=$(wildcard *.pdf figures/*.pdf)
EPSPDFPICTURES=$(patsubst %.eps,$(BUILDDIR)/%.pdf,$(notdir $(wildcard *.eps figures/*.eps)))
EPSPNGPICTURES=$(patsubst %.eps,$(BUILDDIR)/%-png.png,$(notdir $(wildcard *.eps figures/*.eps)))
TIKZPDFPICTURES=$(patsubst %.tikz,$(BUILDDIR)/%.pdf,$(notdir $(wildcard *.tikz figures/*.tikz)))
MDSOURCES=$(sort $(basename $(wildcard *.Rmd)) $(basename $(wildcard *.markdown)) $(basename $(wildcard *.tex)))

all: pdflatex

pdflatex: pdflatex-all
pdfview: pdfview-all
clean: clean-all
ondemand: ondemand-all

pdflatex-all: $(MDSOURCES:%=pdflatex-%)
pdfview-all: $(MDSOURCES:%=pdfview-%)
clean-all: $(MDSOURCES:%=clean-%)

builddir:
	@echo $(BUILDDIR)/

.SECONDARY: $(PDFPDFPICTURES) $(EPSPNGPICTURES) $(EPSPDFPICTURES) $(TIKZPDFPICTURES) $(MDSOURCES:%=%.tex) $(MDSOURCES:%=%.markdown)

# No idea why MAKEFLAGS need to be reset, but otherwise the ondemand build below fails
%.markdown: %.Rmd
	MAKEFLAGS= R -e 'input <- "$<"; make <- FALSE; source("templates/makefile-renderer.R", local=TRUE)'

%.tex: %.markdown
	mkdir -p $(BUILDDIR)
	sed "/^%% /d" $*.markdown > $(BUILDDIR)/$*.markdown
	pandoc -s $$(grep -h '^%% ' $*.markdown | sed 's/^%% /--/') $(BUILDDIR)/$*.markdown -o $*.tex

pdflatex-%: %.tex $(PDFPDFPICTURES) $(EPSPDFPICTURES) $(TIKZPDFPICTURES) $(BUILDDIR)/parsed-references.bib
	mkdir -p $(BUILDDIR)
	-$(LATEXCMD) $*.tex
	-for i in "$(BUILDDIR)/$*"*.aux; do $(BIBTEXCMD) "$$i"; done
	-if [[ "$(COPYPDF)" = "yes" ]]; then cp $(BUILDDIR)/$*.pdf .; fi

pdfview-%: %.pdf
	xdg-open $(BUILDDIR)/$*.pdf &

ondemand-%:
	GREEN=`tput setaf 2`; \
	NORMAL=`tput sgr0`; \
	VIEW=pdfview-$*; \
	inotifywait . -q -e close_write -m --format "%w%f" \
	    | while read filename; do \
	    [[ "$$filename" =~ tmp-pdfcrop-.*\.tex$$ ]] && continue; \
	    [[ "$$filename" =~ ^\./[^.].*\.(tex|sty|Rmd|markdown|eps|tikz)|Makefile$$ ]] || continue; \
	    echo $${GREEN}Change detected in $$filename$${NORMAL}; \
	    while read -t 1 filename; do \
		echo $${GREEN}Change detected in $$filename$${NORMAL}; \
	    done; \
	    ionice -c 3 nice -n 19 make -j 4 pdflatex-$*; \
	    [ -n "$${VIEW}" ] && make $${VIEW}; \
	    VIEW=; \
	    while read -t 1 filename; do \
		echo Change detected in $$filename, ignored; \
	    done; \
	done

handouts-%:
	echo '\def\beamermode{handout}\input{$*.tex}' > $(BUILDDIR)/$*-handouts-helper.tex
	echo '\documentclass[a4paper]{article}\usepackage{pdfpages}\begin{document}\includepdf[pages=-,nup=2x3,frame=true,scale=.9,delta={.5cm .5cm}]{$*-handouts-helper}\end{document}' > $(BUILDDIR)/$*-handouts.tex
	-$(LATEXCMD) $(BUILDDIR)/$*-handouts-helper.tex
	-$(LATEXCMD) $(BUILDDIR)/$*-handouts.tex
	-for i in "$(BUILDDIR)/$*-handouts-helper"*.aux; do $(BIBTEXCMD) "$$i"; done
	-if [[ "$(COPYPDF)" = "yes" ]]; then cp $(BUILDDIR)/$*-handouts.pdf .; fi

a4version-%:
	gs -sDEVICE=png16m -dSAFER -dBATCH -dNOPAUSE -dTextAlphaBits=4 -dGraphicsAlphaBits=4 -sOutputFile="$(BUILDDIR)/$*-%03d.png" -r300 '$(BUILDDIR)/$*.pdf'
	PosteRazor $(BUILDDIR)/$*.png

ppt-%:
	rm -rf '$(BUILDDIR)/$*-ppt' '$(BUILDDIR)/$*.odp'
	mkdir '$(BUILDDIR)/$*-ppt' '$(BUILDDIR)/$*-ppt/Pictures' '$(BUILDDIR)/$*-ppt/META-INF'
	echo -n 'application/vnd.oasis.opendocument.presentation' > '$(BUILDDIR)/$*-ppt/mimetype'
	gs -sDEVICE=png16m -dSAFER -dBATCH -dNOPAUSE -dTextAlphaBits=4 -dGraphicsAlphaBits=4 -sOutputFile="$(BUILDDIR)/$*-ppt/Pictures/%03d.png" -r254 '$*.pdf'
	echo '<?xml version="1.0" encoding="UTF-8"?><manifest:manifest xmlns:manifest="urn:oasis:names:tc:opendocument:xmlns:manifest:1.0" manifest:version="1.2"><manifest:file-entry manifest:full-path="/" manifest:version="1.2" manifest:media-type="application/vnd.oasis.opendocument.presentation"/><manifest:file-entry manifest:full-path="content.xml" manifest:media-type="text/xml"/>' > '$(BUILDDIR)/$*-ppt/META-INF/manifest.xml'
	( cd $(BUILDDIR)/$*-ppt && for i in Pictures/*.png; do echo "<manifest:file-entry manifest:full-path='$$i' manifest:media-type='image/png'/>"; done ) >> '$(BUILDDIR)/$*-ppt/META-INF/manifest.xml'
	echo '</manifest:manifest>' >> '$(BUILDDIR)/$*-ppt/META-INF/manifest.xml'
	echo '<?xml version="1.0" encoding="UTF-8"?><office:document-content xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0" xmlns:draw="urn:oasis:names:tc:opendocument:xmlns:drawing:1.0" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:svg="urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0" office:version="1.2"><office:body><office:presentation>' > '$(BUILDDIR)/$*-ppt/content.xml'
	( cd $(BUILDDIR)/$*-ppt && for i in Pictures/*.png; do echo "<draw:page><draw:frame svg:width='28cm' svg:height='21cm'><draw:image xlink:href='$$i'></draw:image></draw:frame></draw:page>"; done ) >> '$(BUILDDIR)/$*-ppt/content.xml'
	echo '</office:presentation></office:body></office:document-content>' >> '$(BUILDDIR)/$*-ppt/content.xml'
	( cd '$(BUILDDIR)/$*-ppt' && zip '$(BUILDDIR)/$*.odp' -r . )
	soffice '-env:UserInstallation=file://$(BUILDDIR)' --headless --invisible --convert-to ppt --outdir '$(BUILDDIR)' '$(BUILDDIR)/$*.odp'
	-if [[ "$(COPYPDF)" = "yes" ]]; then cp $(BUILDDIR)/$*.ppt .; fi

clean-%:
	rm $*.pdf

$(BUILDDIR)/%.pdf: figures/%.eps
	$(EPSTOPDFCMD)

$(BUILDDIR)/%.pdf: %.eps
	$(EPSTOPDFCMD)

$(BUILDDIR)/%-png.png: figures/%.eps
	$(EPSTOPNGCMD)

$(BUILDDIR)/%-png.png: %.eps
	$(EPSTOPNGCMD)

$(BUILDDIR)/%.tikzdriver.pdf: $(BUILDDIR)/%.tikzdriver.tex
	-$(LATEXCMD) $<

$(BUILDDIR)/%.pdf: $(BUILDDIR)/%.tikzdriver.pdf
	pdfcrop $< $@

$(BUILDDIR)/%.tikzdriver.tex: figures/%.tikz
	$(TIKZTOTEXCMD)

$(BUILDDIR)/%.tikzdriver.tex: %.tikz
	$(TIKZTOTEXCMD)

references.bib: $(BIBSOURCE)
	if [[ -n "$<" ]]; then \
	    cp "$<" $@; \
	fi

$(BUILDDIR)/parsed-references.bib: references.bib
	mkdir -p $(BUILDDIR)
	cat $^ \
	    | perl -p0e 's/\n/|/g;s/^@|\|@/\n@/g' \
	    | grep '@' \
	    | sort -u \
	    | sed 's/|/\n/g' \
	    | sed 's/pmid = {\(.*\)}/eprinttype = {pubmed},\neprint = {\1}/g' \
	    > $@

regenerate-latex-templates: presentation-latex poster-latex report-latex abstract-latex

presentation-latex:
	( \
	    echo '---'; \
	    echo 'title: Title'; \
	    echo 'author: [Author 1, Author 2]'; \
	    echo 'date: Date'; \
	    echo 'institute: institute name'; \
	    echo 'toc: true'; \
	    echo '---'; \
	    echo ''; \
	    echo '%% smart'; \
	    echo '%% to=beamer'; \
	    echo '%% slide-level 3'; \
	    echo '%% template=templates/presentation.tex'; \
	    echo ''; \
	    echo '# First Section'; \
	    echo ''; \
	    echo '### First slide'; \
	) > $@.markdown
	-make $@.tex
	-rm $@.markdown

poster-latex:
	( \
	    echo '---'; \
	    echo 'title: Title'; \
	    echo 'author: [Author 1, Author 2]'; \
	    echo 'email: author@university.edu'; \
	    echo 'institute: institute name'; \
	    echo 'longinstitute: long institute name'; \
	    echo 'web: university.edu'; \
	    echo '---'; \
	    echo ''; \
	    echo '%% smart'; \
	    echo '%% to=latex'; \
	    echo '%% filter=templates/poster-filters.py'; \
	    echo '%% template=templates/poster.tex'; \
	    echo ''; \
	    echo '[columns=2]'; \
	    echo ''; \
	    echo '[column]'; \
	    echo ''; \
	    echo '# First block'; \
	    echo ''; \
	    echo '[column]'; \
	    echo ''; \
	    echo '[/columns]'; \
	) > $@.markdown
	-make $@.tex
	-rm $@.markdown

report-latex:
	( \
	    echo '---'; \
	    echo 'title: Title'; \
	    echo 'author: [Author 1, Author 2]'; \
	    echo 'date: Date'; \
	    echo '---'; \
	    echo ''; \
	    echo '%% smart'; \
	    echo '%% to=latex'; \
	    echo '%% template=templates/report.tex'; \
	    echo ''; \
	    echo '# First Section'; \
	    echo ''; \
	    echo '## First subsection'; \
	) > $@.markdown
	-make $@.tex
	-rm $@.markdown

abstract-latex:
	( \
	    echo '---'; \
	    echo 'title: Title'; \
	    echo 'author: [Author 1, Author 2]'; \
	    echo 'institute: Institute, Dept., University'; \
	    echo '---'; \
	    echo ''; \
	    echo '%% smart'; \
	    echo '%% to=latex'; \
	    echo '%% template=templates/abstract.tex'; \
	) > $@.markdown
	-make $@.tex
	-rm $@.markdown
