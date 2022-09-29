#!/bin/bash
mkdir -p plugins
cd plugins || exit

github_api=api.github.com
modrinth_api=api.modrinth.com
bergerhealer_ci=ci.mg-dev.eu
lucko_ci=ci.lucko.me

myworlds_build=172      # Build must be >=159 to support rejoin world groups with /world lastposition merge [world1] [world2] ...
bkcommonlib_build=1390  # Build must be >=1386 to avoid error messages - https://github.com/bergerhealer/BKCommonLib/issues/147
coreprotect_version=21.2
discordsrv_version=1.26.0
spark_build=339
luckperms_build=1453
squaremap_version=1.1.8
simple_voice_chat_version=1.19.2-2.3.6

# todo: Unnecessary filename tests

jenkins() {
    local jenkins_server=$1
    local job=$2
    local build=$3
    local filename_test=$4
    relative_path=$(curl -s https://"$jenkins_server"/job/"${job}"/"${build}"/api/json | jq -r --arg filename_test "${filename_test}" '.artifacts | .[] | select(.fileName|test($filename_test)).relativePath')
    echo "${jenkins_server}/job/${job}/${build}/artifact/${relative_path}"
}

github() {
    local owner=$1
    local repo=$2
    local tag=$3
    local filename_test=$4
    curl "https://${github_api}/repos/${owner}/${repo}/releases/tags/v${tag}" | jq -r --arg filename_test "${filename_test}" '.assets | .[] | select(.name|test($filename_test)).browser_download_url'
}

modrinth() {
    local project_id=$1
    local filename_test=$2
    curl -G "https://${modrinth_api}/v2/project/${project_id}/version" --data-urlencode 'loaders=["bukkit"]' | jq -r --arg filename_test "${filename_test}" '.[] | select(.version_number|test($filename_test)).files[0].url'
}

echo Downloading MyWorlds
curl -L "$(jenkins ${bergerhealer_ci} MyWorlds ${myworlds_build} '^MyWorlds-.+-v\d+-(?:SNAPSHOT-)?\d+\.jar')" -o myworlds-${myworlds_build}.jar

echo Downloading BkCommonLib
curl -L "$(jenkins ${bergerhealer_ci} BKCommonLib ${bkcommonlib_build} '^BKCommonLib-.+-v\d+-(?:SNAPSHOT-)?\d+\.jar')" -o bkcommonlib-${bkcommonlib_build}.jar

echo Downloading CoreProtect
curl -L "$(github PlayPro CoreProtect ${coreprotect_version} '^CoreProtect-\d+\.\d+\.jar$')" -o coreprotect-${coreprotect_version}.jar

echo Downloading DiscordSRV
curl -L "$(github DiscordSRV DiscordSRV ${discordsrv_version} '^DiscordSRV-Build-\d+\.\d+\.\d+\.jar$')" -o discordsrv-${discordsrv_version}.jar

echo Downloading spark
curl -L "$(jenkins ${lucko_ci} spark ${spark_build} '^spark-\d+.\d+.\d+-bukkit\.jar$')" -o spark-${spark_build}.jar

echo Downloading LuckPerms
curl -L "$(jenkins ${lucko_ci} LuckPerms ${luckperms_build} '^LuckPerms-Bukkit-\d+.\d+.\d+\.jar$')" -o luckperms-${luckperms_build}.jar

echo Downloading squaremap
curl -L "$(github jpenilla squaremap ${squaremap_version} '^squaremap-paper-mc.+-\d+\.\d+\.\d+\.jar$')" -o squaremap-${squaremap_version}.jar

echo Downloading simple voice chat
curl -L "$(modrinth simple-voice-chat ^bukkit-${simple_voice_chat_version}$)" -o simple-voice-chat-${simple_voice_chat_version}.jar
