FROM alpine:3.22

RUN apk add --no-cache \
	wget \
	tar

RUN wget -q https://github.com/prometheus/node_exporter/releases/download/v1.7.0/node_exporter-1.7.0.linux-amd64.tar.gz && \
	tar -xzf node_exporter-1.7.0.linux-amd64.tar.gz && \
	mv node_exporter-1.7.0.linux-amd64/node_exporter /usr/local/bin/node_exporter && \
	rm -rf node_exporter-1.7.0.linux-amd64*

EXPOSE 9100

CMD ["node_exporter"]
