.PHONY: render render-strict render-one renv-restore

# Best-effort render of every deck under src/ (see src/README.md).
# Failures are logged to src/render-report.md; this target always succeeds.
render:
	@./src/scripts/render_all.sh

# Same as `render`, but exits non-zero if any deck fails (for CI gating
# once enough decks have been triaged to make that meaningful).
render-strict:
	@./src/scripts/render_all.sh --strict

# Render a single deck, e.g.:
#   make render-one FILE=src/sports/sports_20221129.Rmd
render-one:
	@test -n "$(FILE)" || (echo "Usage: make render-one FILE=src/<category>/<name>.Rmd" && exit 1)
	Rscript src/scripts/render_one.R $(FILE)

# Restore the pinned R package versions from src/renv.lock.
renv-restore:
	Rscript -e 'renv::restore(project = "src")'
