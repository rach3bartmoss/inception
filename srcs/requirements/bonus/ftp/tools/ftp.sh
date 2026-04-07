#!/bin/sh
set -e

: "${FTP_USER:?FTP_USER is required}"
: "${FTP_PASSWORD:?FTP_PASSWORD is required}"

mkdir -p /var/www/html

if ! id "$FTP_USER" >/dev/null 2>&1; then
	adduser -D -h /var/www/html -s /sbin/nologin "$FTP_USER"
fi

echo "$FTP_USER:$FTP_PASSWORD" | chpasswd
chown -R "$FTP_USER":"$FTP_USER" /var/www/html

exec /usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf
