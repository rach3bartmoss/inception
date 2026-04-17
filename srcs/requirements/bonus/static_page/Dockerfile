FROM alpine:3.22

RUN apk add --no-cache nginx

RUN mkdir -p /var/www/static && \
	mkdir -p /run/nginx

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY site/ /var/www/static/

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]