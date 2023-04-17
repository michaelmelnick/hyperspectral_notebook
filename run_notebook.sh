#!/bin/bash
docker run -it --rm \
    -p 8888:8888 \
    --user root \
    -e NB_UID="$(id -u)" \
    -e NB_GID="$(id -g)" \
    -e CHOWN_HOME=yes \
    -e CHOWN_HOME_OPTS="-R" \
    -v "${PWD}:/home/jovyan/work" \
    hypyrspec
