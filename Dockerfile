FROM ubuntu:14.10

RUN apt-get update && apt-get upgrade -y

# persistent / runtime deps
RUN apt-get install --no-install-recommends -y ca-certificates curl libpcre3 librecode0 libsqlite3-0 libxml2 \ 
# nginx + php
 nginx \
 php5-fpm php5-cli php5-dev \
 php5-mysql php5-curl php5-gd php5-mcrypt php5-sqlite php5-xmlrpc \
 php5-xsl php5-common php5-intl php5-cli php-apc git mcrypt \
 python-setuptools procps mysql-client
# programs
 mc nano git htop wget lynx links curl \
 python-setuptools procps mysql-client

RUN php5enmod mcrypt

# install node.js
RUN curl -sL https://deb.nodesource.com/setup | bash -
RUN apt-get install -y nodejs


# install supervisor
RUN easy_install supervisor
RUN easy_install supervisor-stdout
RUN easy_install pip
RUN pip install  supervisor-logging

# cleanup
RUN apt-get clean autoclean
RUN apt-get autoremove -y
RUN rm -rf /var/lib/{apt,cache,log}/

WORKDIR /

COPY etc /etc


# mysql
RUN groupadd -r mysql && useradd -r -g mysql mysql

COPY entrypoint.sh /entrypoint.sh
#CMD ["/entrypoint.sh"]

EXPOSE 80
EXPOSE 3306

ENTRYPOINT ["/entrypoint.sh"]
