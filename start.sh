#!/bin/bash
AIKAR_FLAGS=(-XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true)
JAVA_FLAGS=(-Xms${MEMORY} -Xmx${MEMORY})

# Create plugins folder (if non-existent)
cd /data
if [ ! -f plugins ]
then
    mkdir -p plugins
else
	rm -r plugins
	mkdir plugins
fi

jenkins() {
	api=$1
	job=$2
	build_type=$3
	filename_test=$4
	out_path=$5
    relative_url=$(curl -s ${api}/job/${job}/${build_type}/api/json | jq -r --arg filename_test ${filename_test} '.artifacts | .[] | select(.fileName|test($filename_test)).relativePath')
    echo ${api}/job/${job}/${build_type}/artifact/${relative_url}
}

# Plugin Download URLs
CoreProtect=$(curl -s https://api.github.com/repos/PlayPro/CoreProtect/releases/latest | jq -r '.assets[0].browser_download_url')
DiscordSRV=https://download.discordsrv.com/snapshot
Spark=$(jenkins https://ci.lucko.me spark lastSuccessfulBuild bukkit)
SquareMap=$(jenkins https://jenkins.jpenilla.xyz squaremap lastSuccessfulBuild paper)
PaperMC() {
	api=https://api.papermc.io
	main_path=v2/projects/paper/versions/${MINECRAFT_VERSION}/builds
	build_metadata=$(curl -s ${api}/${main_path} | jq '.builds[-1]')
	build_id=$(echo ${build_metadata} | jq '.build')
	build_name=$(echo ${build_metadata} | jq -r '.downloads.application.name')
	echo ${api}/${main_path}/${build_id}/downloads/${build_name}
}

# Download jars
for url in $(PaperMC) ${CoreProtect} ${DiscordSRV} ${Spark} ${SquareMap}
do
	echo "Downloading $(basename ${url%.*})..."
	if [[ ! $url =~ "api.papermc.io" ]]
	then
		curl -sL ${url} -o plugins/$(basename ${url%.*}).jar &
	else
		curl -sL ${url} -o paperclip.jar &
	fi
done & wait

# Accept EULA if it hasn't been
if [ ! -f ./eula.txt ]
then
    echo "eula=true" > eula.txt
fi

# Start server
java ${AIKAR_FLAGS} ${JAVA_FLAGS} --world-dir worlds -jar paperclip.jar
