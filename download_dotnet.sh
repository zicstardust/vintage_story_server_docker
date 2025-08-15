#!/bin/bash

set -e

: "${DOTNET_VERSION:=8.0.19}"


if [ "$DOTNET_VERSION" == "mono" ]; then
    echo "Downloading mono..."
    apt-get update  &> /dev/null
    apt-get install -y mono-complete &> /dev/null
else
    echo "Downloading .NET Runtime ${DOTNET_VERSION}..."
    apt-get update &> /dev/null
    apt-get install -y libc6 libgcc-s1 libgssapi-krb5-2 libicu72 libssl3 libstdc++6 zlib1g  &> /dev/null
    mkdir -p dotnet_temp
    cd dotnet_temp
    wget https://builds.dotnet.microsoft.com/dotnet/Runtime/${DOTNET_VERSION}/dotnet-runtime-${DOTNET_VERSION}-linux-x64.tar.gz  &> /dev/null
    tar xf dotnet-runtime-${DOTNET_VERSION}-linux-x64.tar.gz
    mv /app/dotnet_temp/* /usr/local/bin
    cd /app
    rm -Rf /app/dotnet_temp
fi
