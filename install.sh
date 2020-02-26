#!/bin/bash
DB_CONTAINER=moodle_db
PMA_CONTAINER=moodle_pma
APP_CONTAINER=moodle_app

if [ -z "$DOCKER_CMD" ]; then
  DOCKER_CMD=docker
fi
if [ -z "$DOCKER_COMPOSE_CMD" ]; then
  DOCKER_COMPOSE_CMD=docker-compose
fi
if [ -z "$WWW_HOST" ]; then
  WWW_HOST="localhost"
fi
if [ -z "$DB_NAME" ]; then
  DB_NAME="moodle"
fi
if [ -z "$DB_USER" ]; then
  DB_USER="root"
fi
if [ -z "$DB_PWD" ]; then
  DB_PWD="root"
fi

if [ "$1" == "--force" ]; then
  bash uninstall.sh
fi

if [ ! -d "app" ]; then
  curl -sS 'https://download.moodle.org/download.php/direct/stable38/moodle-latest-38.zip' -o moodle.zip
  unzip moodle.zip && rm moodle.zip && mv moodle app
fi

if [ ! -d "moodledata" ]; then
  mkdir moodledata
fi

if [ ! -f "./docker/apache/000-default.conf" ]; then
  cp ./docker/apache/000-default.conf.example ./docker/apache/000-default.conf
  sed -i "s/__WWW_HOST__/$WWW_HOST/g" ./docker/apache/000-default.conf
fi

if [ ! -f "docker-compose.yml" ]; then
  cp docker-compose.yml.example docker-compose.yml
  sed -i "s/__DB_NAME__/$DB_NAME/g" docker-compose.yml
  sed -i "s/__DB_USER__/$DB_USER/g" docker-compose.yml
  sed -i "s/__DB_PWD__/$DB_PWD/g" docker-compose.yml
fi

$DOCKER_COMPOSE_CMD up -d $DB_CONTAINER;
$DOCKER_COMPOSE_CMD up -d $PMA_CONTAINER;
$DOCKER_COMPOSE_CMD up -d $APP_CONTAINER;

$DOCKER_CMD exec -it $APP_CONTAINER service apache2 restart
$DOCKER_CMD exec -it $APP_CONTAINER chown www-data:www-data -R /var/www

echo 'Install completed'
