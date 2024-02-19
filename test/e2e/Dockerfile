FROM ubuntu:latest
RUN apt-get update && apt-get install -y nginx


WORKDIR /app
COPY ./cloudEngineer_playerSimulator /app
COPY ./nginx.conf /etc/nginx/conf.d/default.conf

CMD ["/bin/sh", "-c", "service nginx start && ./cloudEngineer_playerSimulator -players 100 -debug > /var/log/bullets.log 2>&1"]
