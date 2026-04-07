FROM alpine:3.22

RUN apk add --no-cache \
	php83 \
	php83-session \
	php83-mysqli \
	wget \
	&& mkdir -p /var/www/html \
	&& wget -O /var/www/html/index.php https://github.com/vrana/adminer/releases/download/v5.3.0/adminer-5.3.0.php \
	&& chown -R nobody:nobody /var/www/html

EXPOSE 8080
CMD ["php83", "-S", "0.0.0.0:8080", "-t", "/var/www/html"]
