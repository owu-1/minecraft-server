FROM eclipse-temurin:17-jre-alpine AS build

ARG MINECRAFT_VERSION=1.19.2
ARG PAPERMC_BUILD=124
ARG COREPROTECT_VERSION=21.2
ARG SQUAREMAP_BUILD=206
ARG DISCORDSRV_VERSION=1.26.0
ARG DISCORDSRV_SNAPSHOT=20220809.185518-24

WORKDIR /tmp/data
# Download packages for build
RUN apk add \
    curl \
    jq
# Download jars
RUN mkdir plugins && \
    curl -L -o paperclip.jar "https://api.papermc.io/v2/projects/paper/versions/$MINECRAFT_VERSION/builds/$PAPERMC_BUILD/downloads/paper-$MINECRAFT_VERSION-$PAPERMC_BUILD.jar" && \
    curl -L -o plugins/coreprotect.jar "https://github.com/PlayPro/CoreProtect/releases/download/v$COREPROTECT_VERSION/CoreProtect-$COREPROTECT_VERSION.jar" && \
    curl -L -o plugins/squaremap.jar "https://jenkins.jpenilla.xyz/job/squaremap/$SQUAREMAP_BUILD/artifact/build/libs/$(curl https://jenkins.jpenilla.xyz/job/squaremap/$SQUAREMAP_BUILD/api/json | jq -r '.artifacts | .[] | select(.fileName|test("paper")).fileName')" && \
    curl -L -o plugins/discordsrv.jar "https://nexus.scarsz.me/content/groups/public/com/discordsrv/discordsrv/$DISCORDSRV_VERSION-SNAPSHOT/discordsrv-$DISCORDSRV_VERSION-$DISCORDSRV_SNAPSHOT.jar"

FROM eclipse-temurin:17-jre-alpine

ENV MEMORY=1G
VOLUME /data/worlds /data/plugins/squaremap/web

WORKDIR /data
COPY --from=build /tmp/data /data
RUN addgroup -S minecraft && adduser -S -G minecraft minecraft && \
    chown -R minecraft:minecraft /data
USER minecraft
COPY start.sh /
RUN echo "eula=true" > eula.txt && \
    echo "stop" | /start.sh
CMD ["/start.sh"]
