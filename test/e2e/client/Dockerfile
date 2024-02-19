FROM ubuntu:latest

WORKDIR /app
COPY ./cloudEngineer_playerSimulator /app

# log into a file on the host
CMD ["/bin/sh", "-c", "./cloudEngineer_playerSimulator -players 100 -debug > /app/log/bullets.log 2>&1"]
