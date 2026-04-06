#!/bin/sh

mkdir -p /var/www/html
cd /var/www/html

# Download WordPress if not already present
if [ ! -f wp-login.php ]; then
	wp core download --allow-root

	wp config create \
		--allow-root \
		--dbname=wordpress \
		--dbuser=wpuser \
		--dbpass=wppassword \
		--dbhost=mariadb

	wp core install \
		--allow-root \
		--url=https://dopereir.42.fr \
		--title="Inception" \
		--admin_user=admin \
		--admin_password=adminpass \
		--admin_email=admin@42.fr
fi

# Start PHP-FPM
exec php-fpm83 -F