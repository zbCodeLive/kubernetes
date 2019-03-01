#!/bin/bash

ZOOKEEPER_CONN=${1:-"http://127.0.0.1:2181"}

cat > bootstrap-release.yml <<EOF
spring:
  profiles:
    active: xxxxx
  cloud:
    zookeeper:
      enable: true
      connectString: $ZOOKEEPER_CONN
      config:
        enable: true
        root: /configurations/microserver
        defaultContext: commonconfig
        profileSeparator: ','
    inetutils:
      preferredNetworks:
        - 172.16
        - 192.168
        - 192.168.1
EOF