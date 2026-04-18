FROM alpine:3.22

RUN apk add --no-cache redis

COPY conf/redis.conf /usr/local/etc/redis/redis.conf

EXPOSE 6379

CMD ["redis-server", "/usr/local/etc/redis/redis.conf"]
