#!/bin/bash

set -e

if [ -f /run/app.pid ]; then
  rm /run/app.pid
fi

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
