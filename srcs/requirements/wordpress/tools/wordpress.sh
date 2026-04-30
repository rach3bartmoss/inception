#!/bin/sh
set -e

setup_redis_cache() {
	if [ "${ENABLE_REDIS_CACHE:-false}" != "true" ]; then
		echo "Redis cache setup disabled (set ENABLE_REDIS_CACHE=true to enable)."
		return 0
	fi

	echo "Configuring Redis cache plugin..."

	# In Docker, Redis is reached through the service name, not a Unix socket path.
	wp config set WP_REDIS_HOST "${REDIS_HOST:-redis}" --type=constant --allow-root || {
		echo "Failed to set WP_REDIS_HOST, skipping Redis setup."
		return 0
	}
	wp config set WP_REDIS_PORT "${REDIS_PORT:-6379}" --type=constant --raw --allow-root || {
		echo "Failed to set WP_REDIS_PORT, skipping Redis setup."
		return 0
	}

	if wp plugin is-installed redis-cache --allow-root >/dev/null 2>&1; then
		wp plugin activate redis-cache --allow-root || echo "Failed to activate redis-cache plugin."
	else
		wp plugin install redis-cache --activate --allow-root || {
			echo "Failed to install redis-cache plugin."
			return 0
		}
	fi

	if wp redis enable --allow-root; then
		echo "Redis object cache enabled."
	else
		echo "Redis plugin is installed, but Redis is not reachable yet."
		echo "Check redis service and environment values REDIS_HOST/REDIS_PORT."
	fi
}

mkdir -p /var/www/html
cd /var/www/html

echo "Waiting for MariaDB..."
db_ready=false
for i in $(seq 1 30); do
	if mysqladmin ping -h mariadb -u${MYSQL_USER} -p${MYSQL_PASSWORD} --silent 2>/dev/null; then
		echo "MariaDB is ready!"
		db_ready=true
		break
	fi
	echo "Attempt $i/30: Waiting for MariaDB..."
	sleep 1
done
if [ "$db_ready" != "true" ]; then
	echo "MariaDB did not become ready in time."
	exit 1
fi

if [ ! -f wp-login.php ] || [ ! -f wp-config.php ]; then
	if [ ! -f wp-login.php ]; then
		echo "Downloading WordPress..."
		wp core download --allow-root --path=/var/www/html
		sleep 1
	fi

	if [ ! -f wp-config.php ]; then
		echo "Creating wp-config.php..."
		wp config create \
			--allow-root \
			--path=/var/www/html \
			--dbname=${MYSQL_DATABASE} \
			--dbuser=${MYSQL_USER} \
			--dbpass=${MYSQL_PASSWORD} \
			--dbhost=mariadb \
			--skip-check || { echo "ERROR: wp config create failed!"; exit 1; }
	fi

	if ! wp core is-installed --allow-root >/dev/null 2>&1; then
		echo "Installing WordPress..."
		wp core install \
			--allow-root \
			--url=https://${DOMAIN_NAME} \
			--title=${WP_TITLE} \
			--admin_user=${WP_ADMIN} \
			--admin_password=${WP_ADMIN_PASSWORD} \
			--admin_email=${WP_ADMIN_EMAIL} || { echo "Install failed!"; exit 1; }
	fi

	if ! wp user get ${WP_USER} --allow-root >/dev/null 2>&1; then
		wp user create \
			--allow-root \
			${WP_USER} ${WP_USER_EMAIL} \
			--role=editor \
			--user_pass=${WP_USER_PASSWORD}
	fi

	setup_redis_cache

	echo "WordPress setup verified successfully!"
else
	echo "WordPress already installed, skipping setup..."
	setup_redis_cache
fi

echo "Starting PHP-FPM..."
exec php-fpm83 -F -R
