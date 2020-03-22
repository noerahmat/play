#RELEASE STEP 
build --> test --> release

release = (build-nc--> test---> publish)

publish = (repo-login--> publish-latest--> publish-version)

publish-latest: tag-latest ## Publish the `latest` taged container environtment
ENV develpment --> DOCKER_REPO/APP_NAME:dev
ENV staging    --> DOCKER_REPO/APP_NAME:sta
ENV production --> DOCKER_REPO/APP_NAME:latest

publish-ersion: tag-version ## Publish the `version` taged container environtment
ENV develpment --> DOCKER_REPO/APP_NAME:dev-12345zbcde
ENV staging    --> DOCKER_REPO/APP_NAME:sta-12345zbcde
ENV production --> DOCKER_REPO/APP_NAME:1.0.0.1

