FROM alpine:3.22

RUN apk add --no-cache wget tar

RUN wget -q https://github.com/oliver006/redis_exporter/releases/download/v1.82.0/redis_exporter-v1.82.0.linux-amd64.tar.gz && \
	tar xzf redis_exporter-v1.82.0.linux-amd64.tar.gz && \
	mv redis_exporter-v1.82.0.linux-amd64/redis_exporter /usr/local/bin/redis_exporter && \
	rm -rf redis_exporter-v1.82.0.linux-amd64*

EXPOSE 9121

CMD [ "redis_exporter" ]

#verify is running
#curl http://localhost:9121/metrics | head -50
# in grafana the ID is 763