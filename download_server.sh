#!/bin/bash

set -e

: "${VERSION:=latest}"


STABLE_URL="https://cdn.vintagestory.at/gamefiles/stable/vs_server_linux-x64_"
UNSTABLE_URL="https://cdn.vintagestory.at/gamefiles/unstable/vs_server_linux-x64_"

STABLE_JSON=$(wget -qO- https://api.vintagestory.at/stable.json)
LATEST_STABLE=$(echo "$STABLE_JSON" | jq -r 'keys_unsorted[0]')

UNSTABLE_JSON=$(wget -qO- https://api.vintagestory.at/unstable.json)
LATEST_UNSTABLE=$(echo "$UNSTABLE_JSON" | jq -r 'keys_unsorted[0]')



if [ "$VERSION" == "latest" ]; then
    VERSION="$LATEST_STABLE"
elif [ "$VERSION" == "latest-unstable" ]; then
    VERSION="$LATEST_UNSTABLE"
fi


if [ -f /app/VintagestoryServer.dll ] && [ -f /app/current_version ] && [ "$(cat /app/current_version)" == "$VERSION" ]; then
    echo "Game Server ${VERSION} is downloaded"
    exit 0
fi

if [[ $VERSION == 1.2* ]] && [[ $VERSION != 1.20* ]]; then
    /download_dotnet.sh
else
    DOTNET_VERSION="7.0.20" /download_dotnet.sh
fi



STABLE_FULL_URL="${STABLE_URL}${VERSION}.tar.gz"
UNSTABLE_FULL_URL="${UNSTABLE_URL}${VERSION}.tar.gz"


if wget --spider -q "$STABLE_FULL_URL" 2>/dev/null; then
    DOWNLOAD_URL="$STABLE_FULL_URL"
    echo "Downloading Vintage Story Server version ${VERSION} from stable..."
    if [ "$VERSION" != "$LATEST_STABLE" ]; then
        echo "NOTE: You are running stable version ${VERSION} but version ${LATEST_STABLE} is available!"
    else
        echo "NOTE: Current version ${VERSION} is the latest stable version"
    fi
elif wget --spider -q "$UNSTABLE_FULL_URL" 2>/dev/null; then
    DOWNLOAD_URL="$UNSTABLE_FULL_URL"
    echo "Downloading Vintage Story Server version ${VERSION} from unstable..."
    if [ "$VERSION" != "$LATEST_UNSTABLE" ]; then
        echo "NOTE: You are running unstable version ${VERSION} but version ${LATEST_UNSTABLE} is available!"
    else
        echo "NOTE: Current version ${VERSION} is the latest unstable version"
    fi
else
    echo "ERROR: Version ${VERSION} not found in either stable or unstable channels"
    exit 1
fi


wget -q "$DOWNLOAD_URL"
tar xzf vs_server_linux-x64_${VERSION}.tar.gz
rm vs_server_linux-x64_${VERSION}.tar.gz

echo "$VERSION" > current_version