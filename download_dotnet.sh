#!/bin/bash

set -e

: "${DOTNET_VERSION:=8.0.19}"


if [[ $(uname -m) == "aarch64" ]]; then
  ARCH="arm64"
elif [[ $(uname -m) == "x86_64" ]]; then
  ARCH="x64"
fi

if [ "$DOTNET_VERSION" == "mono" ]; then
    echo "Downloading mono..."
    apt-get update  &> /dev/null
    apt-get install -y mono-complete &> /dev/null
else
    echo "Downloading .NET Runtime ${DOTNET_VERSION}..."
    apt-get update &> /dev/null
    apt-get install -y libc6 libgcc-s1 libgssapi-krb5-2 libicu76 libssl3 libstdc++6 zlib1g  &> /dev/null
    mkdir -p /opt/dotnet
    cd /opt/dotnet
    wget -q https://builds.dotnet.microsoft.com/dotnet/Runtime/${DOTNET_VERSION}/dotnet-runtime-${DOTNET_VERSION}-linux-${ARCH}.tar.gz
    tar xzf dotnet-runtime-${DOTNET_VERSION}-linux-${ARCH}.tar.gz
    rm -f dotnet-runtime-${DOTNET_VERSION}-linux-${ARCH}.tar.gz
    ln -s /opt/dotnet/dotnet /usr/local/bin/dotnet
    cd /app
fi
