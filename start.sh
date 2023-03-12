#!
set -x
source ./project.properties

export $(grep -v '^#' ./project.properties | sed -E 's/(.*)=.*/\1/' | xargs)
[ ! -d ./tmp ] && mkdir ./tmp
envsubst <./src/template/index.html >./tmp/index.html
envsubst <./src/template/login.html >./tmp/login.html

docker rm -f $container_name
docker run -d -P --name $container_name \
  -e HELLO_NAME=$container_name \
  -v ./src/nginx.conf:/etc/nginx/nginx.conf \
  -v ./src/http.js:/etc/nginx/http.js \
  -v ./tmp/index.html:/usr/share/nginx/html/index.html \
  -v ./tmp/login.html:/usr/share/nginx/html/login.html \
  $image_name


container_port=$(docker port $container_name|cut -d: -f2)
[ ! -z $container_port ] &&\
  curl localhost:$container_port/hello &&\
  browse http://localhost:$container_port