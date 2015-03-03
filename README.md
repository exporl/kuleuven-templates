# KU Leuven Markdown templates

Latest version and bugreports on Github: <https://github.com/mh21/kuleuven-templates/>

This repository contains markdown templates for presentations according to the KU Leuven Corporate Design.
You can find an example at [presentation-example.pdf](presentation-example.pdf).
Next to the actual templates, a build system based on pandoc/texlive/make is provided.

Pull requests welcome!

## Markdown or Latex

You can also stick with Latex and not use Markdown.
In this case, just use [presentation-latex.tex](presentation-latex.tex) as a template to get started.

## Linux installation

If you only want to use the templates (without history), use

    git clone --depth=1 https://github.com/mh21/kuleuven-templates && rm -rf kuleuven-templates/.git*

Install dependencies:

    sudo apt-get install pandoc gpp texlive make texlive-latex-recommended texlive-science biblatex

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

- use yaml instead of custom headers
- ondemand should do markdown -> tex and tex -> pdf separately, at the moment
  pdflatex is run two times
- letter template
- poster template
- support for Rmd/knitr: Rmd -> md
