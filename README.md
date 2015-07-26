# KU Leuven R/Markdown templates

[![Build Status](https://travis-ci.org/exporl/kuleuven-templates.svg?branch=master)](https://travis-ci.org/exporl/kuleuven-templates)

<!-- TOC bookmarklet: https://github.com/sillero/github-markdown-toc
!function(){"use strict";function e(e){var n=[{tagIndex:0,index:0,text:"###Table of Contents"}].concat(e.map(function(e){return{tagIndex:parseInt(e.tagName[1]),text:e.textContent,url:e.querySelector("a").getAttribute("href")}}));return n.each=function(e){return n.forEach(e),n},n}function n(e,n){for(var r=e[n],t=n;t>=0;t-=1)if(e[t].tagIndex<r.tagIndex)return e[t]}function r(e,r,t){var o=n(t,r);o&&(o.children=o.children||[],o.children.push(e),e.index=o.index+1,e.remove=!0)}function t(e){return!("remove"in e)}function o(e,n){e=e||[];var r=[n.text];return n.index&&(r=[new Array(n.index).join("    "),"- [",n.text,"](",n.url,")"]),e.push(r.join("")),n.children&&(e=n.children.reduce(o,e)),e}var c=document.querySelector("#readme .markdown-body")||document.querySelector("#wiki-body .markdown-body"),i=Array.prototype.slice.call(c.querySelectorAll("h2, h3, h4, h5, h6")),u=e(i).each(r).filter(t).reduce(o,[]).join("\n");console.log(u),alert(u)}(); -->

Latest version and bugreports on Github: <https://github.com/exporl/kuleuven-templates/>

This repository contains
[R](https://en.wikipedia.org/wiki/R_programming_language)/[Markdown](http://rmarkdown.rstudio.com/),
[Markdown](https://en.wikipedia.org/wiki/Markdown) and
[LaTeX](https://en.wikipedia.org/wiki/LaTeX)
templates for presentations and posters according to the KU Leuven Corporate
Design. Next to the actual templates, a build system based on
[R](https://www.r-project.org/),
[Pandoc](http://pandoc.org),
[TeX Live](https://www.tug.org/texlive/) and
[GNU Make](https://www.gnu.org/software/make/) is provided.

Examples:

- Presentation with R figures: [presentation-r-example.pdf](//exporl.github.io/kuleuven-templates/presentation-r-example.pdf)
- Presentation: [presentation-example.pdf](//exporl.github.io/kuleuven-templates/presentation-example.pdf)
- Poster with R figures: [poster-r-example.pdf](//exporl.github.io/kuleuven-templates/poster-r-example.pdf)
- Poster: [poster-example.pdf](//exporl.github.io/kuleuven-templates/poster-example.pdf)
- Paper with R figures: [paper-r-example.pdf](//exporl.github.io/kuleuven-templates/paper-r-example.pdf)

Pull requests welcome!

### Table of Contents
- [R/Markdown, plain Markdown or LaTeX](#rmarkdown-plain-markdown-or-latex)
    - [R/Markdown](#rmarkdown)
    - [Plain Markdown](#plain-markdown)
    - [LaTeX](#latex)
- [Linux](#linux)
    - [Installation](#installation)
    - [Using Make](#using-make)
        - [Make configuration](#make-configuration)
        - [Make targets](#make-targets)
- [Windows](#windows)
    - [Installation](#installation-1)
        - [R/Markdown/LaTeX build chain](#rmarkdownlatex-build-chain)
        - [PDF viewer](#pdf-viewer)
        - [SublimeText](#sublimetext)
    - [Setting it up](#setting-it-up)
        - [RStudio](#rstudio)
        - [Texmaker](#texmaker)
        - [SublimeText](#sublimetext-1)
- [New Pandoc variables](#new-pandoc-variables)
    - [Pandoc variables for presentations](#pandoc-variables-for-presentations)
- [New Markdown commands](#new-markdown-commands)
    - [Markdown commands for papers/presentations/posters](#markdown-commands-for-paperspresentationsposters)
    - [Markdown commands for papers](#markdown-commands-for-papers)
    - [Markdown commands for presentations](#markdown-commands-for-presentations)
    - [Markdown commands for posters](#markdown-commands-for-posters)
- [Further TODOs](#further-todos)

## R/Markdown, plain Markdown or LaTeX

The templates are available in three versions.

### R/Markdown

If you care about the reproducibility of your research, and want to be able to
analyze your data and generate your figures in the same place where you write
your text, R/Markdown should fit the bill quite nicely.
If you are using [RStudio](http://rstudio.com/), you can just click the `Knit`
button to compile your R/Markdown document.

- R/Markdown presentation: [presentation-r-example.Rmd](presentation-r-example.Rmd)
- R/Markdown poster: [poster-r-example.Rmd](poster-r-example.Rmd)
- R/Markdown paper: [paper-r-example.Rmd](paper-r-example.Rmd)

### Plain Markdown

If you need something that is a easier on the eyes than LaTeX and allows very
easy customization of the templates, but don't want to go the full way to
R/Markdown, take a look at the plain Markdown examples:

- Markdown presentation: [presentation-example.markdown](presentation-example.markdown)
- Markdown poster: [poster-example.markdown](poster-example.markdown)

### LaTeX

If you are already experienced in LaTeX, and you don't want to bother with all
that fancy new R/Markdown stuff, you can start with the LaTeX templates:

- LaTeX presentation: [presentation-latex.tex](presentation-latex.tex)
- LaTeX poster: [poster-latex.tex](poster-latex.tex)

## Linux

The easiest way to use the templates in Linux is with the included Makefile,
although it is also possible to directly call Rmarkdown, Pandoc or LaTeX.

### Installation

To get started, install dependencies (for an Ubuntu 14.04LTS system, other
distros should be very similar):

To use the included build system based on GNU Make:

    sudo apt-get install make

For the LaTeX templates:

    sude apt-get install texlive texlive-latex-recommended texlive-science texlive-bibtex-extra

To be able to create a backup A4 version of posters:

    sude apt-get install imagemagick posterazor

To be able to create a backup Powerpoint version of presentations (I know, ieek):

    sude apt-get install ghostscript libreoffice

For the plain Markdown templates:

    sudo apt-get install pandoc python-pandocfilters

To use R/Markdown:

    sudo apt-get install r-base-dev r-recommended

You can clone the templates without history with

    git clone --depth=1 https://github.com/exporl/kuleuven-templates && rm -rf kuleuven-templates/.git*

### Using Make

The included build system automatically transforms R/Markdown → plain Markdown →
LaTeX → PDF.
Building happens in a temporary directory under /tmp.
Any eps/tikz files placed in the root and figures/ directories are automatically
converted to pdf files there.

#### Make configuration

You can slightly configure the build system by copying the included
Makefile.local-example to Makefile.local.

- `BUILDDIR=.build`: Use a local build dir
- `BIBSOURCE=$(HOME)/path/to/mendeley.bib`: Define a bib source to automatically
  copy the reference database on changes
- `COPYPDF=no`: Leave the pdf file in the temp directory and don't copy it to
  the source directory
- `LATEX=lualatex`: Use lualatex instead of pdflatex

#### Make targets

Several Make targets are available:

- `make`, `make all`, `make pdflatex`: call `make pdflatex-<basename>` for all .Rmd,
  .markdown and .tex found in the current directory
- `make pdfview`, `make clean`, `make ondemand`: similar as above, for for the
  `pdfview-<basename>`, `clean-<basename>` and `ondemand-<basename>` targets
- `make <basename>.markdown`: convert an R/Markdown file to plain Markdown by
  evaluating any embedded R code with [knitr](http://yihui.name/knitr/)
- `make <basename>.tex`: convert a plain Markdown file to LaTeX with
  [Pandoc](http://pandoc.org); any lines in the Markdown file that start with
  `%% ` are transformed into options for Pandoc
- `pdflatex-<basename>`: convert an R/Markdown, plain Markdown or LaTeX file to 
  PDF by calling pdflatex and bibtex in addition to the appropriate steps above;
  you might need to call this multiple times to get all references and bib entries 
  resolved correctly
- `ondemand-<basename>`: watch for changes to any R/Markdown, plain Markdown or
  LaTeX files in the current directory and call `make pdflatex-<basename>` on them
- `handouts-<basename>`: create a LaTeX/Beamer handout version of a
  presentation, check below for how to configure which figures of animations to
  include
- `ppt-<basename>`: create a PowerPoint version of your presentation by creating
  images for each slide and combining them with [LibreOffice](https://www.libreoffice.org)
- `a4version-<basename>`: create a backup A4 version of your poster in case you
  forget that poster tube on the plane again with [PosteRazor](http://posterazor.sourceforge.net/)

## Windows

The Windows documentation is incomplete at the moment (TODO):
- you have to manually call Pandoc and LaTeX, and, in the case of R/Markdown,
  the RStudio knitr callback does not do this automatically either

While it is possible to use Cygwin to get the Linux setup above working quite
well, this is not covered here as most people on Windows do not have experience
in a Unix environment.

### Installation

There is an automatic installer available in the windows-installer directory. To
make it work, the following files need to be present:

    pandoc-1.13.2-windows.msi
    sublime-2-x64.exe
    SublimeOnSaveBuild.zip
    SumatraPDF-3.0-install.exe
    latex-markdown-templates.zip
    texmakerwin32_install.exe

Check the following sections on where to find them.
It does not install Python or the Python support for Pandoc filters, so you need
to do this yourself (TODO).

#### R/Markdown/LaTeX build chain

- Install [RStudio](https://www.rstudio.com/)
- Install [Pandoc](http://code.google.com/p/pandoc/downloads/list)
- Install [Python 2](https://www.python.org/downloads/windows/)
- Install [Python filter support for Pandoc](https://pypi.python.org/pypi/pandocfilters):
  on a Windows command prompt, type `pip install pandocfilters`
- Install a LaTeX distribution, e.g. [MiKTeX](http://miktex.org/download) or [TeX Live](https://www.tug.org/texlive/acquire-netinstall.html)

#### PDF viewer

- Install [SumatraPDF](http://blog.kowalczyk.info/software/sumatrapdf/free-pdf-reader.html) for auto-refresh of PDF previews

#### SublimeText

- Install [SublimeText](http://www.sublimetext.com)
- Install [package control](https://sublime.wbond.net)
- Install SublimeOnSaveBuild: Ctrl-Shift-P -> Package Control: Install Package -> SublimeOnSaveBuild

### Setting it up

#### RStudio

TODO

#### Texmaker

TODO

#### SublimeText

Add a new build system: Tools -> Build system -> New build system

    {
        "cmd": ["pdflatex", "-synctex=1", "-interaction=nonstopmode", "$file"]
    }

Enable autobuild: Preferences -> Package Settings -> SublimeOnSaveBuild -> Settings - User

    {
      "filename_filter": "\\.(tex)$",
      "build_on_save": 1
    }

## New Pandoc variables

### Pandoc variables for presentations

- `sectiontoc`: table of contents before each section
- `subsectiontoc`: table of contents before each subsection
- `multicolstoc`: two-column layout of table of contents
- `sectiontitle`: show the slide title and current section
- `subsectiontitle`: show the slide title and current section + subsection
- `gridcanvas`: centimeter grid in the background

## New Markdown commands

Various new Markdown commands (mostly of the form `[command=param]`) are
provided by the Pandoc filters found in `templates/*-filters.py`.

### Markdown commands for papers/presentations/posters

- `![*<anim>{option}caption]({options}figure,{options}figure...)`: figures

    - `*`: starred figure environment (normally spans 2 columns)
    - `<anim>`: beamer animation specification: slide to show the figure,
      starting from 1, if you don't want a figure to appear in the handouts
      specify slide 0 for handouts with something like `<2|handout:0>`
    - `<option>`: LaTeX figure options, use the shortcuts `h` (horizontal fill),
      `v` (vertical fill), `f` (fill) and `s` (slide fill) to do the Right Thing

    If multiple animation/option settings are defined next to the caption,
    they get spread across the figures. Paragraphs that only consist of
    figures with the same caption get collapsed into one float.

    Examples:

    - `![]{figure}`: basic figure, no float
    - `![caption]{figure}`: basic figure, put into a float
    - `![*caption]{figure}`: basic figure, put into a column-spanning float
    - `![{options}caption]{figure}`: basic figure in float, custom options
    - `![{options}caption]{figure1,figure2}`: two figures in one float, custom
      options for all
    - `![{options1}{options2}caption]{figure1,figure2}`: two figures in one
      float, custom options per figure
    - `![caption]{{options1}figure1,{options2}figure2}`: two figures in one
      float, custom options per figure
    - `![<1><2>caption]{figure1,figure2}`: two figures in one float, with
      animation
    - `![<1><2>caption]{figure1}![<1><2>caption]{figure2}`: two figures with
      same caption in one paragraph get collapsed into one float

### Markdown commands for papers

- `##### header5`: margin note
- `[ipe]`: start a new in-paragraph enumeration, use \item for the individual items
- `[/ipe]`: end an in-paragraph enumeration

### Markdown commands for presentations

- `# header1`: start a new section
- `## header1`: start a new subjection
- `### header3`: start a new slide
- `[columns=...]`: start a new column set with the given number of columns
- `[column]`: start a new column with equal width
- `[column=...]`: start a new column with given fraction of the line width
- `[/columns]`: end a column set

The following commands need to be at the end of a frame.

- `[notoc]`: no table of contents before sections/subsections (default)
- `[sectiontoc]`: table of contents before each section
- `[subsectiontoc]`: table of contents before each subsection
- `[largefooter]`: large footer with KU Leuven logo (default)
- `[emptyfooter]`: large footer with KU Leuven logo, but no page number
- `[smallfooter]`: transparent footer with just a page number
- `[nosupertitle]`: show only the slide title (default)
- `[sectiontitle]`: show the slide title and current section
- `[subsectiontitle]`: show the slide title and current section + subsection
- `[plaincanvas]`: empty background (default)
- `[gridcanvas]`: centimeter grid in the background

### Markdown commands for posters

- `# header1`: start a new block
- `## header1`: ignored for compatibility with the presentation template
- `### header3`: start a new structural section (\\structure)
- `[columns=...]`: start a new column set with the given number of columns
- `[column]`: start a new column with equal width
- `[column=...]`: start a new column with given fraction of the line width
- `[/columns]`: end a column set
- `[ipe]`: start a new in-paragraph enumeration, use \item for the individual items
- `[/ipe]`: end an in-paragraph enumeration

Further TODOs
-------------

- ondemand should do markdown -> tex and tex -> pdf separately, at the moment
  pdflatex is run two times
- example sound file
- make target to check that latex templates are unchanged, put on travis
- restore tikz helpers
- check the TODOs above
