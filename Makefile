# import config.
# You can change the default config with `make cnf="config_special.env" build`
cnf ?= config.env
include $(cnf)
export $(shell sed 's/=.*//' $(cnf))

# import deploy config
# You can change the default deploy config with `make cnf="deploy_special.env" release`
dpl ?= deploy.env
include $(dpl)
export $(shell sed 's/=.*//' $(dpl))

# grep the version from the mix file
export VERSION=$(shell ./version.sh)
#export VERSION=$(git rev-parse HEAD)


# HELP
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

CMD_SETUP := "sh setup.sh"
CMD_TEST := "sh test.sh"

# DOCKER TASKS
# Build the container
build: ## Build the container
	@eval $(CMD_SETUP)
	docker build -t $(APP_NAME) .

build-nc: ## Build the container without caching
	@eval $(CMD_SETUP)
	docker build --no-cache -t $(APP_NAME) .

run: ## Run container on port configured in `config.env`
	docker run -d --env-file=./config.env -p=$(PORT):$(PORT) --name="$(APP_NAME)" $(APP_NAME)
	#docker run -i -t --rm --env-file=./config.env -p=$(PORT):$(PORT) --name="$(APP_NAME)" $(APP_NAME)
test:## run test container
	@eval $(CMD_TEST)
	#docker run $(DOCKER_REPO)/$(APP_NAME):$(TAG_VERSION) /bin/sh -c "[ -e "/usr/share/nginx/html/index.html" ] && echo 'PASS' || echo 'FAIL'"

up: build run ## Run container on port configured in `config.env` (Alias to run)

stop: ## Stop and remove a running container
	docker stop $(APP_NAME); docker rm $(APP_NAME)

logs: ##get logs from container
	docker logs $(APP_NAME) -ft --tail=100

release: build-nc publish ## Make a release by building and publishing the `{version}` ans `latest` tagged containers to ECR

# Docker publish
publish: repo-login publish-latest publish-version ## Publish the `{version}` ans `latest` tagged containers to ECR

publish-latest: tag-latest ## Publish the `latest` taged container to ECR
	@echo 'publish latest to $(DOCKER_REPO)'
	docker push $(DOCKER_REPO)/$(APP_NAME):latest

publish-version: tag-version ## Publish the `{version}` taged container to ECR
	@echo 'publish $(VERSION) to $(DOCKER_REPO)'
	docker push $(DOCKER_REPO)/$(APP_NAME):$(TAG_VERSION)

# Docker tagging
tag: tag-latest tag-version ## Generate container tags for the `{version}` ans `latest` tags

tag-latest: ## Generate container `{version}` tag
	@echo 'create tag latest'
	docker tag $(APP_NAME) $(DOCKER_REPO)/$(APP_NAME):latest

tag-version: ## Generate container `latest` tag
	@echo 'create tag $(VERSION)'
	docker tag $(APP_NAME) $(DOCKER_REPO)/$(APP_NAME):$(TAG_VERSION)

# HELPERS

# generate script to login to aws docker repo
#CMD_REPOLOGIN := "eval $$\( aws ecr"
#ifdef AWS_CLI_PROFILE
#CMD_REPOLOGIN += " --profile $(AWS_CLI_PROFILE)"
#endif
#ifdef AWS_CLI_REGION
#CMD_REPOLOGIN += " --region $(AWS_CLI_REGION)"
#endif
#CMD_REPOLOGIN += " get-login --no-include-email \)"
# login to AWS-ECR

CMD_REPOLOGIN := "docker login -u $(DOCKER_USER) -p$(DOCKER_PASSWORD)"

repo-login: ## Auto login to AWS-ECR unsing aws-cli
	@eval $(CMD_SETUP)
	@eval $(CMD_REPOLOGIN)

#CMD_SETUP := "sh setup.sh"

#setup:
#	@eval $(CMD_SETUP)

version: ## Output the current version
	@echo $(VERSION)

