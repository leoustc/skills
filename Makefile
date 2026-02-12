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
	git tag -a "$(TAG)" -m "release $(TAG)"
	git push $(REMOTE) "$(TAG)"
