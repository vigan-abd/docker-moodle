#!/bin/bash
DB_CONTAINER=moodle_db
PMA_CONTAINER=moodle_pma
APP_CONTAINER=moodle_app
APP_IMAGE="moodle_app:1.2"

if [ -z "$DOCKER_CMD" ]; then
  DOCKER_CMD=docker
fi
if [ -z "$DOCKER_COMPOSE_CMD" ]; then
  DOCKER_COMPOSE_CMD=docker-compose
fi
if [ -z "$CHOWN_CMD" ]; then
  CHOWN_CMD='chown'
fi

if [ -d "app" ]; then
  $CHOWN_CMD "${USER}:${USER}" -R app
  rm -r app
fi
if [ -d "moodledata" ]; then
  $CHOWN_CMD "${USER}:${USER}" -R moodledata
  rm -r moodledata
fi
if [ -f "./docker/apache/000-default.conf" ]; then
  rm ./docker/apache/000-default.conf
fi
if [ -f "./docker-compose.yml" ]; then
  rm docker-compose.yml
fi

$DOCKER_CMD stop $DB_CONTAINER
$DOCKER_CMD stop $PMA_CONTAINER
$DOCKER_CMD stop $APP_CONTAINER

$DOCKER_CMD rm $DB_CONTAINER
$DOCKER_CMD rm $PMA_CONTAINER
$DOCKER_CMD rm $APP_CONTAINER

$DOCKER_CMD rmi $APP_IMAGE

echo 'Uninstall completed'
