#!/bin/sh
set -e

if [ -z "${FTP_USER:-}" ] || [ -z "${FTP_PASSWORD:-}" ]; then
	echo "ERROR: FTP_USER and FTP_PASSWORD must be set."
	exit 1
fi

# Create FTP user if it does not exist yet.
if ! id "$FTP_USER" >/dev/null 2>&1; then
	adduser -D -h /var/www/html -s /sbin/nologin "$FTP_USER"
	echo "$FTP_USER:$FTP_PASSWORD" | chpasswd
fi

mkdir -p /var/www/html
mkdir -p /var/www/html/uploads

chown ftpuser:ftpuser /var/www/html/uploads
chmod 755 /var/www/html


echo "Starting vsftpd for user $FTP_USER"
exec /usr/sbin/vsftpd /etc/vsftpd.conf
