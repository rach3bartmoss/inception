FROM alpine:3.22

RUN apk add --no-cache \
	php83 \
	php83-fpm \
	php83-session \
	php83-mysqli \
	nginx \
	wget

RUN wget -q https://www.adminer.org/latest.php -O /var/www/adminer/index.php

RUN mkdir -p /run/nginx

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY conf/www.conf /etc/php83/php-fpm.d/www.conf

EXPOSE 8080

CMD ["sh", "-c", "php-fpm83 && nginx -g 'daemon off;'"]