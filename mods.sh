#!/bin/bash
mkdir -p plugins
cd plugins || exit
rm ./*.jar

bergerhealer_ci=ci.mg-dev.eu
lucko_ci=ci.lucko.me

myworlds_build=172      # Build must be >=159 to support rejoin world groups with /world lastposition merge [world1] [world2] ...
bkcommonlib_build=1390  # Build must be >=1386 to avoid error messages - https://github.com/bergerhealer/BKCommonLib/issues/147
coreprotect_version=v21.2
discordsrv_version=v1.26.0
spark_build=339
luckperms_build=1453
squaremap_version=v1.1.8
simple_voice_chat_version=1.19.2-2.3.6

# todo: Unnecessary filename tests

jenkins() {
    local jenkins_server=$1
    local job=$2
    local build=$3
    local filename_test=$4
    relative_path=$(curl -s "https://$jenkins_server/job/$job/$build/api/json" | jq -r --arg filename_test "$filename_test" '.artifacts | .[] | select(.fileName|test($filename_test)).relativePath')
    echo Downloading ${job}...
    curl -sL "$jenkins_server/job/$job/$build/artifact/$relative_path" -o ${job}-${build}.jar
}

github() {
    local owner=$1
    local repo=$2
    local tag=$3
    local filename_test=$4
    echo Downloading ${repo}...
    curl -sL "${curl -s "https://api.github.com/repos/$owner/$repo/releases/tags/$tag" | jq -r --arg filename_test "$filename_test" '.assets | .[] | select(.name|test($filename_test)).browser_download_url'}" -o ${repo}-${tag}.jar
}

modrinth() {
    local project_id=$1
    local version=$2
    local filename_test=$3
    echo Downloading ${project_id}...
    curl -sL "${curl -sG "https://api.modrinth.com/v2/project/$project_id/version" --data-urlencode 'loaders=["bukkit"]' | jq -r --arg filename_test "$filename_test" '.[] | select(.version_number|test($filename_test)).files[0].url'}" -o ${project_id}-${version}.jar
}

jenkins ${bergerhealer_ci} MyWorlds ${myworlds_build} '^MyWorlds-.+-v\d+-(?:SNAPSHOT-)?\d+\.jar'
jenkins ${bergerhealer_ci} BKCommonLib ${bkcommonlib_build} '^BKCommonLib-.+-v\d+-(?:SNAPSHOT-)?\d+\.jar'
github PlayPro CoreProtect ${coreprotect_version} '^CoreProtect-\d+\.\d+\.jar$'
github DiscordSRV DiscordSRV ${discordsrv_version} '^DiscordSRV-Build-\d+\.\d+\.\d+\.jar$'
jenkins ${lucko_ci} spark ${spark_build} '^spark-\d+.\d+.\d+-bukkit\.jar$'
jenkins ${lucko_ci} LuckPerms ${luckperms_build} '^LuckPerms-Bukkit-\d+.\d+.\d+\.jar$'
github jpenilla squaremap ${squaremap_version} '^squaremap-paper-mc.+-\d+\.\d+\.\d+\.jar$'
modrinth simple-voice-chat ${simple_voice_chat_version} ^bukkit-${simple_voice_chat_version}$
