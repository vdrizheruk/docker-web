# docker-web
Docker Container "WEB"

## build container
    sudo docker build -t web .

## start container
    sudo docker run -i -d -p 80:80 --name=web1 -t web:latest /start.sh
## stop and remove container
    sudo docker rm -f web1
## rename existed container
    sudo docker rename web1 web2
