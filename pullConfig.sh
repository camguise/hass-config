#!/bin/bash

HASS_VERSION='0.89.1'
HASS_DIR='/usr/local/docker/hass'
LETSENCRYPT_DIR='/usr/local/docker/letsencrypt/config/etc/letsencrypt'

cd "${HASS_DIR}"

git pull

docker run -it --rm \
        -v "${HASS_DIR}/config":/config:ro \
        -v /etc/localtime:/etc/localtime:ro \
        -v "${LETSENCRYPT_DIR}":/etc/letsencrypt:ro \
        homeassistant/home-assistant:"${HASS_VERSION}" \
        python -m homeassistant --config /config --script check_config
