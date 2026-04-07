#!/bin/sh
set -e

configure_redis_cache() {
	REDIS_HOST_VALUE="${REDIS_HOST:-redis}"
	REDIS_PORT_VALUE="${REDIS_PORT:-6379}"

	if REDIS_HOST="${REDIS_HOST_VALUE}" REDIS_PORT="${REDIS_PORT_VALUE}" php83 -r '
		$host = getenv("REDIS_HOST") ?: "redis";
		$port = (int)(getenv("REDIS_PORT") ?: 6379);
		$socket = @fsockopen($host, $port, $errno, $errstr, 2);
		if (!$socket) {
			exit(1);
		}
		fclose($socket);
	'; then
		echo "Redis is reachable, configuring WordPress cache..."
		wp config set --allow-root --type=constant WP_REDIS_HOST "${REDIS_HOST_VALUE}" || true
		wp config set --allow-root --type=constant --raw WP_REDIS_PORT "${REDIS_PORT_VALUE}" || true
		wp plugin install redis-cache --activate --allow-root || true
		wp redis enable --allow-root || true
	else
		echo "Redis is not reachable, skipping Redis cache setup..."
	fi
}

mkdir -p /var/www/html
cd /var/www/html

echo "Waiting for MariaDB..."
for i in $(seq 1 30); do
	if mysqladmin ping -h mariadb -u${MYSQL_USER} -p${MYSQL_PASSWORD} --silent 2>/dev/null; then
		echo "MariaDB is ready!"
		break
	fi
	echo "Attempt $i/30: Waiting for MariaDB..."
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
else
	echo "WordPress already installed, skipping setup..."
fi

configure_redis_cache

echo "Starting PHP-FPM..."
exec php-fpm83 -F -R
