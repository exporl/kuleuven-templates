---
title: Thorough research of this special topic regarding the influence of various factors
subtitle: Yeah we did it!
author: [Author 1, Author 2]
date: Date of presentation
institute: Institute, Dept., University
biblio-files: parsed-references.bib
toc: true
sectiontoc: true
subsectiontoc: true
sectiontitle: true
captionfont: size=\scriptsize
show-total-number-of-slides: true
# customization of the templates
header-includes: \input{presentation-example.header}
knit: (function(input, encoding, make = TRUE) { source('templates/makefile-renderer.R', local = TRUE) })
---

%% smart
%% to=beamer
%% slide-level 3
%% template=templates/presentation.tex
%% filter=templates/presentation-filters.py
%% biblatex

# Introduction

### Introduction Slide 1

<!--Show the first figure on the first slide, and the second on the second.
    When in handout mode (last parameter) where everything is normally shown on
    one slide, hide the first figure by setting its slide number to zero -->
![<1|handout:0><2>{h}](presentation-examplefig,presentation-examplefig-magenta)

<!-- Comments -->

Default lists:

- Citations [@Macherey2006;@Francart2008] and @Macherey2006, with clickable link to Pubmed/Amazon
- Standard abreviations \\eg and \\ie for \eg and \ie
- Units like \pps{900}
- **Highlights** and *highlights*

### Indented lists

- Item 1
    - Item 1.1
    - item 1.2
- Item 2 \
  Continue without bullet
- Item 3


[includeslides=figures/pdfslide.pdf]

# Methods

# Results

## Part 1

### Results Slide 1

- You can show full-screen figures as on the next slide

![{s}](presentation-examplefig-electrodes)

## Part 2

[smallfooter]

### Results Slide 3

- You can also just replace the footer by a minimal version

[largefooter]

### Results Slide 4

[columns=2]

[column]

- Some things are better shown in columns

[column]

![{h}The 10-20 system](presentation-examplefig-electrodes)

[/columns]

# Conclusions

[notoc]

[nosupertitle]

### Conclusions

Numbered lists:

1.  First paragraph \pause
2.  Second paragraph
3.  Third paragraph

    Continued paragraphs

# Appendix

\appendix

### Appendix slide

This is an appendix slide. The page numbering has restarted.

