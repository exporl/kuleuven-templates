# KU Leuven Markdown templates

[![Build Status](https://travis-ci.org/exporl/kuleuven-templates.svg?branch=master)](https://travis-ci.org/exporl/kuleuven-templates)

Latest version and bugreports on Github: <https://github.com/exporl/kuleuven-templates/>

This repository contains
[R](https://en.wikipedia.org/wiki/R_programming_language),
[Markdown](https://en.wikipedia.org/wiki/Markdown) and
[Latex](https://en.wikipedia.org/wiki/LaTeX)
templates for presentations and posters according to the KU Leuven Corporate
Design. Next to the actual templates, a build system based on
[R](https://www.r-project.org/),
[Pandoc](http://pandoc.org),
[TeX Live](https://www.tug.org/texlive/) and
[GNU Make](https://www.gnu.org/software/make/) is provided.

Examples:

- presentation with R figures: [presentation-r-example.pdf](//exporl.github.io/kuleuven-templates/presentation-r-example.pdf)
- presentation: [presentation-example.pdf](//exporl.github.io/kuleuven-templates/presentation-example.pdf)
- poster with R figures: [poster-r-example.pdf](//exporl.github.io/kuleuven-templates/poster-r-example.pdf)
- poster: [poster-example.pdf](//exporl.github.io/kuleuven-templates/poster-example.pdf)
- paper with R figures: [paper-r-example.pdf](//exporl.github.io/kuleuven-templates/paper-r-example.pdf)

Pull requests welcome!

## R, Markdown or Latex

If you are already experienced with Latex, you could start with the Latex
templates and never bother with all that fancy new R/Markdown stuff:

- Latex presentation: [presentation-latex.tex](presentation-latex.tex)
- Latex poster: [poster-latex.tex](poster-latex.tex)

If you need something that is a bit easier on the eyes and which allows very
easy customization of the templates, take a look at the Markdown examples:

- Markdown presentation: [presentation-example.markdown](presentation-example.markdown)
- Markdown poster: [poster-example.markdown](poster-example.markdown)

If you care about the reproducibility of your research, and want to be able to
analyze your data and generate your figures in the same place where you write
your text, R/Markdown should fit the bill quite nicely.

If you are using [RStudio](http://rstudio.com/), you can just click the `Knit`
button to compile your Markdown document.

- R/Markdown presentation: [presentation-r-example.Rmd](presentation-r-example.Rmd)
- R/Markdown poster: [poster-r-example.Rmd](poster-r-example.Rmd)
- R/Markdown paper: [paper-r-example.Rmd](paper-r-example.Rmd)

## New Pandoc variables

### Pandoc variables for presentations

- sectiontoc
- subsectiontoc
- multicolstoc
- sectiontitle
- subsectiontitle
- gridcanvas

## New Markdown commands

Various new Markdown commands (mostly of the form `[command=param]`) are
available.

### Markdown commands for papers/presentations/posters

- `![*<anim>{option}caption]({options}figure,{options}figure...)`: figures

    - `*`: starred figure environment (normally spans 2 columns)
    - `<anim>`: beamer animation specification
    - `<option>`: Latex figure options, use the shortcuts `h` (horizontal fill),
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
- plaincanvas (default)
- gridcanvas

- `[columns=...]`: start a new column set with the given number of columns
- `[column]`: start a new column with equal width
- `[column=...]`: start a new column with given fraction of the line width
- `[/columns]`: end a column set

### Markdown commands for posters

- `[columns=...]`: start a new column set with the given number of columns
- `[column]`: start a new column with equal width
- `[column=...]`: start a new column with given fraction of the line width
- `[/columns]`: end a column set
- `# header1`: start a new block
- `## header1`: ignored for compatibility with the presentation template
- `### header3`: start a new structural section (\\structure)
- `ipe`: start a new in-paragraph enumeration, use \item for the individual items
- `/ipe`: end an in-paragraph enumeration

## Make targets

For building your documents:

    make

To automatically watch for changes and rebuild as required:

    make ondemand

- pdflatex-<basename>
- handouts-<basename>
- ppt-<basename>
- a4version-<basename>
- ondemand-<basename>

## Installation

### Linux

If you only want to use the templates (without history), use

    git clone --depth=1 https://github.com/mh21/kuleuven-templates && rm -rf kuleuven-templates/.git*

Install dependencies:

    sudo apt-get install pandoc python-pandocfilters make texlive texlive-latex-recommended texlive-science texlive-bibtex-extra

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

#### Markdown/Latex build chain

Install Pandoc: <http://code.google.com/p/pandoc/downloads/list>

Install a Latex distribution, e.g. MiKTeX or TeX Live: <http://miktex.org/download>, <https://www.tug.org/texlive/acquire-netinstall.html>

#### PDF viewer

Install SumatraPDF for auto-refresh of PDF previews: <http://blog.kowalczyk.info/software/sumatrapdf/free-pdf-reader.html>

#### SublimeText

Install SublimeText from <http://www.sublimetext.com>

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
- example sound file
- export a4version/handouts/ppt on travis
- check that latex templates are unchanged on travis
- explain anim specs
- restore tikz helpers
