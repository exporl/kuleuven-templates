% Document title
% Document author
% Date of publication

<!-- %% passed on to pandoc -->
%% smart
%% to=latex
%% template=templates/report.tex
%% biblatex
%% variable biblio-files=parsed-references.bib
%% number-sections
%% variable classoptions=fontsize=12pt,DIV=12,parskip=half
%% variable biboptions=doi=true
%% toc
%% toc-depth=2

Heading 1
=========

Heading 2
---------

<!-- Comments -->
Default lists:

- Citations [@Macherey2006] and inline, \eg @Macherey2006, references have a clickable link to Pubmed (articles) or Amazon (books)
- Standard abreviations \\eg and \\ie for \eg and \ie to get the spacing right.
- Some units like \pps{900}, look in the template to see which ones are available.
- **Highlights** and *highlights*.

Unnumbered Heading {-}
------------------

Numbered lists:

1.  First paragraph
2.  Second paragraph
3.  Third paragraph

    Continued paragraphs
    \m{easy margin notes}

Inlined lists:
<#ipestart>
\item Aenean faucibus.
\item Morbi dolor nulla, malesuada eu, pulvinar at, mollis ac, nulla.
\item Curabitur auctor semper nulla.
<#ipeend>

See *man pandoc_markdown* for more information.

<!-- vi: set spell spelllang=en linebreak et nolist showbreak=>\ \ \  : -->
