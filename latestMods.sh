#!/bin/bash

mkdir -p plugins
cd plugins || exit

source ../pluginAPIs.sh

curl -sLo plugins/bkcommonlib.jar $(jenkins https://ci.mg-dev.eu BKCommonLib jar) &
gitrel PlayPro/CoreProtect 0 plugins/coreprotect.jar &
gitrel DiscordSRV/DiscordSRV 0 plugins/discordsrv.jar &
curl -sLo plugins/luckperms.jar $(jenkins https://ci.lucko.me LuckPerms Bukkit luckperms.jar | cut -d ' ' -f1) &
curl -sLo plugins/myworlds.jar $(jenkins https://ci.mg-dev.eu MyWorlds jar) &
curl -sLo plugins/spark.jar $(jenkins https://ci.lucko.me spark bukkit) &
gitrel jpenilla/squaremap 1 plugins/squaremap.jar &
modrinth simple-voice-chat bukkit plugins/voicechat.jar &
wait
