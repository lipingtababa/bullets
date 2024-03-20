# Fetch environment variables from ssm parameter store
# Fetch environment variables from secrets manager

if [ "$DEPLOYMEDNT_REGION"  != "localhost" ]; then
    # APP_NAME, APP_VERSION, STAGE, AWS_ACCOUNT and DEPLOYMEDNT_REGION are environment variables already
    DB_PASSWORD=`aws ssm get-parameters --names /${APP_NAME}/db/password --with-decryption --region ${DEPLOYMEDNT_REGION} | jq -r '.Parameters[0].Value' | tr -d '\n'`
    DB_HOST=`aws ssm get-parameters --names /${APP_NAME}/db/host --region ${DEPLOYMEDNT_REGION} | jq -r '.Parameters[0].Value' | tr -d '\n'`
    DB_PORT=`aws ssm get-parameters --names /${APP_NAME}/db/port --region ${DEPLOYMEDNT_REGION} | jq -r '.Parameters[0].Value' | tr -d '\n'`

    export DB_PASSWORD=${DB_PASSWORD}
    export DB_HOST=${DB_HOST}
    export DB_PORT=${DB_PORT}

    echo "DB_HOST=${DB_HOST}"
    echo "DB_PORT=${DB_PORT}"

fi

# start index.js
yarn start
