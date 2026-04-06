#!/bin/sh

mkdir -p /var/www/html
cd /var/www/html

echo "Waiting for MariaDB..."
while ! mariadb-admin ping -h mariadb -u ${MYSQL_USER} -p${MYSQL_PASSWORD} --silent; do
	sleep 1
done
echo "MariaDB is ready!"

if [ ! -f wp-login.php ]; then
	echo "Downloading WordPress..."
	wp core download --allow-root --path=/var/www/html

	echo "Creating wp-config.php..."
	wp config create \
		--allow-root \
		--dbname=${MYSQL_DATABASE} \
		--dbuser=${MYSQL_USER} \
		--dbpass=${MYSQL_PASSWORD} \
		--dbhost=mariadb || { echo "config failed!"; exit 1; }

	echo "Installing WordPress..."
	wp core install \
		--allow-root \
		--url=https://${DOMAIN_NAME} \
		--title=${WP_TITLE} \
		--admin_user=${WP_ADMIN} \
		--admin_password=${WP_ADMIN_PASSWORD} \
		--admin_email=${WP_ADMIN_EMAIL} || { echo "Install failed!"; exit 1; }

	wp user create \
		--allow-root \
		${WP_USER} ${WP_USER_EMAIL} \
		--role=editor \
		--user_pass=${WP_USER_PASSWORD}

	echo "WordPress installed successfully!"
fi

exec php-fpm83 -F
