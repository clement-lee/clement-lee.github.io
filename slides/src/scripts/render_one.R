#!/usr/bin/env Rscript
# Render a single slide deck to slides/, deriving the output stem from the
# source stem (no output_file/output_dir overrides — see slides/README.md).
# Invoke from the slides/ directory: Rscript src/scripts/render_one.R <path>
#
# Usage: Rscript src/scripts/render_one.R src/<category>/<name>.Rmd

args <- commandArgs(trailingOnly = TRUE)
if (length(args) < 1) {
  stop("Usage: Rscript src/scripts/render_one.R <path-to-Rmd, relative to slides/>")
}
rmd <- args[1]

if (!file.exists(rmd)) {
  stop("File not found: ", rmd, " (run this from the slides/ directory)")
}

slides_dir <- normalizePath(".")
rmd_abs <- normalizePath(rmd)
rmd_dir <- dirname(rmd_abs)

# Activate the renv project (src/) so rmarkdown/knitr/etc. resolve to the
# restored library. R only auto-sources .Rprofile when the working
# directory exactly matches where it lives (src/), but this script runs
# with cwd == slides/ so that output paths resolve correctly above — so
# renv's usual auto-activation never fires here. renv's activate.R itself
# determines the project root from getwd() at the moment it's sourced, so
# this has to briefly cd into src/ rather than just sourcing it in place.
old_wd <- setwd(file.path(slides_dir, "src"))
source("renv/activate.R")
setwd(old_wd)

# LaTeX themes live outside each deck's own directory (the lancasterbeamer
# theme is shared across categories; NewcastleUniversity's theme sits in
# open-research/sty/), so \usetheme{} needs them on TEXINPUTS rather than
# relying on the knit working directory.
shared_tex <- normalizePath(
  file.path(slides_dir, "src", "_shared", "beamer-lancaster"),
  mustWork = FALSE
)
category_sty <- file.path(rmd_dir, "sty")
tex_parts <- c(
  rmd_dir,
  shared_tex,
  if (dir.exists(category_sty)) category_sty,
  Sys.getenv("TEXINPUTS")
)
Sys.setenv(TEXINPUTS = paste0(paste(tex_parts, collapse = ":"), ":"))

# A missing LaTeX package (e.g. an undocumented dependency of an older
# theme) makes pdflatex drop into an interactive "Enter file name:"
# prompt rather than failing outright; force non-stop mode so a missing
# package is a clean render failure instead of a hang on stdin.
options(tinytex.engine_args = "-interaction=nonstopmode")

rmarkdown::render(
  input = rmd_abs,
  output_format = "all",
  output_dir = slides_dir,
  knit_root_dir = rmd_dir,
  envir = new.env(),
  quiet = TRUE
)
