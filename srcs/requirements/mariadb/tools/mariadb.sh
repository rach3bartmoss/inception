#!/bin/sh

# Create runtime directory for socket
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld
chown -R mysql:mysql /var/lib/mysql

# Initialize the database only if not already done
if [ ! -d "/var/lib/mysql/mysql" ]; then
	echo "Initializing MariaDB data directory..."
	mysql_install_db --user=mysql --datadir=/var/lib/mysql > /dev/null

	# Start MariaDB temporarily to run setup queries
	mysqld --user=mysql --bootstrap << EOF
FLUSH PRIVILEGES;

-- Remove anonymous users
DELETE FROM mysql.user WHERE User='';

-- Remove remote root access
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1');

-- Remove test database
DROP DATABASE IF EXISTS test;

-- Create WordPress database
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};

-- Create WordPress user
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';

-- Grant privileges to WordPress user
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';

-- Set root password
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';

FLUSH PRIVILEGES;
EOF

	echo "MariaDB initialized successfully."
fi

# Start MariaDB in foreground
exec mysqld --user=mysql
