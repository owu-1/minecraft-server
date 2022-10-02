#!/bin/bash
mkdir -p plugins
cd plugins || exit
rm ./*.jar

source ../variables.sh
source ../pluginAPIs.sh             # todo: Unnecessary filename tests

jenkins ${bergerhealer_ci} MyWorlds ${myworlds_build} '^MyWorlds-.+-v\d+-(?:SNAPSHOT-)?\d+\.jar'
jenkins ${bergerhealer_ci} BKCommonLib ${bkcommonlib_build} '^BKCommonLib-.+-v\d+-(?:SNAPSHOT-)?\d+\.jar'
github PlayPro CoreProtect ${coreprotect_version} '^CoreProtect-\d+\.\d+\.jar$'
github DiscordSRV DiscordSRV ${discordsrv_version} '^DiscordSRV-Build-\d+\.\d+\.\d+\.jar$'
jenkins ${lucko_ci} spark ${spark_build} '^spark-\d+.\d+.\d+-bukkit\.jar$'
jenkins ${lucko_ci} LuckPerms ${luckperms_build} '^LuckPerms-Bukkit-\d+.\d+.\d+\.jar$'
github jpenilla squaremap ${squaremap_version} '^squaremap-paper-mc.+-\d+\.\d+\.\d+\.jar$'
modrinth simple-voice-chat ${simple_voice_chat_version} '^bukkit-${simple_voice_chat_version}$'
