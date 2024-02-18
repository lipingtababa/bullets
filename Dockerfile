FROM node:18.3.0

RUN apt-get update && apt-get install -y awscli jq

WORKDIR /usr/src/app
COPY . .

RUN yarn install
RUN yarn build

EXPOSE 8080
EXPOSE 8081
HEALTHCHECK --interval=30s --timeout=30s --retries=3 CMD curl -f http://localhost:8081/ping || exit 1


# start with entrypoint.sh
CMD ["sh", "entrypoint.sh"]
