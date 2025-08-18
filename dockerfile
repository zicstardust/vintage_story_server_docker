FROM debian:13.0-slim

ENV DEBIAN_FRONTEND="noninteractive"

WORKDIR /app

COPY entrypoint.sh /entrypoint.sh
COPY download_server.sh /download_server.sh
COPY download_dotnet.sh /download_dotnet.sh
COPY run.sh /run.sh

RUN apt-get update; \
    apt-get install -y gosu jq wget


RUN chmod +x /entrypoint.sh /download_server.sh /download_dotnet.sh /run.sh

EXPOSE 42420/tcp

VOLUME [ "/data" ]

ENTRYPOINT [ "/entrypoint.sh" ]

CMD [ "/run.sh" ]
