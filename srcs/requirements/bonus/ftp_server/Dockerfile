FROM alpine:3.22

RUN apk add --no-cache \
	vsftpd \
	inetutils-ftp

COPY conf/vsftpd.conf /etc/vsftpd.conf

COPY tools/ftp_server.sh /ftp_server.sh
RUN chmod +x /ftp_server.sh

EXPOSE 21 40000-50000

CMD ["/ftp_server.sh"]