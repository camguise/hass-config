#!/bin/bash

HASS_VERSION='0.89.1'
HASS_DIR='/usr/local/docker/hass'
LETSENCRYPT_DIR='/usr/local/docker/letsencrypt/config/etc/letsencrypt'

GREEN='\033[0;36m'
NC='\033[0m' # No Color

# make sure we're running as root
if (( `/usr/bin/id -u` != 0 )); then { echo "Sorry, must be root.  Exiting..."; exit; } fi

cd "${HASS_DIR}"

git pull

chown -R root:docker "${HASS_DIR}"

configTest=$( docker run -it --rm \
        -v "${HASS_DIR}/config":/config:ro \
        -v /etc/localtime:/etc/localtime:ro \
        -v "${LETSENCRYPT_DIR}":/etc/letsencrypt:ro \
        homeassistant/home-assistant:"${HASS_VERSION}" \
        python -m homeassistant --config /config --script check_config )

validConfig='[01mTesting configuration at /config[0m
[0m'
configTestPrintable=$(echo "${configTest}" | tr -cd "[:print:]\n")

if [[ "${configTestPrintable}" == "${validConfig}" ]]; then
	echo -e "${GREEN}Configuration is Valid${NC}"
	docker-compose restart
else
	echo "${configTest}"
fi
