FROM eclipse-temurin:17-jre-alpine

ENV MEMORY=1G

WORKDIR /data
VOLUME /data/worlds /data/plugins/squaremap/web
COPY start.sh /

RUN apk add --no-cache \
        curl \
        jq && \
    chmod u+x /start.sh

CMD /start.sh
