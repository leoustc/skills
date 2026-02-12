.PHONY: all commit push

all: commit push

commit:
	git add .
	git commit -m "chore: update $$(date -u +%Y-%m-%dT%H:%M:%SZ)"

push:
	git push
