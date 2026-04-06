FROM alpine:3.22

RUN apk add --no-cache \
	mariadb \
	mariadb-client

# Copy config and setup script
COPY conf/my.cnf /etc/my.cnf.d/my.cnf
COPY tools/mariadb.sh /tools/mariadb.sh
RUN chmod +x /tools/mariadb.sh

EXPOSE 3306
ENTRYPOINT ["/tools/mariadb.sh"]
