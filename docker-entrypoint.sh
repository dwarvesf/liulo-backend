#!/bin/sh
set -e
/bin/bash -c "REPLACE_OS_VARS=true /opt/app/bin/${APP_NAME} migrate"
/bin/bash -c "REPLACE_OS_VARS=true /opt/app/bin/${APP_NAME} seed"
/bin/bash -c "REPLACE_OS_VARS=true /opt/app/bin/${APP_NAME} foreground"
exec "$@"
