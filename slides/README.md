# Slides

- `*.html` / `*.pdf` in this directory are the **published** decks — linked directly from posts in `_posts/`. Never rename or move these; if you re-render a deck, its output filename must stay exactly what it is today.
- `src/` holds the **R Markdown sources**, organized by category, plus the tooling to regenerate the published output from them.

## Categories (`src/<category>/`)

| Category | Scope |
|---|---|
| `open-research` | Reproducibility / open research talks (ReproducibiliTea, RSS, ORC, UKRN, msp-open-access) |
| `sports` | Sports analytics talks (chess, football/538) |
| `networks-compstat` | Networks & computational statistics (reading groups, STOR601/603, CSML MCMC talk) |
| `teaching-engagement` | Teaching and public engagement talks (MAS8384, STEM Taster, UKCoTS, Insights workshops, FST public lecture) |
| `_shared` | Assets used across more than one category — currently the `lancasterbeamer` LaTeX theme, shared by talks in both `networks-compstat` and `teaching-engagement` |

Each category folder holds its own `.Rmd` sources plus an `images/` subfolder (and `bib/`, `sty/`, `assets/`, `reference/` where relevant) for assets used only within that category.

## Prerequisites

- R (see `src/renv.lock` for the exact version this was last snapshotted against)
- [pandoc](https://pandoc.org/) (bundled with RStudio, or install separately)
- [TinyTeX](https://yihui.org/tinytex/) — needed for the ~70% of decks that render to `beamer_presentation`/`pdf_document`
- R packages: run `make renv-restore` (from this directory) to install the exact versions pinned in `src/renv.lock`

## Regenerating output

```sh
# one deck
make render-one FILE=src/sports/sports_20221129.Rmd

# everything, best-effort (a failure in one deck never stops the rest)
make render

# same, but exits non-zero if anything failed (useful once more decks are triaged)
make render-strict
```

`make render`/`render-one` write straight into this directory (`slides/*.html|*.pdf`), overwriting the currently published version — check `git diff` before committing.

Every run (local or CI) writes `src/render-report.md`, listing pass/fail per deck.

**Older decks are expected to fail to re-render.** Only the two `open-research` UKRN talks were ever given a locked package environment; everything else predates that and has no version pinning going back to 2020. Package API drift (`ggplot2`, `dplyr`, `knitr`, etc. have all changed since) means some pre-2025 decks will error out — this is a known, accepted gap, not a bug to chase down preemptively. Fix a deck's dependencies opportunistically if you're revisiting it for another reason; there's no value in a blanket one-time triage pass.

CI (`.github/workflows/render-slides.yml`) runs the same best-effort render on every push touching `src/**`, purely as a signal — it renders into a scratch copy and never modifies the committed `slides/*.html|*.pdf`.

## Conventions

- **Source stem = output stem.** `src/<category>/foo.Rmd` always renders to `slides/foo.html`/`slides/foo.pdf` — no `output_file`/`output_dir` overrides in YAML frontmatter. This is what lets the Makefile derive output paths mechanically; keep it that way for any new deck.
- Cross-category assets go in `src/_shared/`; everything else stays local to its category's `images/`/`bib`/`sty` folder.
