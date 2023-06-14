#!
set -x
source ./project.properties

# Удаление контейнеров и образов сделанных проектом
$docker ps -q -a -f name=$container_name | xargs -r $docker rm -f
#$docker images -q -f reference=$image_name | xargs -r $docker rmi -f

[ -d ./tmp ] && rm -rf ./tmp