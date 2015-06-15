input <- tools::file_path_sans_ext(basename(input))
builddir <- system2('make', '-s builddir', stdout = TRUE)

fig.path <- paste0(input, '-figures/')

hook_pdfclean <- function (before, options, envir) {
    if (before || options$fig.num == 0) return()
    for (f in paste0(options$fig.path, options$label, '-', seq_len(options$fig.num), '.', options$fig.ext)) {
        message('cropping and resetting meta data, timestamps, ids ', f)
        ft <- paste0(f, '.tmp')
        # crop
        system2('pdfcrop', c(shQuote(f), shQuote(f)))
        # remove meta data that might change between versions
        system2('sed', c('-i', shQuote('/^\\/\\(Producer\\|Creator\\|PTEX.Fullbanner\\) (.*)/d'), shQuote(f)))
        # fix offsets
        system2('pdftk', c(shQuote(f), 'output', shQuote(ft)))
        file.rename(ft, f)
        # remove timestamps
        system2('sed', c('-i', shQuote('/^\\/\\(Mod\\|Creation\\)Date (D:/s/[0-9]/0/g'), shQuote(f)))
        system2('sed', c('-i', shQuote('/^\\/ID \\[/s/[0-9a-fA-F]/D/g'), shQuote(f)))
    }
}

knitr::render_markdown()
knitr::opts_chunk$set(tidy = FALSE,
                      error = FALSE,
                      pdfclean = TRUE,
                      echo = FALSE,
                      cache = TRUE,
                      dev = 'pdf',
                      fig.path = fig.path,
                      cache.path = paste0(builddir, input, '-cache/'))
knitr::knit_hooks$set(pdfclean = if (.Platform$OS.type == 'windows') knitr::hook_pdfcrop else hook_pdfclean)
knitr::knit(paste0(input, '.Rmd'), paste0(input, '.markdown'), envir = new.env())

for (rmd_warning in knitr::knit_meta(class = "rmd_warning")) {
    message("Warning: ", rmd_warning)
}

if (make) {
    system2('make', paste0('pdflatex-', input))
}
