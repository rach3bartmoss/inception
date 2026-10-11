FROM alpine:3.22

RUN apk add --no-cache wget tar

RUN wget -q https://github.com/nginx/nginx-prometheus-exporter/releases/download/v1.4.2/nginx-prometheus-exporter_1.4.2_linux_amd64.tar.gz && \
	tar -xzf nginx-prometheus-exporter_1.4.2_linux_amd64.tar.gz && \
	mv nginx-prometheus-exporter /usr/local/bin/nginx-prometheus-exporter && \
	rm -rf nginx-prometheus-exporter_1.4.2_linux_amd64*

EXPOSE 9113

CMD [ "nginx-prometheus-exporter", "--nginx.scrape-uri=https://nginx/nginx_status" ]

#Install wget and tar
#wget nginx-prometheus-exporter repository
#move to /usr/local/bin