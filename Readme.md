# Docker config for Moodle

## Prequises

Before installing moodle make sure you have install docker and docker-compose tools, also make sure that you have root access to your host.

## Setup

In order to setup the site you have simply to run `install.sh` script, it will deal with all dependencies and configurations. The script also supports optional --force argument which deletes previous setup entirely.

The config supports also these optional env vars:
- `DOCKER_CMD` - Optional, docker command, default value `docker`
- `DOCKER_COMPOSE_CMD` - Optional, docker compose command, default value `docker-compose`
- `WWW_HOST` - Optional, website hostname, default value `localhost`
- `CHOWN_CMD` - Optional, change ownership command, default value `chown`

Default usage:
```bash
./install.sh
```

Example usage with multiple configs:
```bash
DB_NAME=moodle_test DB_USER=root DB_PWD=test CHOWN_CMD='sudo chown' WWW_HOST='www.example.com' ./install.sh --force
```

### Database params

When installing moodle in browser make sure that you use the following params in db section:
- Host: `moodle_db`
- Database: `MYSQL_DATABASE` env var from docker-compose.yml
- User: `MYSQL_ROOT_USER` env var from docker-compose.yml
- Password: `MYSQL_ROOT_PASSWORD` env var from docker-compose.yml

## Removal

The entire setup can be removed simply by running `uninstall.sh`
```bash
./uninstall.sh
```

Example usage with multiple configs:
```bash
CHOWN_CMD='sudo chown' DOCKER_CMD='sudo docker' ./uninstall.sh --force
```
