FROM eclipse-temurin:17-jre-alpine

WORKDIR /tmp/papermc

ARG MINECRAFT_VERSION=1.19.2
ARG PAPERMC_BUILD=123
ARG COREPROTECT_VERSION=21.2
ARG SQUAREMAP_BUILD=204
ARG DISCORDSRV_VERSION=1.26.0
ARG DISCORDSRV_SNAPSHOT=20220809.185518-24

# Download packages for build
RUN apk add \
    curl \
    jq

# Download jars
RUN curl -L -o paperclip.jar "https://api.papermc.io/v2/projects/paper/versions/$MINECRAFT_VERSION/builds/$PAPERMC_BUILD/downloads/paper-$MINECRAFT_VERSION-$PAPERMC_BUILD.jar" && \
    curl -L -o coreprotect.jar "https://github.com/PlayPro/CoreProtect/releases/download/v$COREPROTECT_VERSION/CoreProtect-$COREPROTECT_VERSION.jar" && \
    curl -L -o squaremap.jar "https://jenkins.jpenilla.xyz/job/squaremap/$SQUAREMAP_BUILD/artifact/build/libs/$(curl https://jenkins.jpenilla.xyz/job/squaremap/$SQUAREMAP_BUILD/api/json | jq -r '.artifacts | .[] | select(.fileName|test("paper")).fileName')" && \
    curl -L -o discordsrv.jar "https://nexus.scarsz.me/content/groups/public/com/discordsrv/discordsrv/$DISCORDSRV_VERSION-SNAPSHOT/discordsrv-$DISCORDSRV_VERSION-$DISCORDSRV_SNAPSHOT.jar"

# Generate patched server and configs
COPY start.sh /tmp/papermc
RUN echo "eula=true" > eula.txt && \
    chmod u+x start.sh && \
    echo "stop" | MEMORY=1G ./start.sh
