# You have to define thew values in {}
export DOCKER_USER=mamat08nurahmat
export DOCKER_PASSWORD=Nurahmat-19

DOCKER_REPO=mamat08nurahmat
APP_NAME=my-super-app
APP_PORT=80
SSH_USER=builder001
SSH_HOST_DEV=ec2-3-1-205-54.ap-southeast-1.compute.amazonaws.com

GIT_BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)

if [ $GIT_BRANCH_NAME = "master" ]
then
        TAG_VERSION=$(git describe --tags $(git rev-list --tags --max-count=1))
else
        ENV=$(grep ENV deploy.env | cut -d '=' -f2)
        TAG_VERSION=$ENV-$(grep TAG_VERSION deploy.env | cut -d '=' -f2)
fi

APP_IMAGE=$DOCKER_REPO/$APP_NAME:$TAG_VERSION

mkdir -p deploy;
mkdir -p deploy/$APP_NAME;

cat <<EOF1 >ci/.env
APP_IMAGE=$APP_IMAGE
APP_PORT=$APP_PORT
EOF1


cat <<EOF2 >ci/deploy.env
APP_NAME=$APP_NAME
TAG_VERSION=$(git rev-parse HEAD)
DOCKER_REPO=$DOCKER_REPO
ENV=$(git rev-parse --abbrev-ref HEAD)
SSH_USER=$SSH_USER
SSH_HOST_DEV=$SSH_HOST_DEV
EOF2

# optional aws-cli options
#DOCKER_REPO={account-nr}.dkr.ecr.{region}.amazonaws.com
##AWS_CLI_PROFILE={aws-cli-profile}
##AWS_CLI_REGION={aws-cli-region}


# Port to run the container 
# Until here you can define all the individual configurations for your app

cp ci/.env -p deploy/$APP_NAME/.env;
cp ci/deploy.env -p deploy/$APP_NAME/deploy.env;

cat <<"EOF4">deploy/$APP_NAME/docker-compose.yaml
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
