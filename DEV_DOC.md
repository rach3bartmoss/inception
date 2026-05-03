# Developer Documentation

This project is a Docker Compose stack for the 42 Inception subject. The mandatory services are Nginx, WordPress, and MariaDB. The bonus stack adds Redis, FTP, Adminer, a static web page, Prometheus, Grafana, and node-exporter.

## Set Up the Environment From Scratch

Before running the project, make sure the following prerequisites are installed:

- Docker Engine
- Docker Compose plugin
- permission to create directories under `/home/dopereir/data`

The project configuration is split across these files:

- `srcs/docker-compose.yml` for the mandatory stack
- `srcs/docker-compose.bonus.yml` for the bonus services
- `srcs/.env` for runtime secrets and configuration values
- `srcs/.env.example` as the template for the environment file

Start from the example environment file and create your local configuration:

```bash
cp srcs/.env.example srcs/.env
```

Then review and adapt the values in `srcs/.env` as needed. The file includes the domain name, MariaDB credentials, WordPress admin and user accounts, FTP credentials, Redis settings, and Grafana credentials.

The Makefile uses `/home/dopereir/data` as the persistent storage root. The current login value in the project is `dopereir`, so the data directory path resolves to `/home/dopereir/data`.

## Build and Launch the Project

### Mandatory stack

```bash
make setup
make up
```

`make setup` creates the persistent host directories, and `make up` builds the mandatory images and starts the containers in detached mode.

### Bonus stack

```bash
make bonus
```

This builds and launches the full stack, including the bonus services.

### Direct Docker Compose usage

The Makefile is the preferred entry point, but the compose files can also be used directly:

```bash
docker compose -f srcs/docker-compose.yml up -d --build
docker compose -f srcs/docker-compose.yml -f srcs/docker-compose.bonus.yml --env-file srcs/.env up -d --build
```

Use the first command for the mandatory stack and the second for the bonus stack.

## Manage Containers and Volumes

The Makefile includes the main management commands:

```bash
make down
make stop
make start
make build
make ps
make logs
make log s=nginx
make fclean
make bonus_down
```

Typical usage:

- `make down` stops the mandatory stack.
- `make stop` pauses the mandatory stack.
- `make start` restarts stopped containers.
- `make build` rebuilds images without using cache.
- `make ps` shows the running services in the bonus compose setup.
- `make logs` follows the bonus stack logs.
- `make log s=nginx` follows the logs for one service.
- `make bonus_down` stops the bonus stack.
- `make fclean` removes containers and prunes unused Docker resources.

The project uses named Docker volumes with bind-backed host storage for persistent data. The host directories are created under `/home/dopereir/data` and mapped to the service data directories inside the containers.

## Where Project Data Is Stored

Persistent data is stored outside the containers so it survives rebuilds and container recreation.

### Mandatory stack data

- WordPress data: `/home/dopereir/data/wordpress`
- MariaDB data: `/home/dopereir/data/mariadb`

### Bonus stack data

- Grafana data: `/home/dopereir/data/grafana`
- Prometheus data: `/home/dopereir/data/prometheus`

These paths are configured in the compose files as bind-backed Docker volumes. Rebuilding containers does not remove the stored application data.

## Configuration and Secrets

The runtime configuration is driven by `srcs/.env`. Update this file when you need to change:

- the domain name
- MariaDB database name and credentials
- WordPress administrator and user credentials
- FTP credentials
- Redis connection settings
- Grafana admin credentials

If you change any secret or environment value, restart the affected containers so they pick up the new configuration.

## Useful Notes for Developers

- Service build contexts live under `srcs/requirements/`.
- Each service has its own Dockerfile and, when needed, extra configuration files under `conf/` and startup scripts under `tools/`.
- The mandatory stack exposes WordPress through Nginx on HTTPS port `443`.
- The bonus stack extends the same Nginx entry point with Adminer, Grafana, and the static site.
