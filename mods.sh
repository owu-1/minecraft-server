#!/bin/bash

# GitHub Releases
# Usage: gitrel user/repo fileIndex destination
gitrel() { echo --url $(curl -s https://api.github.com/repos/$1/releases | jq -r '.[0].assets['$2'].browser_download_url') | curl -sLo $3 --config -;}

# Modrinth
# Usage: modrinth project loader destination
modrinth() { curl -sLo $3 $(curl -s "https://api.modrinth.com/v2/project/$1/version?loaders=\[%22$2%22\]" | jq -r '.[0]'.files[0].url);}

# Jenkins
# Usage: jenkins api project fileNameTest
jenkins(){ api=$1;job=$2;filename_test=$3;relative_url=$(curl -s $api/job/$job/lastSuccessfulBuild/api/json | jq -r --arg filename_test $filename_test '.artifacts | .[] | select(.fileName|test($filename_test)).relativePath');echo $api/job/$job/lastSuccessfulBuild/artifact/$relative_url;}

mkdir -p plugins

curl -sLo plugins/bkcommonlib.jar $(jenkins https://ci.mg-dev.eu BKCommonLib jar) &
gitrel PlayPro/CoreProtect 0 plugins/coreprotect.jar &
gitrel DiscordSRV/DiscordSRV 0 plugins/discordsrv.jar &
curl -sLo plugins/luckperms.jar $(jenkins https://ci.lucko.me LuckPerms Bukkit luckperms.jar | cut -d ' ' -f1) &
curl -sLo plugins/myworlds.jar $(jenkins https://ci.mg-dev.eu MyWorlds jar) &
curl -sLo plugins/spark.jar $(jenkins https://ci.lucko.me spark bukkit) &
gitrel jpenilla/squaremap 1 plugins/squaremap.jar &
modrinth simple-voice-chat bukkit plugins/voicechat.jar &
wait
