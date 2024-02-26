FROM ubuntu:latest
RUN apt-get update && apt-get install -y nginx


WORKDIR /app
COPY ./cloudEngineer_playerSimulator /app
COPY ./nginx.conf.tpl /app/nginx.conf.tpl
COPY ./entrypoint.sh /app/entrypoint.sh

CMD ["/app/entrypoint.sh"]
