#!/bin/sh
# Fallback so the lab is completable even if `template` does not write into
# the container: build the same file from the environment instead.
set -e
mkdir -p /tmp/generated
cat > /tmp/generated/app.conf <<CONF
# generated for ${APP_NAME} (${CODENAME})
listen        = 8080
replicas      = ${REPLICAS}
build_id      = ${BUILD_ID}
session_id    = ${SESSION_ID}
db_password   = ${DB_PASSWORD}
CONF
