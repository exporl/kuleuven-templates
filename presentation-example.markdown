---
title: Thorough research of this special topic regarding the influence of various factors
subtitle: Yeah we did it!
author: [Author 1, Author 2]
date: Date of presentation
institute: Institute, Dept., University
biblio-files: parsed-references.bib
toc: true
sectiontoc: true
sectiontitle: true
captionfont: size=\scriptsize
# customization of the templates
header-includes: \input{presentation-example.header}
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
<#hfig presentation-examplefig|1|0>
<#hfig presentation-examplefig-magenta|2>

<!-- Comments -->
Default lists:

- Citations [@Macherey2006] and @Macherey2006
- references have a clickable link to Pubmed or Amazon
- Standard abreviations \\eg and \\ie for \eg and \ie
- Units like \pps{900}
- **Highlights** and *highlights*

# Methods

# Results

## Part 1

### Results Slide 1

- You can show full-screen figures as on the next slide

<#slidefig presentation-examplefig-electrodes>

## Part 2

[smallfooter]

### Results Slide 3

- You can also just replace the footer by a minimal version

[largefooter]

### Results Slide 4

<#colfirst>
- Some things are better shown in columns
<#colnext>
\begin{figure}
<#hfig presentation-examplefig-electrodes>
\caption{The 10-20 system}
\end{figure}
<#colend>

# Conclusions

[notoc]

[nosupertitle]

### Conclusions

Numbered lists:

1.  First paragraph <#pause>
2.  Second paragraph
3.  Third paragraph

    Continued paragraphs

<!-- vi: set spell spelllang=en linebreak et nolist showbreak=>\ \ \  : -->
