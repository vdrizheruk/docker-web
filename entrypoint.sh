#!/bin/bash

service mysql start
service nginx start
service php5-fpm start
service supervisor start

/bin/bash
