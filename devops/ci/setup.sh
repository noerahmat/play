# You have to define the values in {}
export DOCKER_USER=mamat08nurahmat
export DOCKER_PASSWORD=Nurahmat-19

cat <<EOF2 >deploy.env
APP_NAME=my-super-app
TAG_VERSION=$(git rev-parse HEAD)
DOCKER_REPO=mamat08nurahmat
ENV=sta
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
