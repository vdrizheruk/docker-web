#!/bin/bash

docker run -i -d -p 80 --name=web1 -t vdrizheruk/web:latest
# start container and accepts requests on port 80
#docker run -i -d -p 80:80 --name=web1 -t vdrizheruk/web:latest
