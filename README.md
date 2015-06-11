# KU Leuven Markdown templates

Latest version and bugreports on Github: <https://github.com/exporl/kuleuven-templates/>

This repository contains markdown templates for presentations and posters according to the KU Leuven Corporate Design.
Next to the actual templates, a build system based on R/pandoc/texlive/make is provided.

Examples:

- presentation: [presentation-example.pdf](presentation-example.pdf)
- poster: [poster-example.pdf](poster-example.pdf)
- poster with R figures: [poster-r-example.pdf](poster-r-example.pdf)
- paper with R figures: [paper-r-example.pdf](paper-r-example.pdf)

Pull requests welcome!

## R Markdown

If you are using Markdown with R and/or [RStudio](http://rstudio.com/), you can also use the pandoc support of RMarkdown to create presentations or posters.
See [poster-r-example.Rmd](poster-r-example.Rmd) and [paper-r-example.Rmd](paper-r-example.Rmd) for examples.
If you are using RStudio, you can just click the `Knit` button to compile your markdown document.

## Markdown or Latex

You can also stick with Latex and not use Markdown.
In this case, just use the latex versions to get started.

- presentation: [presentation-latex.tex](presentation-latex.tex)
- poster: [poster-latex.tex](poster-latex.tex)

## Linux installation

If you only want to use the templates (without history), use

    git clone --depth=1 https://github.com/mh21/kuleuven-templates && rm -rf kuleuven-templates/.git*

Install dependencies:

    sudo apt-get install pandoc python-pandocfilters gpp make texlive texlive-latex-recommended texlive-science texlive-bibtex-extra

For building your documents:

    make

To automatically watch for changes and rebuild as required:

    make ondemand

See the top of Makefile for more information.

## Windows installation

There is an automatic installer available in the windows-installer directory. To
make it work, the following files need to be present:

    pandoc-1.13.2-windows.msi
    sublime-2-x64.exe
    SublimeOnSaveBuild.zip
    SumatraPDF-3.0-install.exe
    latex-markdown-templates.zip
    texmakerwin32_install.exe
    cygwin-setup-x86_64.exe
    gpp.exe

Check the following sections on where to find them.

### Latex build chain

Install cygwin: <http://cygwin.com/setup-x86.exe> or <http://cygwin.com/cygwin-setup-x86_64.exe>

- Install packages for make, texlive, texlive-latex, texlive-latexextra, texlive-fontutils, texlive-collection-fontsrecommended, texlive-collection-science, texlive-collection-genericrecommended, texlive-collection-bibtexextra

Install pandoc: <http://code.google.com/p/pandoc/downloads/list>

Install gpp somewhere into c:/program files (x86): <http://makc.googlecode.com/svn/trunk/gpp.2.24-windows/>

- add the directory to the PATH environment variable

### PDF viewer

Install SumatraPDF for auto-refresh of PDF previews: <http://blog.kowalczyk.info/software/sumatrapdf/free-pdf-reader.html>

### Configuration of texmaker

To use cygwin with texmaker: Go to options|Configure texmaker and change pdflatex command to:

    c:\cygwin64\bin\bash.exe -c "PATH=$PATH:/usr/bin pdflatex -synctex=1 -interaction=nonstopmode %.tex"

### SublimeText

Install sublimetext from <http://www.sublimetext.com>

Add a new build system system: Tools -> Build system -> New build system

    {
        "cmd": ["c:\\cygwin\\bin\\bash.exe", "-c", "PATH=\"\\$PATH\":/cygdrive/c/cygwin/bin make pdflatex-$file_base_name"]
    }

Install package control: <https://sublime.wbond.net>

Install SublimeOnSaveBuild: Ctrl-Shift-P -> Package Control: Install Package -> SublimeOnSaveBuild

Enable autobuild: Preferences -> Package Settings -> SublimeOnSaveBuild -> Settings - User

    {
      "filename_filter": "\\.(markdown)$",
      "build_on_save": 1
    }

Further TODOs
-------------

- ondemand should do markdown -> tex and tex -> pdf separately, at the moment
  pdflatex is run two times
- get rid of gpp, implement everything as pandoc filters
- letter template
