input <- tools::file_path_sans_ext(basename(input))
builddir <- system2('make', '-s builddir', stdout = TRUE)

fig.path <- paste0(input, '-figures/')
R.utils::mkdirs(paste0(builddir, fig.path))

knitr::render_markdown()
knitr::opts_knit$set(base.dir = builddir)
knitr::opts_chunk$set(tidy = FALSE,
                      error = FALSE,
                      crop = TRUE,
                      echo = FALSE,
                      cache = TRUE,
                      dev = 'pdf',
                      fig.path = fig.path,
                      cache.path = paste0(builddir, input, '-cache/'))
knitr::knit_hooks$set(crop = knitr::hook_pdfcrop)
knitr::knit(paste0(input, '.Rmd'), paste0(input, '.markdown'))

for (rmd_warning in knitr::knit_meta(class = "rmd_warning")) {
    message("Warning: ", rmd_warning)
}

if (make) {
    system2('make', paste0('pdflatex-', input))
}
