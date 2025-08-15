#!/bin/bash

set -e

: "${DOTNET_VERSION:=8.0.19}"


wget https://builds.dotnet.microsoft.com/dotnet/Runtime/${DOTNET_VERSION}/dotnet-runtime-${DOTNET_VERSION}-linux-x64.tar.gz
tar xf dotnet-runtime-${DOTNET_VERSION}-linux-x64.tar.gz
rm -f dotnet-runtime-${DOTNET_VERSION}-linux-x64.tar.gz
mv /app/* /usr/local/bin
