# We're no longer using openjdk:17-slim as a base due to several unpatched vulnerabilities.
# The results from basing off of alpine are a smaller (by 47%) and faster (by 17%) image.
# Even with bash installed.     -Corbe
FROM alpine:latest

# Environment variables
ENV EULA="" \
    MC_RAM="" \
    JAVA_OPTS=""

COPY pufferfish.sh .
RUN apk update \
    && apk add openjdk17-jre-headless \
    && apk add bash \
    && apk add wget \
    && apk add jq \
    && mkdir /pufferfish

# Start script
CMD ["bash", "./pufferfish.sh"]

# Container setup
EXPOSE 25565/tcp
EXPOSE 25565/udp
VOLUME /pufferfish
