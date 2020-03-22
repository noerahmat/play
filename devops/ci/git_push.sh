#!/bin/bash
#NOW=$(date +"%Y-%m-%d-%H%M%S")-$(git rev-parse --abbrev-ref HEAD)
#FILE="backup.$NOW.tar.gz"
#echo "Backing up data to /nas42/backup.$NOW.tar.gz file, please wait..."
#git add . && git commit -m "$$(date '+%Y-%m-%d-%H%M%S')-$$(git rev-parse --abbrev-ref HEAD)" && git push origin "$$(git rev-parse --abbrev-ref HEAD)"
#GIT_COMMIT=$(date '+%Y-%m-%d-%H%M%S')-$(git rev-parse --abbrev-ref HEAD)
#echo "$$GIT_COMMIT"
git add . && git commit -m "$$(date +"%Y-%m-%d-%H%M%S")-$(git rev-parse --abbrev-ref HEAD)" && git push origin "$$(git rev-parse --abbrev-ref HEAD)"
