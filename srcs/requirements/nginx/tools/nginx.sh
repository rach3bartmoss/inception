#!/bin/sh

mkdir -p /etc/nginx/ssl

openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-keyout /etc/nginx/ssl/key.pem \
	-out /etc/nginx/ssl/cert.pem \
	-subj "/CN=dopereir.42.fr"


# req -> certificate request command
# -x509 -> skip request and generate a self-signed cert
# -nodes -> set the key as not password protected, allows nginx
#	to start without ask for password
# -days 365, cert expire in one year, someone says that is a good pratic
# -newkey rsa:2048 -> RSA key of 2048bits

# add to /etc/hosts
# 127.0.0.1 dopereir.42.fr