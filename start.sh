#!
set -x
source ./project.properties

[ ! -d ./tmp ] && mkdir ./tmp
container_name=$container_name envsubst <./src/index.html.template >./tmp/index.html

docker rm -f $container_name
docker run -d -P --name $container_name \
  -e HELLO_NAME=$container_name \
  -v ./src/nginx.conf:/etc/nginx/nginx.conf \
  -v ./src/http.js:/etc/nginx/http.js \
  -v ./tmp/index.html:/usr/share/nginx/html/index.html \
  $image_name


container_port=$(docker port $container_name|cut -d: -f2)
[ ! -z $container_port ] &&\
  curl localhost:$container_port/hello &&\
  browse http://localhost:$container_port