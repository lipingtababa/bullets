server {
    listen 8080;

    location / {
        proxy_pass http://LB_ADDRESS_PLACEHOLDER:8080;
        proxy_set_header Host $host;
        timetimeout 20;
    }
}