FROM debian:12-slim

WORKDIR /app

COPY entrypoint.sh /entrypoint.sh
COPY download_server.sh /download_server.sh
COPY download_dotnet.sh /download_dotnet.sh

RUN apt-get update; \
    apt-get install -y gosu jq wget libc6 libgcc-s1 libgssapi-krb5-2 libicu72 libssl3 libstdc++6 zlib1g


RUN chmod +x /entrypoint.sh /download_server.sh /download_dotnet.sh

EXPOSE 42420/tcp

VOLUME [ "/data" ]

ENTRYPOINT [ "/entrypoint.sh" ]

CMD [ "dotnet", "/app/VintagestoryServer.dll", "--dataPath", "/data" ]
