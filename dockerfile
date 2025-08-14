FROM debian:12-slim AS build

ARG SERVER_VERSION="1.20.12"

WORKDIR /app

RUN apt-get update && apt-get install -y wget; \
    wget https://cdn.vintagestory.at/gamefiles/stable/vs_server_linux-x64_${SERVER_VERSION}.tar.gz; \
    tar xzf vs_server_linux-x64_${SERVER_VERSION}.tar.gz; \
    rm -f vs_server_linux-x64_${SERVER_VERSION}.tar.gz


RUN wget https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb -O /app/packages-microsoft-prod.deb


#RUN sed -i "s|VSPATH='/home/vintagestory/server'|VSPATH='/app'|" /app/server.sh

#RUN sed -i "s|DATAPATH='/var/vintagestory/data'|DATAPATH='/data'|" /app/server.sh


FROM debian:12-slim

ENV UID=1000
ENV GID=1000

WORKDIR /app

COPY --from=build /app /app
COPY entrypoint.sh /entrypoint.sh

RUN apt-get update; \
    apt-get install -y ca-certificates; \
    dpkg -i /app/packages-microsoft-prod.deb; \
    rm -f /app/packages-microsoft-prod.deb; \
    apt-get update; \
    apt-get install -y dotnet-runtime-7.0 gosu


RUN chmod +x /entrypoint.sh

EXPOSE 42420/tcp

VOLUME [ "/data" ]

ENTRYPOINT [ "/entrypoint.sh" ]

#CMD [ "/app/server.sh", "start" ]
CMD [ "dotnet", "/app/VintagestoryServer.dll", "--dataPath", "/data" ]
