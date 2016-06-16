#!/bin/bash

# echo -e "POST /containers/nginx-dev/kill?signal=HUP HTTP/1.0\r\n" | nc -U /var/run/docker.sock
docker kill -s HUP nginx-dev;


