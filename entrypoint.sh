#!/bin/bash

set -e

: "${UID:=1000}"
: "${GID:=1000}"
#: "${USERNAME:=vintagestory}"

if ! getent group vintagestory >/dev/null; then
    groupadd -g "$GID" vintagestory
fi

if ! id -u vintagestory >/dev/null 2>&1; then
    useradd -m -u "$UID" -g "$GID" -s /sbin/nologin vintagestory
fi

mkdir -p /data

chown -R vintagestory:vintagestory /app /data

exec gosu vintagestory "$@"
#exec "$@"