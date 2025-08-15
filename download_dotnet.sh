#!/bin/bash

set -e

: "${DOTNET_VERSION:=8.0.19}"


if [ "$DOTNET_VERSION" == "mono" ]; then
    apt-get update && apt-get install -y mono-complete
else
    apt-get update && apt-get install -y libc6 libgcc-s1 libgssapi-krb5-2 libicu72 libssl3 libstdc++6 zlib1g
    wget https://builds.dotnet.microsoft.com/dotnet/Runtime/${DOTNET_VERSION}/dotnet-runtime-${DOTNET_VERSION}-linux-x64.tar.gz
    tar xf dotnet-runtime-${DOTNET_VERSION}-linux-x64.tar.gz
    rm -f dotnet-runtime-${DOTNET_VERSION}-linux-x64.tar.gz
    mv /app/* /usr/local/bin
fi
