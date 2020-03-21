#site="http://${environment}.aawrp5rccf.us-west-2.elasticbeanstalk.com/"
site="http://3.1.205.54:5000/"

code=$(curl -sL --max-time 3 -o /dev/null -w "%{http_code}" $site)

echo "Site: $site"
echo "Expected '200'; Received: $code"

if [ "$code" != "200" ];
then
    exit 1
fi
