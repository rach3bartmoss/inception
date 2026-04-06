FROM alpine3.22

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
	wget \
	curl

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
	&& chmod +x wp-cli.phar \
	&& mv wp-cli.phar /usr/local/bin/wp

COPY tools/wordpress.sh /tools/wordpress.sh
RUN chmod +x /tools/wordpress.sh

EXPOSE 9000
ENTRYPOINT ["/tools/wordpress.sh"]