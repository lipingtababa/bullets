#!/bin/bash

sed "s|LB_ADDRESS_PLACEHOLDER|$LB_ADDRESS|g" nginx.conf.tpl > /etc/nginx/conf.d/default.conf
service nginx start

CONCURRENCY=${CONCURRENCY:-100}

./cloudEngineer_playerSimulator -players ${CONCURRENCY} -debug
