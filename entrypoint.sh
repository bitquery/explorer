#!/bin/bash

set -e

export GEM_HOME="/app/vendor/bundle"
export GEM_PATH="${GEM_HOME}/ruby/2.6.0"
export PATH="${GEM_PATH}/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

if [ -f tmp/pids/app.pid ]; then
  rm tmp/pids/app.pid
fi

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
