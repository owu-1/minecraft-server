FROM eclipse-temurin:17-jre-alpine AS build

ARG MINECRAFT_VERSION=1.19.2
ARG PAPERMC_BUILD=124
ARG COREPROTECT_VERSION=21.2
ARG SQUAREMAP_BUILD=206
ARG DISCORDSRV_VERSION=1.26.0
ARG DISCORDSRV_SNAPSHOT=20220811.184815-34

ENV MEMORY=1G

COPY start.sh /
WORKDIR /data
RUN apk add --no-cache --virtual .build \
    curl \
    jq && \
    # Download jars
    mkdir plugins && \
    curl -L -o paperclip.jar "https://api.papermc.io/v2/projects/paper/versions/$MINECRAFT_VERSION/builds/$PAPERMC_BUILD/downloads/paper-$MINECRAFT_VERSION-$PAPERMC_BUILD.jar" && \
    curl -L -o plugins/coreprotect.jar "https://github.com/PlayPro/CoreProtect/releases/download/v$COREPROTECT_VERSION/CoreProtect-$COREPROTECT_VERSION.jar" && \
    curl -L -o plugins/squaremap.jar "https://jenkins.jpenilla.xyz/job/squaremap/$SQUAREMAP_BUILD/artifact/build/libs/$(curl https://jenkins.jpenilla.xyz/job/squaremap/$SQUAREMAP_BUILD/api/json | jq -r '.artifacts | .[] | select(.fileName|test("paper")).fileName')" && \
    curl -L -o plugins/discordsrv.jar "https://nexus.scarsz.me/content/groups/public/com/discordsrv/discordsrv/$DISCORDSRV_VERSION-SNAPSHOT/discordsrv-$DISCORDSRV_VERSION-$DISCORDSRV_SNAPSHOT.jar" && \
    apk del .build && \
    # Create non-root user
    addgroup -S minecraft && adduser -S -G minecraft minecraft && \
    chown -R minecraft:minecraft /data && \
    chmod +x /start.sh && \
    echo "eula=true" > eula.txt
USER minecraft
# Run paperclip
RUN echo "stop" | /start.sh && \
    # Clean up
    rm -R logs/* worlds/world* plugins/CoreProtect/database.db

CMD ["/start.sh"]
