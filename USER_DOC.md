# User Documentation

This project runs a Docker-based web stack for WordPress. The mandatory services are Nginx, WordPress, and MariaDB. The bonus stack adds Redis caching, FTP access, Adminer, a static web page, Prometheus, Grafana, and node-exporter.

## Services Provided

### Mandatory stack

- **Nginx**: HTTPS reverse proxy exposed on port `443`.
- **WordPress**: the web application container.
- **MariaDB**: the database used by WordPress.

### Bonus stack

- **Redis**: cache used by WordPress when the bonus stack is enabled.
- **FTP server**: file transfer access to the WordPress volume.
- **Adminer**: database administration interface.
- **Static website**: a simple extra web page.
- **Prometheus**: metrics collection.
- **node-exporter**: host metrics exporter for Prometheus.
- **Grafana**: metrics dashboard.

## Start and Stop the Project

From the project root, use the Makefile commands below.

### Mandatory stack

```bash
make setup
make up
```

`make setup` creates the persistent data directories under `/home/dopereir/data/`, and `make up` builds and starts the mandatory containers in detached mode.

### Bonus stack

```bash
make bonus
```

This starts the full stack, including the bonus services.

### Stop or restart

```bash
make down
make stop
make start
make bonus_down
```

- `make down` stops the mandatory stack.
- `make stop` pauses the mandatory stack without removing containers.
- `make start` resumes stopped containers.
- `make bonus_down` stops the bonus stack.

### Clean the environment

```bash
make fclean
```

This removes the containers and prunes unused Docker resources.

## Access the Website and Administration Panel

Open the main website in a browser with:

```text
https://dopereir.42.fr
```

The mandatory Nginx container serves WordPress over HTTPS on port `443`.

The WordPress administration dashboard is available at:

```text
https://dopereir.42.fr/wp-admin/
```

Log in with the WordPress administrator credentials from `srcs/.env`.

When the bonus stack is running, the following paths are also available through the same domain:

- `https://dopereir.42.fr/adminer/` for Adminer
- `https://dopereir.42.fr/grafana/` for Grafana
- `https://dopereir.42.fr/static/` for the static page

Adminer connects to the MariaDB service. Grafana uses the credentials from the environment file described below.

## Locate and Manage Credentials

Project credentials are stored in `srcs/.env`, which should be created from `srcs/.env.example`.

The main values in that file are:

- MariaDB database name, user, password, and root password
- WordPress administrator and regular user credentials
- FTP username and password
- Grafana administrator username and password

If you change any of these values, update `srcs/.env` and rebuild or restart the stack so the services pick up the new configuration.

Database data, WordPress files, Grafana data, and Prometheus data are stored outside the containers under `/home/dopereir/data/`, so credentials and content survive container rebuilds.

## Check That the Services Are Running Correctly

The simplest checks are:

```bash
make ps
make logs
```

`make ps` shows the running services, and `make logs` follows the bonus stack logs.

You can also check the website directly:

```bash
curl -k https://dopereir.42.fr
```

For the bonus services, verify these endpoints in a browser or with `curl`:

- `/adminer/`
- `/grafana/`
- `/static/`

A healthy stack should show all containers as running, return the WordPress page over HTTPS, and load the bonus pages without errors when the bonus stack is enabled.
