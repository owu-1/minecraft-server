FROM eclipse-temurin:17-jre-alpine

ENV MINECRAFT_VERSION=1.19.2
ENV MEMORY=2G

WORKDIR /data
VOLUME /data/worlds /data/plugins/squaremap/web

COPY start.sh /
RUN apk add --no-cache \
        curl \
        jq && \
    chmod u+x /start.sh

CMD /start.sh
