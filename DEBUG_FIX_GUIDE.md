# WordPress 502 Bad Gateway - Debug & Fix Guide

## Issues Found and Fixed:

### 1. ✅ FIXED: PHP-FPM Configuration
- **Problem**: PHP-FPM was using default config that only listens on 127.0.0.1, making it unavailable to nginx over Docker network
- **Solution**: Created `/srcs/requirements/wordpress/conf/www.conf` with proper network configuration
  - PHP-FPM now listens on `0.0.0.0:9000`
  - Updated Docker to copy this config

### 2. ✅ FIXED: PHP Configuration
- **Problem**: No custom PHP settings, may cause file upload/memory issues
- **Solution**: Created `/srcs/requirements/wordpress/conf/php.ini` with optimized settings

### 3. ✅ FIXED: Volume Mount Paths
- **Problem**: docker-compose.yml had hardcoded paths to `/home/dopereir/` but your username is `rache`
- **Solution**: Updated docker-compose.yml to use `/home/rache/data/` paths

### 4. ✅ FIXED: Startup Script
- **Problem**: MariaDB wait condition was too strict
- **Solution**: Improved wordpress.sh with better error handling and retry logic

## Next Steps to Complete:

### Step 1: Add Domain to /etc/hosts
The nginx is configured to serve `dopereir.42.fr`. You need to add this to your VM's /etc/hosts:

```bash
sudo nano /etc/hosts
```

Add this line:
```
127.0.0.1 dopereir.42.fr
```

Save (Ctrl+X, Y, Enter in nano)

### Step 2: Rebuild & Restart Containers
```bash
# Full clean rebuild
make fclean
make re

# Or from the project directory:
cd /home/rache/programing/42/Common\ Core/inception
make fclean
make re
```

### Step 3: Wait for WordPress Setup
The first startup will take 1-2 minutes as it:
- Waits for MariaDB
- Downloads WordPress
- Creates wp-config.php
- Installs WordPress
- Creates admin user

Monitor with:
```bash
make logs
```

### Step 4: Access WordPress
Open your VM browser and go to:
```
https://dopereir.42.fr
```

⚠️ **Browser Warning**: You'll see a self-signed certificate warning (this is expected). Accept it.

## Debugging Commands:

```bash
# Check container status
make ps

# View all logs
make logs

# View specific service logs
make log s=wordpress    # WordPress logs
make log s=nginx        # Nginx logs
make log s=mariadb      # MariaDB logs

# Execute commands inside containers
docker-compose -f srcs/docker-compose.yml exec wordpress sh
docker-compose -f srcs/docker-compose.yml exec nginx sh
docker-compose -f srcs/docker-compose.yml exec mariadb sh

# Check PHP-FPM is running
docker-compose -f srcs/docker-compose.yml exec wordpress ps aux | grep php-fpm
```

## If Still Having Issues:

1. **Check PHP-FPM listening**:
   ```bash
   docker-compose -f srcs/docker-compose.yml exec wordpress ss -tlnp | grep 9000
   ```
   Should show: `php-fpm83` listening on `*:9000`

2. **Test nginx→wordpress connection**:
   ```bash
   docker-compose -f srcs/docker-compose.yml exec nginx nslookup wordpress
   ```

3. **Check WordPress files exist**:
   ```bash
   ls -la /home/rache/data/wordpress/
   ```

4. **View nginx error logs**:
   ```bash
   docker-compose -f srcs/docker-compose.yml exec nginx cat /var/log/nginx/error.log
   ```

## Common Credentials:
- Admin User: `admin` / Password: `adminpassword`
- DB User: `wpuser` / Password: `wppassword`
- DB Root: `root` / Password: `rootpassword`
