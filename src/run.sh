#!/bin/bash

if [ -f "/app/VintagestoryServer.dll" ]; then
    DOTNET_ROOT="/opt/dotnet" dotnet /app/VintagestoryServer.dll --dataPath /data
elif [ -f "/app/vintagestory/VintagestoryServer.exe" ]; then
    mono /app/vintagestory/VintagestoryServer.exe --dataPath /data
else
    exit 1
fi