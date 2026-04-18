FROM alpine:3.22

RUN apk add --no-cache wget tar

RUN wget -q https://github.com/prometheus/prometheus/releases/download/v2.51.0/prometheus-2.51.0.linux-amd64.tar.gz && \
	tar -xzf prometheus-2.51.0.linux-amd64.tar.gz && \
	mv prometheus-2.51.0.linux-amd64/prometheus /usr/local/bin/prometheus && \
	mv prometheus-2.51.0.linux-amd64/promtool /usr/local/bin/promtool && \
	rm -rf prometheus-2.51.0.linux-amd64*

RUN mkdir -p /etc/prometheus /var/lib/prometheus

COPY conf/prometheus.yml /etc/prometheus/prometheus.yml

EXPOSE 9090

CMD ["prometheus", \
	 "--config.file=/etc/prometheus/prometheus.yml", \
	 "--storage.tsdb.path=/var/lib/prometheus"]
