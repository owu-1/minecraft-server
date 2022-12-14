#!/bin/bash

# shellcheck disable=SC1091
source ./plugin.env
source ./pluginAPIs.sh

mkdir -p plugins
cd plugins || exit
rm ./*.jar

# todo: Unnecessary filename tests
ghrelease DiscordSRV DiscordSRV "v$DISCORDSRV_VERSION" '^DiscordSRV-Build-\d+\.\d+\.\d+\.jar$'
ghrelease Mrredstone5230 Not-Too-Expensive "$NOT_TOO_EXPENSIVE_VERSION" '^not-too-expensive-\d+\.\d+\.jar$'
jenkins "$LUCKO_CI" spark "$SPARK_BUILD" '^spark-\d+.\d+.\d+\d+-bukkit.jar$'
jenkins "$LUCKO_CI" LuckPerms "$LUCKPERMS_BUILD" '^LuckPerms-Bukkit-\d+.\d+.\d+\d+.jar$'
ghrelease jpenilla squaremap "v$SQUAREMAP_VERSION" '^squaremap-paper-mc.+-\d+\.\d+\.\d+\.jar$'
modrinth coreprotect "$COREPROTECT_VERSION" '^CoreProtect-\d+\.\d+\.jar$'
ghrelease RoverIsADog InfoHUD "$INFOHUD_VERSION" '^InfoHUD-\d\.\d(?:\.\d)\.jar$'
