FROM alpine:3.22

RUN apk add --no-cache wget tar musl-utils

RUN wget -q https://dl.grafana.com/oss/release/grafana-11.5.3.linux-amd64.tar.gz && \
	tar -xzf grafana-11.5.3.linux-amd64.tar.gz && \
	mv grafana-v11.5.3 /usr/share/grafana && \
	rm -rf grafana-11.5.3.linux-amd64.tar.gz

RUN mkdir -p /var/lib/grafana /var/log/grafana /etc/grafana

COPY conf/grafana.ini /etc/grafana/grafana.ini

EXPOSE 3000

CMD ["/usr/share/grafana/bin/grafana", "server", \
	 "--config=/etc/grafana/grafana.ini", \
	 "--homepath=/usr/share/grafana"]
