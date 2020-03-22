# You have to define thew values in {}
export DOCKER_USER=mamat08nurahmat
export DOCKER_PASSWORD=Nurahmat-19

DOCKER_REPO=mamat08nurahmat
APP_NAME=my-super-app
APP_PORT=80

GIT_BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)

if [ $GIT_BRANCH_NAME = "master" ]
then
        TAG_VERSION=$(git describe --tags $(git rev-list --tags --max-count=1))
else
        ENV=$(grep ENV deploy.env | cut -d '=' -f2)
        TAG_VERSION=$ENV-$(grep TAG_VERSION deploy.env | cut -d '=' -f2)
fi

APP_IMAGE=$DOCKER_REPO/$APP_NAME:$TAG_VERSION


cat <<EOF1 >.env
APP_IMAGE=$APP_IMAGE
APP_PORT=$APP_PORT
EOF1


cat <<EOF2 >deploy.env
APP_NAME=$APP_NAME
TAG_VERSION=$(git rev-parse HEAD)
DOCKER_REPO=$DOCKER_REPO
ENV=$(git rev-parse --abbrev-ref HEAD)
EOF2

# optional aws-cli options
#DOCKER_REPO={account-nr}.dkr.ecr.{region}.amazonaws.com
##AWS_CLI_PROFILE={aws-cli-profile}
##AWS_CLI_REGION={aws-cli-region}


# Port to run the container 
# Until here you can define all the individual configurations for your app
cat <<EOF3 >config.env
PORT=80
EOF3

cat <<"EOF4">docker-compose.yaml
version: '2'
services:
  app:
    image: ${APP_IMAGE}
    ports:
      - "${APP_PORT}:80"
    mem_limit: 128MB
    mem_reservation: 64MB
    restart: always
EOF4
