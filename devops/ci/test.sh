DOCKER_REPO=$(grep DOCKER_REPO deploy.env | cut -d '=' -f2)
APP_NAME=$(grep APP_NAME deploy.env | cut -d '=' -f2)
#cek git branch
#if master --> TAG_VERSION= git tag version --> 1.0.0.1
#if staging     --> TAG_VERSION= sta+commmit_id --> sta-1345abcde
#if development --> TAG_VERSION= dev+commmit_id --> dev-1345abcde
#TAG_VERSION = sta-$(grep TAG_VERSION deploy.env | cut -d '=' -f2)
#ENV=$(grep ENV deploy.env | cut -d '=' -f2)

#TAG_VERSION=$ENV-$(grep TAG_VERSION deploy.env | cut -d '=' -f2)
GIT_BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)

if [ $GIT_BRANCH_NAME = "master" ]
then
	TAG_VERSION=$(git describe --tags $(git rev-list --tags --max-count=1))
else
	ENV=$(grep ENV deploy.env | cut -d '=' -f2)
	TAG_VERSION=$ENV-$(grep TAG_VERSION deploy.env | cut -d '=' -f2)
fi

IMAGE_NAME=$DOCKER_REPO/$APP_NAME:$TAG_VERSION

export TEST_RESULT=$(docker run $IMAGE_NAME /bin/sh -c "[ -e "/usr/share/nginx/html/index.html" ] && echo 'PASS' || echo 'FAIL'")

#if [ "$TEST_RESULT" = 'PASS' ];  echo'TEST IS PASS' && exit 0; else echo'TEST IS FAIL' && exit 1; fi

if [ $TEST_RESULT = 'PASS' ]
then
  echo "TEST IS PASS"
else
  echo "TEST IS FAIL"
fi




#if [ "$TEST_RESULT" = 'PASS' ]; then curl -X POST --data-urlencode "payload={\"text\":\"\`$CI_PROJECT_TITLE\`, Pipeline ID \`$CI_PIPELINE_IID\` - \`TEST $TEST_RESULT\` by (\`$GITLAB_USER_LOGIN\` a.k.a \`$GITLAB_USER_NAME\`) with commit \`($CI_COMMIT_SHORT_SHA) $CI_COMMIT_TITLE\` \"}" $SLACK_DEVEL && exit 0; else curl -X POST --data-urlencode "payload={\"text\":\"\`$CI_PROJECT_TITLE\`, Pipeline ID \`$CI_PIPELINE_IID\` - \`TEST $TEST_RESULT\` by (\`$GITLAB_USER_LOGIN\` a.k.a \`$GITLAB_USER_NAME\`) with commit \`($CI_COMMIT_SHORT_SHA) $CI_COMMIT_TITLE\` \"}" $SLACK_DEVEL && exit 1; fi
