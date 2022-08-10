#!/bin/sh
MINECRAFT_VERSION=1.19.2
AIKAR_FLAGS="-XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true"
JAVA_FLAGS="-Xms${MEMORY} -Xmx${MEMORY} ${AIKAR_FLAGS}"

cd /data
mkdir plugins -p

jenkins_dl() {
    api_server=$1
    job=$2
    build_type=$3
    filename_test=$4
    relative_download_url=$(curl -s ${api_server}/job/${job}/${build_type}/api/json | jq -r --arg filename_test ${filename_test} '.artifacts | .[] | select(.fileName|test($filename_test)).relativePath')
    echo ${api_server}/job/${job}/${build_type}/artifact/${relative_download_url}
}

# Download urls
coreprotect() {
    curl -s https://api.github.com/repos/PlayPro/CoreProtect/releases/latest | jq -r '.assets[0].browser_download_url'
}
discordsrv() {
    echo https://download.discordsrv.com/snapshot
}
papermc() {
    api_server=https://api.papermc.io
    latest_version_build=$(curl -s ${api_server}/v2/projects/paper/versions/${MINECRAFT_VERSION}/builds | jq '.builds[-1]')
    build_id=$(echo ${latest_version_build} | jq '.build')
    build_filename=$(echo ${latest_version_build} | jq -r '.downloads.application.name')
    echo ${api_server}/v2/projects/paper/versions/${MINECRAFT_VERSION}/builds/${build_id}/downloads/${build_filename}
}
spark() {
    jenkins_dl https://ci.lucko.me spark lastSuccessfulBuild bukkit
}
squaremap() {
    jenkins_dl https://jenkins.jpenilla.xyz squaremap lastSuccessfulBuild paper
}

# Download jars
for url in coreprotect discordsrv papermc spark squaremap
do
    curl -sL $($url) -o $url.jar &
done

# download coreprotect plugins/coreprotect.jar & \
# download discordsrv plugins/discordsrv.jar & \
# download $(papermc) paperclip.jar & \
# download spark plugins/spark.jar & \
# download squaremap plugins/squaremap.jar
wait

# Run server
echo "eula=true" > eula.txt
java ${JAVA_FLAGS} -jar paperclip.jar --world-dir worlds
