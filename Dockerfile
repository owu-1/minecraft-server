FROM eclipse-temurin:17-jre-alpine

ENV MEMORY=1G

WORKDIR /data
COPY start.sh /

RUN apk add --no-cache \
        curl \
        jq && \
    chmod u+x /start.sh

CMD /start.sh
