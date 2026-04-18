*This project has been created as part of the 42 curriculum by dopereir.*

# inception

## Description
Inception is a system administration project focused on learning Docker by building and orchestrating a small service stack inside a virtual machine. The mandatory part of the project deploys Nginx, WordPress, and MariaDB as separate containers connected through a dedicated Docker network.

The bonus stack extends that setup with Redis caching, an FTP server, Adminer, a static web page, Prometheus, Grafana, and node-exporter. The repository includes the Dockerfiles, service configuration files, and startup scripts needed to build each image and launch the full environment with Docker Compose.

The main design choices are:

- one container per service
- a dedicated bridge network for internal communication
- persistent data stored outside the containers
- environment-based configuration loaded from `.env`
- shell entrypoints for service initialization

## Instructions
Prerequisites:

- Docker Engine
- Docker Compose plugin
- permission to create the persistent data directories used by the project

Base stack:

```bash
make setup
make up
```

Bonus stack:

```bash
make bonus
```

Useful commands:

```bash
make down
make stop
make start
make build
make ps
make logs
make log s=nginx
make fclean
```

Before running the stack, make sure the data directories referenced by the Makefile exist under `/home/dopereir/data`. The project uses `srcs/.env` for the domain name, database credentials, WordPress users, FTP credentials, Redis, and Grafana settings.

## Project Description
The project is built around Docker images stored in `srcs/requirements/`. Each service has its own Dockerfile and, when needed, extra configuration files and startup scripts. The base stack uses:

- Nginx as the HTTPS reverse proxy
- WordPress as the application layer
- MariaDB as the database layer

The bonus stack adds:

- Redis for WordPress object caching
- FTP for file transfer access to the WordPress volume
- Adminer for lightweight database administration
- a static web page for a simple extra service
- Prometheus and node-exporter for monitoring
- Grafana for metrics visualization

### Docker and source layout
Docker is used to isolate each service, rebuild the environment reliably, and keep the setup reproducible across machines. The repository sources are organized by service so that each container can be understood independently:

- `srcs/docker-compose.yml` defines the mandatory stack
- `srcs/docker-compose.bonus.yml` adds the bonus services
- `srcs/.env` stores the project configuration values
- `srcs/requirements/<service>/Dockerfile` builds each image
- `srcs/requirements/<service>/conf/` contains runtime configuration
- `srcs/requirements/<service>/tools/` contains initialization scripts

### Technical comparisons

| Topic | Choice in this project | Why |
| --- | --- | --- |
| Virtual Machines vs Docker | Docker containers inside the VM | Containers are lighter, faster to rebuild, and easier to automate than full virtual machines. The VM provides the host isolation required by the project, while Docker handles application isolation. |
| Secrets vs Environment Variables | Environment variables in `.env` | Environment variables are simple and fit the 42 evaluation workflow. Docker secrets would be safer for highly sensitive data, but they are more relevant to production setups than to this classroom project. |
| Docker Network vs Host Network | Dedicated bridge network | The bridge network keeps internal traffic isolated and predictable. Host networking would reduce isolation and make the stack less portable. |
| Docker Volumes vs Bind Mounts | Persisted host-backed storage for the service data | The project keeps WordPress, MariaDB, Grafana, and Prometheus data outside the containers so data survives rebuilds. Bind-mounted paths make the storage location explicit and easy to inspect during evaluation. |

## Resources
Classic references:

- Docker Compose file reference: https://docs.docker.com/reference/compose-file/
- Docker networking documentation: https://docs.docker.com/network/
- Docker volumes documentation: https://docs.docker.com/engine/storage/volumes/
- Nginx documentation: https://nginx.org/en/docs/
- WordPress documentation: https://wordpress.org/documentation/
- MariaDB documentation: https://mariadb.com/kb/en/documentation/
- Redis documentation: https://redis.io/docs/latest/
- Adminer documentation: https://www.adminer.org/en/
- Prometheus documentation: https://prometheus.io/docs/introduction/overview/
- Grafana documentation: https://grafana.com/docs/grafana/latest/
- vsftpd documentation: https://security.appspot.com/vsftpd.html

AI usage:

- AI was used to draft and polish the README structure.
- AI was used to organize the project description, instructions, and comparison sections.
- AI was used only for documentation support; the actual service architecture, compose files, and configuration values come from the project files in this repository.