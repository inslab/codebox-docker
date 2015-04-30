#!/bin/bash
set -e

CODEBOX_USER=${CODEBOX_USER:-admin}
CODEBOX_PASS=${CODEBOX_PASS:-admin}

service nginx start

codebox run /opt/codebox_data/workspace -u ${CODEBOX_USER}:${CODEBOX_PASS}
