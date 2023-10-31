#!/bin/bash

# Enter server directory
cd fabric-server

# Set nullstrings back to 'latest'
: ${MC_VERSION:='latest'}
: ${LOADER_VERSION:='latest'}

# Get the latest Fabric installer version
INSTALLER_VERSION=$(wget -qO - "https://meta.fabricmc.net/v2/versions/installer" | jq -r '.[0].version')

# Get the latest Minecraft version
if [[ $MC_VERSION == latest ]]
then
  MC_VERSION=$(wget -qO - "https://meta.fabricmc.net/v2/versions/game" | jq -r 'map(select(.stable == true)) | .[0].version')
fi

# Get the latest Fabric loader version
if [[ $LOADER_VERSION == latest ]]
then
  LOADER_VERSION=$(wget -qO - https://meta.fabricmc.net/v2/versions/loader/${MC_VERSION} | jq -r '.[0].loader.version')
fi

JAR_URL="https://meta.fabricmc.net/v2/versions/loader/${MC_VERSION}/${LOADER_VERSION}/${INSTALLER_VERSION}/server/jar"
JAR_NAME="fabric-server-${MC_VERSION}-${LOADER_VERSION}-${INSTALLER_VERSION}.jar"

# Update server jar if necessary
if [[ ! -e $JAR_NAME ]]
then
  rm -rf *.jar
  wget "$JAR_URL" -O "$JAR_NAME"
fi

# Update eula.txt with current setting
echo "eula=${EULA:-false}" > eula.txt

# Add RAM allocation options to Java options if necessary
if [[ -n $MC_RAM ]]
then
  JAVA_OPTS="-Xms${MC_RAM} -Xmx${MC_RAM} $JAVA_OPTS"
fi

echo $JAR_URL
echo $JAR_NAME
# Start Fabric server
exec java -server $JAVA_OPTS -jar "$JAR_NAME" nogui
