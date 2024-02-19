server {
    listen 8080;

    location / {
        proxy_pass http://LB_ADDRESS_PLACEHOLDER:8080;
        proxy_set_header Host $host;
        access_log /var/log/nginx/access.log;
        error_log /var/log/nginx/error.log;
    }
}
