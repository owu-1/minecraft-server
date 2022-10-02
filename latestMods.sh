#!/bin/bash

mkdir -p plugins
cd plugins || exit

source ../pluginAPIs.sh

latest_jenkins https://ci.mg-dev.eu BKCommonLib jar &
latest_ghrelease PlayPro/CoreProtect 0 plugins/coreprotect.jar &
latest_ghrelease DiscordSRV/DiscordSRV 0 plugins/discordsrv.jar &
latest_jenkins https://ci.lucko.me LuckPerms Bukkit luckperms.jar &
latest_jenkins https://ci.mg-dev.eu MyWorlds jar &
latest_jenkins https://ci.lucko.me spark bukkit &
latest_ghrelease jpenilla/squaremap 1 plugins/squaremap.jar &
modrinth simple-voice-chat bukkit plugins/voicechat.jar &
wait
