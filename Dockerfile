FROM ubuntu:14.10

RUN apt-get update && apt-get upgrade -y
# set environment
#RUN MYSQL_ROOT_PASSWORD=`date +%s | sha256sum | base64 | head -c 32`
RUN MYSQL_ROOT_PASSWORD=root

# persistent / runtime deps
RUN apt-get install --no-install-recommends -y ca-certificates unzip python-software-properties mc curl libpcre3 librecode0 libsqlite3-0 libxml2 \ 
# nginx + php
 php5-fpm php5-cli php5-dev php5-common \ 
 php5-mysql php5-curl php5-gd php5-mcrypt php5-sqlite php5-xmlrpc \ 
 php5-xsl php5-intl php-apc git mcrypt \ 
 python-setuptools procps mysql-client \ 
# programs
 mc nano git htop wget lynx links curl  \ 
 python-setuptools procps mysql-client

RUN php5enmod mcrypt

# Setup php5 cli options
RUN sed -i -e "s/;date.timezone\s=/date.timezone = UTC/g" /etc/php5/cli/php.ini
RUN sed -i -e "s/short_open_tag\s=\s*.*/short_open_tag = Off/g" /etc/php5/cli/php.ini
RUN sed -i -e "s/memory_limit\s=\s.*/memory_limit = 512M/g" /etc/php5/cli/php.ini
RUN sed -i -e "s/max_execution_time\s=\s.*/max_execution_time = 0/g" /etc/php5/cli/php.ini

# Setup php5 fpm options
RUN sed -i -e "s/;date.timezone\s=/date.timezone = UTC/g" /etc/php5/fpm/php.ini
RUN sed -i -e "s/short_open_tag\s=\s*.*/short_open_tag = Off/g" /etc/php5/fpm/php.ini
RUN sed -i -e "s/memory_limit\s=\s.*/memory_limit = 512M/g" /etc/php5/fpm/php.ini
RUN sed -i -e "s/max_execution_time\s=\s.*/max_execution_time = 0/g" /etc/php5/fpm/php.ini

# install composer
RUN curl -s https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer.phar
RUN ln -s /usr/local/bin/composer.phar /usr/local/bin/composer

# install node.js
RUN curl -sL https://deb.nodesource.com/setup | bash -
RUN apt-get install -y nodejs


# Add nginx repo and install nginx
#RUN add-apt-repository -y ppa:nginx/stable
#RUN apt-get -q update
RUN apt-get -y install nginx

# Install MySQL
RUN echo "mysql-server mysql-server/root_password password ${MYSQL_ROOT_PASSWORD}" | debconf-set-selections
RUN echo "mysql-server mysql-server/root_password_again password ${MYSQL_ROOT_PASSWORD}" | debconf-set-selections
RUN echo "mysql-server mysql-server/remove_test_db false" | debconf-set-selections

RUN apt-get -qqy install mysql-server

RUN echo "[client] \ 
user=root \ 
password=${MYSQL_ROOT_PASSWORD}" > /root/.my.cnf

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
#RUN groupadd -r mysql && useradd -r -g mysql mysql

COPY entrypoint.sh /entrypoint.sh

EXPOSE 80

ENTRYPOINT ["/entrypoint.sh"]
