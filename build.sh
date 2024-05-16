#!/bin/bash

docker build -t onceover:$1 .
if [ "$?" = "0" ]
then
  docker tag onceover:$1 docker.tom-krieger.de/onceover:$1
  if [ "$?" = "0" ]
  then
    docker push docker.tom-krieger.de/onceover:$1
  else
    exit 2
  fi
else
  exit 1
fi

exit 0

