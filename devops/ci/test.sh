#cek git branch
#if master --> TAG_VERSION= git tag version --> 1.0.0.1
#if staging     --> TAG_VERSION= sta+commmit_id --> sta-1345abcde
#if development --> TAG_VERSION= dev+commmit_id --> dev-1345abcde
#TAG_VERSION = sta-$(grep TAG_VERSION deploy.env | cut -d '=' -f2)

export TEST_RESULT=$(docker run $(grep DOCKER_REPO deploy.env | cut -d '=' -f2)/$(grep APP_NAME deploy.env | cut -d '=' -f2):$(grep ENV deploy.env | cut -d '=' -f2)-$(grep TAG_VERSION deploy.env | cut -d '=' -f2) /bin/sh -c "[ -e "/usr/share/nginx/html/index.html" ] && echo 'PASS' || echo 'FAIL'")

#if [ "$TEST_RESULT" = 'PASS' ];  echo'TEST IS PASS' && exit 0; else echo'TEST IS FAIL' && exit 1; fi

if [ $TEST_RESULT = 'PASS' ]
then
  echo "TEST IS PASS"
else
  echo "TEST IS FAIL"
fi




#if [ "$TEST_RESULT" = 'PASS' ]; then curl -X POST --data-urlencode "payload={\"text\":\"\`$CI_PROJECT_TITLE\`, Pipeline ID \`$CI_PIPELINE_IID\` - \`TEST $TEST_RESULT\` by (\`$GITLAB_USER_LOGIN\` a.k.a \`$GITLAB_USER_NAME\`) with commit \`($CI_COMMIT_SHORT_SHA) $CI_COMMIT_TITLE\` \"}" $SLACK_DEVEL && exit 0; else curl -X POST --data-urlencode "payload={\"text\":\"\`$CI_PROJECT_TITLE\`, Pipeline ID \`$CI_PIPELINE_IID\` - \`TEST $TEST_RESULT\` by (\`$GITLAB_USER_LOGIN\` a.k.a \`$GITLAB_USER_NAME\`) with commit \`($CI_COMMIT_SHORT_SHA) $CI_COMMIT_TITLE\` \"}" $SLACK_DEVEL && exit 1; fi
