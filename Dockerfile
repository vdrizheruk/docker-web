FROM ubuntu:14.10

RUN apt-get update && apt-get upgrade

# persistent / runtime deps
RUN apt-get update && apt-get upgrade && apt-get install -y ca-certificates curl libpcre3 librecode0 libsqlite3-0  \
libxml2 --no-install-recommends \
# phpize deps
php5-fpm php5-cli php5-gd php5-mysql php5-curl php5-mcrypt \
# webserver
nginx \
# programs
mc nano git htop wget lynx links curl \
# services
supervisor

WORKDIR /

COPY etc /etc

COPY start.sh /start.sh

CMD ["/start.sh"]