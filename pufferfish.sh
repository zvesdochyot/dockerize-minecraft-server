#!/bin/bash

# Enter server directory
cd pufferfish

# Server jar variables
JAR_NAME="pufferfish-1.20.1-build27.jar"
URL="https://ci.pufferfish.host/job/Pufferfish-1.20/27/artifact/build/libs/pufferfish-paperclip-1.20.1-R0.1-SNAPSHOT-reobf.jar"

# Update if necessary
if [[ ! -e $JAR_NAME ]]
then
  # Remove old server jar(s)
  rm -f *.jar
  # Download new server jar
  wget "$URL" -O "$JAR_NAME"
fi

# Update eula.txt with current setting
echo "eula=${EULA:-false}" > eula.txt

# Add RAM options to Java options if necessary
if [[ -n $MC_RAM ]]
then
  JAVA_OPTS="-Xms${MC_RAM} -Xmx${MC_RAM} $JAVA_OPTS"
fi

# Start server
exec java -server $JAVA_OPTS -jar "$JAR_NAME" nogui
