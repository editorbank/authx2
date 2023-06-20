#!
set -ex
source ./project.properties

export $(grep -v '^#' ./project.properties | sed -E 's/(.*)=.*/\1/' | xargs)
[ ! -d ./tmp ] && mkdir ./tmp
envsubst <./src/template/index.html >./tmp/index.html
envsubst <./src/template/login.html >./tmp/login.html
envsubst <./src/template/secret-index.html >./tmp/secret-index.html

$docker ps -q -a -f name=$container_name | xargs -r $docker rm -f
$docker run -d -P --name $container_name \
  -v ./src/nginx.conf:/etc/nginx/nginx.conf \
  -v ./src/authentication.map:/etc/nginx/authentication.map \
  -v ./src/authorization.map:/etc/nginx/authorization.map \
  -v ./src/attributes.map:/etc/nginx/attributes.map \
  -v ./src/resgroups.map:/etc/nginx/resgroups.map \
  -v ./src/favicon.ico:/usr/share/nginx/html/favicon.ico \
  -v ./tmp/index.html:/usr/share/nginx/html/index.html \
  -v ./tmp/login.html:/usr/share/nginx/html/login.html \
  -v ./tmp/secret-index.html:/usr/share/nginx/html/secret/index.html \
  -v ./public/needlogin.html:/usr/share/nginx/html/public/needlogin.html \
  -v ./public/logout.html:/usr/share/nginx/html/public/logout.html \
  -v ./public/failed.html:/usr/share/nginx/html/public/failed.html \
  -v ./public/successful.html:/usr/share/nginx/html/public/successful.html \
  $image_name


container_port=$($docker port $container_name|cut -d: -f2)
[ ! -z $container_port ] &&\
  curl -D- localhost:$container_port/secret/ &&\
  browse http://localhost:$container_port