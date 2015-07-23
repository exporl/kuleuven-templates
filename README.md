# KU Leuven Markdown templates

[![Build Status](https://travis-ci.org/exporl/kuleuven-templates.svg?branch=master)](https://travis-ci.org/exporl/kuleuven-templates)

Latest version and bugreports on Github: <https://github.com/exporl/kuleuven-templates/>

This repository contains markdown templates for presentations and posters according to the KU Leuven Corporate Design.
Next to the actual templates, a build system based on R/pandoc/texlive/make is provided.

Examples:

- presentation: [presentation-example.pdf](//exporl.github.io/kuleuven-templates/presentation-example.pdf)
- poster: [poster-example.pdf](//exporl.github.io/kuleuven-templates/poster-example.pdf)
- poster with R figures: [poster-r-example.pdf](//exporl.github.io/kuleuven-templates/poster-r-example.pdf)
- paper with R figures: [paper-r-example.pdf](//exporl.github.io/kuleuven-templates/paper-r-example.pdf)

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

## New pandoc variables

### Pandoc variables for presentations

- sectiontoc
- subsectiontoc
- multicolstoc
- sectiontitle
- subsectiontitle

## New commands

Various new markdown commands (`[command=param]`) are available.

### Markdown commands for papers

- `##### header5`: margin note
- `ipe`: start a new in-paragraph enumeration, use \item for the individual items
- `/ipe`: end an in-paragraph enumeration

### Markdown commands for presentations

most of these need to be at the end of a frame

- notoc (default)
- sectiontoc
- subsectiontoc
- largefooter (default)
- emptyfooter
- smallfooter
- nosupertitle (default)
- sectiontitle
- subsectiontitle

- `[columns=...]`: start a new column set with the given number of columns
- `[column]`: start a new column with equal width
- `[column=...]`: start a new column with given fraction of the line width
- `[/columns]`: end a column set
- `![caption](figure{options},figure{options...)`: figure float

### Markdown commands for posters

- `[columns=...]`: start a new column set with the given number of columns
- `[column]`: start a new column with equal width
- `[column=...]`: start a new column with given fraction of the line width
- `[/columns]`: end a column set
- `# header1`: start a new block
- `## header1`: ignored for compatibility with the presentation template
- `### header3`: start a new structural section (\\structure)
- `![caption](figure{options},figure{options...)`: figure float
- `ipe`: start a new in-paragraph enumeration, use \item for the individual items
- `/ipe`: end an in-paragraph enumeration

## Installation

### Linux

If you only want to use the templates (without history), use

    git clone --depth=1 https://github.com/mh21/kuleuven-templates && rm -rf kuleuven-templates/.git*

Install dependencies:

    sudo apt-get install pandoc python-pandocfilters make texlive texlive-latex-recommended texlive-science texlive-bibtex-extra

For building your documents:

    make

To automatically watch for changes and rebuild as required:

    make ondemand

See the top of Makefile for more information.

### Windows

There is an automatic installer available in the windows-installer directory. To
make it work, the following files need to be present:

    pandoc-1.13.2-windows.msi
    sublime-2-x64.exe
    SublimeOnSaveBuild.zip
    SumatraPDF-3.0-install.exe
    latex-markdown-templates.zip
    texmakerwin32_install.exe

Check the following sections on where to find them.

#### Mardown/Latex build chain

Install pandoc: <http://code.google.com/p/pandoc/downloads/list>

Install a latex distribution, e.g. miktex or texlive: <http://miktex.org/download>, <https://www.tug.org/texlive/acquire-netinstall.html>

#### PDF viewer

Install SumatraPDF for auto-refresh of PDF previews: <http://blog.kowalczyk.info/software/sumatrapdf/free-pdf-reader.html>

#### SublimeText

Install sublimetext from <http://www.sublimetext.com>

Add a new build system: Tools -> Build system -> New build system

    {
        "cmd": ["pdflatex", "-synctex=1", "-interaction=nonstopmode", "$file"]
    }

Install package control: <https://sublime.wbond.net>

Install SublimeOnSaveBuild: Ctrl-Shift-P -> Package Control: Install Package -> SublimeOnSaveBuild

Enable autobuild: Preferences -> Package Settings -> SublimeOnSaveBuild -> Settings - User

    {
      "filename_filter": "\\.(tex)$",
      "build_on_save": 1
    }

Further TODOs
-------------

- ondemand should do markdown -> tex and tex -> pdf separately, at the moment
  pdflatex is run two times
- Windows documentation for manual pandoc without make
- Windows install of pandoc filters
- Windows build rules/installer for pandoc
