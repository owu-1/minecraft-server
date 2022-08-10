#!/bin/sh
MINECRAFT_VERSION=1.19.2
AIKAR_FLAGS="-XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true"

cd /data
mkdir plugins

coreprotect() {
    download_url=$(curl -s https://api.github.com/repos/PlayPro/CoreProtect/releases/latest | jq -r '.assets[0].browser_download_url')
    curl -o plugins/coreprotect.jar -sL ${download_url}
}

discordsrv() {
    curl -o plugins/discordsrv.jar -s https://download.discordsrv.com/snapshot
}

papermc() {
    api_server=https://api.papermc.io
    latest_version_build=$(curl -s ${api_server}/v2/projects/paper/versions/${MINECRAFT_VERSION}/builds | jq '.builds[-1]')
    build_id=$(echo ${latest_version_build} | jq '.build')
    build_filename=$(echo ${latest_version_build} | jq -r '.downloads.application.name')
    curl -o paperclip.jar -s ${api_server}/v2/projects/paper/versions/${MINECRAFT_VERSION}/builds/${build_id}/downloads/${build_filename}
}

spark() {
    from_jenkins https://ci.lucko.me spark lastSuccessfulBuild bukkit plugins/spark.jar
}

squaremap() {
    from_jenkins https://jenkins.jpenilla.xyz squaremap lastSuccessfulBuild paper plugins/squaremap.jar
}

from_jenkins() {
    api_server=$1
    job=$2
    build_type=$3
    filename_test=$4
    output_filepath=$5
    relative_download_url=$(curl -s ${api_server}/job/${job}/${build_type}/api/json | jq -r --arg filename_test ${filename_test} '.artifacts | .[] | select(.fileName|test($filename_test)).relativePath')
    curl -o ${output_filepath} -s ${api_server}/job/${job}/${build_type}/artifact/${relative_download_url}
}

# Download jars
coreprotect & discordsrv & papermc & spark & squaremap & wait

# Run server
echo "eula=true" > eula.txt
java -Xms${MEMORY} -Xmx${MEMORY} ${AIKAR_FLAGS} -jar paperclip.jar --world-dir worlds
