#!/bin/bash

/download_server.sh

if [ $? != 0 ]; then
    exit $?
fi

set -e

: "${UID:=1000}"
: "${GID:=1000}"

if ! getent group vintagestory >/dev/null; then
    groupadd -g "$GID" vintagestory
fi

if ! id -u vintagestory >/dev/null 2>&1; then
    useradd -m -u "$UID" -g "$GID" -s /sbin/nologin vintagestory
fi

mkdir -p /data

chown -R vintagestory:vintagestory /app /data

if [ -f "/app/VintagestoryServer.dll" ]; then
    exec gosu vintagestory dotnet /app/VintagestoryServer.dll --dataPath /data
elif [ -f "/app/vintagestory/VintagestoryServer.exe" ]; then
    exec gosu vintagestory mono /app/vintagestory/VintagestoryServer.exe --dataPath /data
else
    exit 1
fi