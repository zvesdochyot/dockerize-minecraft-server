FROM alpine:latest

# Environment variables
ENV MC_VERSION="latest" \
    PAPER_BUILD="latest" \
    EULA="" \
    MC_RAM="" \
    JAVA_OPTS=""

COPY fabric-server.sh .
RUN apk update \
    && apk add openjdk17-jre-headless \
    && apk add bash \
    && apk add wget \
    && apk add jq \
    && mkdir /fabric-server

# Start script
CMD ["bash", "./fabric-server.sh"]

# Container setup
EXPOSE 25565/tcp
EXPOSE 25565/udp
VOLUME /fabric-server
