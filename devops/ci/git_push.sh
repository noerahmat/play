#git add . && git commit -m "$$(date '+%Y-%m-%d-%H%M%S')-$$(git rev-parse --abbrev-ref HEAD)" && git push origin "$$(git rev-parse --abbrev-ref HEAD)"
GIT_COMMIT=$(date '+%Y-%m-%d-%H%M%S')-$(git rev-parse --abbrev-ref HEAD)
git add . && git commit -m "$$GIT_COMMIT" && git push origin "$$(git rev-parse --abbrev-ref HEAD)"
