FROM alpine:3.22

RUN apk add --no-cache \
	php83 \
	php83-fpm \
	php83-mysqli \
	php83-json \
	php83-curl \
	php83-dom \
	php83-mbstring \
	php83-openssl \
	php83-xml \
	php83-phar \
	php83-session \
	mariadb-client \
	wget \
	curl

RUN echo "memory_limit=512M" > /etc/php83/conf.d/memory.ini

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Configure PHP-FPM to listen on TCP port 9000 instead of unix socket
RUN sed -i 's|listen = /run/php-fpm/php-fpm.sock|listen = 9000|g' \
    /etc/php83/php-fpm.d/www.conf

COPY tools/wordpress.sh /tools/wordpress.sh

# Fix line endings AND set permissions
RUN sed -i 's/\r//' /tools/wordpress.sh && chmod +x /tools/wordpress.sh

EXPOSE 9000
ENTRYPOINT ["/tools/wordpress.sh"]
