REMOTE ?= origin
VERSION ?= 0.1
TAG ?= v$(VERSION)

.DEFAULT_GOAL := save

.PHONY: save release

save:
	git add .
	git commit -m "chore: update $$(date -u +%Y-%m-%dT%H:%M:%SZ)"
	git push $(REMOTE)

release:
	@set -eu; \
	latest="$$(git ls-remote --tags --refs "$(REMOTE)" 'v*' | sed 's#.*refs/tags/##' | sort -V | tail -n 1)"; \
	if [ -z "$$latest" ]; then \
	  next="v0.1"; \
	else \
	  next_num="$$(printf '%s\n' "$$latest" | sed 's/^v//' | awk -F. '{ $$NF=$$NF+1; OFS="."; print }')"; \
	  next="v$$next_num"; \
	fi; \
	echo "Remote latest tag: $${latest:-<none>}"; \
	echo "Releasing tag: $$next"; \
	if git ls-remote --tags --refs "$(REMOTE)" "$$next" | grep -q .; then \
	  echo "Tag $$next already exists on remote $(REMOTE)" >&2; \
	  exit 1; \
	fi; \
	git tag -a "$$next" -m "release $$next"; \
	git push "$(REMOTE)" "$$next"
