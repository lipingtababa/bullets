#!/bin/bash

sed "s|LB_ADDRESS_PLACEHOLDER|$LB_ADDRESS|g" nginx.conf.tpl > /etc/nginx/conf.d/default.conf
service nginx start

./cloudEngineer_playerSimulator -players 100 -debug
