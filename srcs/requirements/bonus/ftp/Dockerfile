FROM alpine:3.22

RUN apk add --no-cache vsftpd

COPY conf/vsftpd.conf /etc/vsftpd/vsftpd.conf
COPY tools/ftp.sh /tools/ftp.sh
RUN chmod +x /tools/ftp.sh

EXPOSE 21 30000-30009
ENTRYPOINT ["/tools/ftp.sh"]
