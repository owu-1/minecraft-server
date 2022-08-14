FROM eclipse-temurin:17-jre-alpine

ARG VELOCITY_VERSION=3.1.2-SNAPSHOT
ARG VELOCITY_BUILD=172

ENV MEMORY=512M

COPY start.sh /
WORKDIR /data
RUN apk add --no-cache --virtual .build \
    curl \
    jq && \
    curl -L -o velocity.jar "https://api.papermc.io/v2/projects/velocity/versions/$VELOCITY_VERSION/builds/$VELOCITY_BUILD/downloads/velocity-$VELOCITY_VERSION-$VELOCITY_BUILD.jar" && \
    apk del .build && \
    # Create non-root user
    addgroup -S velocity && adduser -S -G velocity velocity && \
    chown -R velocity:velocity /data && \
    chmod +x /start.sh
USER velocity
# Run velocity
RUN echo "stop" | /start.sh && \
    # Clean up
    rm -R forwarding.secret logs/* plugins/bStats

CMD ["/start.sh"]
