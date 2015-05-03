%% smart
%% to=latex
%% filter=templates/poster-filters.py
%% template=templates/poster.tex
%% biblatex

---
title: Thorough research of this special topic regarding the influence of various factors
author: [Poster Author 1, Poster Author 2]
email: author@university.edu
institute: Institute, Dept., University
longinstitute: Institute, Department, University, Country
web: 'https://university.edu/'
biblio-files: parsed-references.bib
posteroptions: width=90,height=120,scale=1.2 #,grid
headerheight: 13cm
# large, Large, LARGE, huge, Huge, veryHuge, VeryHuge, VERYHuge
titlefont: size=\veryHuge,series=\bfseries
authorfont: size=\huge
institutefont: size=\Large
---

[columns=2]

[column]

# Introduction

### Graphs

![two figures side-by-side](presentation-examplefig{width=0.5\linewidth},presentation-examplefig-magenta{width=0.5\linewidth})

<!-- Comments -->
### Default lists

- Citations [@Macherey2006] and @Macherey2006
- references have a clickable link to Pubmed or Amazon
- Standard abreviations \\eg and \\ie for \eg and \ie
- Units like \pps{900}
- **Highlights** and *highlights*

### Numbered lists

1.  First paragraph
2.  Second paragraph
3.  Third paragraph

    Continued paragraphs

# Bla

\lipsum[1-2]

# Blub

\lipsum[3-5]

[column]

# Big figure

![electrodes!](presentation-examplefig-electrodes{width=.8\linewidth})

# Baz

\lipsum[6-7]

### Table

<!-- this is still latex :-) -->
\begin{table}
    \rowcolors{2}{kuldark!10}{kuldark!20}
    \begin{tabular}{lrrrllll}
            \rowcolor{kuldark!20}
                &     &                     &         &      &          &
                \multicolumn{2}{c}{\cellcolor{kuldark!20}Blub} \\
        Bla & Blub & Bla & Blub & Bla & Blub &
        Bla & Blub \\
        Bla & Blub & Bla & Blub & Bla & Blub & Blablublbaba & Blubblabalbal \\
        Blub & Bla & Blub & Bla & Blub & Bla & Blub & Bla \\
        Bla & Blub & Bla & Blub & Bla & Blub & Bla & Blub \\
        Blub & Bla & Blub & Bla & Blub & Bla & Blub & Bla \\
        Bla & Blub & Bla & Blub & Bla & Blub & Bla & Blub \\
        Blub & Bla & Blub & Bla & Blub & Bla & Blub & Bla \\
    \end{tabular}
    \caption{\lipsum[9]}
    \label{tab:blub}
\end{table}

\vskip3.7cm

[columns=2]

[column=0.4]

# Conclusions

\lipsum[12]

\vskip1.4cm

[column=0.6]

# Bibliography

\printbibliography

\vskip7.3cm

<!-- vi: set spell spelllang=en linebreak et nolist showbreak=>\ \ \  : -->
