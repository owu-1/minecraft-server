#!/bin/bash

# shellcheck disable=SC1091
source ./plugin.env
source ./pluginAPIs.sh

mkdir -p plugins
cd plugins || exit
rm ./*.jar

# todo: Unnecessary filename tests
jenkins "$BERGERHEALER_CI" MyWorlds "$MYWORLDS_BUILD" '^MyWorlds-.+-v\d+-(?:SNAPSHOT-)?\d+\.jar'
jenkins "$BERGERHEALER_CI" BKCommonLib "$BKCOMMONLIB_BUILD" '^BKCommonLib-.+-v\d+-(?:SNAPSHOT-)?\d+\.jar'
ghrelease PlayPro CoreProtect "$COREPROTECT_VERSION" '^CoreProtect-\d+\.\d+\.jar$'
ghrelease DiscordSRV DiscordSRV "$DISCORDSRV_VERSION" '^DiscordSRV-Build-\d+\.\d+\.\d+\.jar$'
jenkins "$LUCKO_CI" spark "$SPARK_BUILD" '^spark-\d+.\d+.\d+\d+-bukkit.jar$'
jenkins "$LUCKO_CI" LuckPerms "$LUCKPERMS_BUILD" '^LuckPerms-Bukkit-\d+.\d+.\d+\d+.jar$'
ghrelease jpenilla squaremap "$SQUAREMAP_VERSION" '^squaremap-paper-mc.+-\d+\.\d+\.\d+\.jar$'
modrinth simple-voice-chat "bukkit-$SIMPLE_VOICE_CHAT_VERSION"
