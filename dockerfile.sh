#!/bin/bash

SERVICE_NAME=${1:-"usercenter-api-service"}
CURRENT_DIR=$(dirname $0)
JAR_NAME=$(ls $CURRENT_DIR | grep $1*.jar)

cat > dockerfile <<EOF
FROM zhub.com/centos/centos-java

COPY *.jar /home
COPY bootstrap-release.yml /home

CMD [ "java", "-jar", "/home/$JAR_NAME", "--spring.config.location=/home/bootstrap-release.yml" ]
EOF