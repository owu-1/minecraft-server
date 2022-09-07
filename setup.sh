#!/bin/bash
mkdir -p plugins
mkdir -p data/lists
mkdir -p data/plugin/{coreprotect,my_worlds}
touch data/lists/{banned-ips.json,banned-players.json,whitelist.json}
touch data/plugin/coreprotect/database.db
touch data/plugin/my_worlds/inventories.yml
cp setup_files/worlds.yml data/plugin/my_worlds/worlds.yml
curl -L -o plugins/luckperms.jar https://download.luckperms.net/1453/bukkit/loader/LuckPerms-Bukkit-5.4.46.jar
curl -L -o plugins/discordsrv.jar https://github.com/DiscordSRV/DiscordSRV/releases/download/v1.25.1/DiscordSRV-Build-1.25.1.jar
curl -L -o plugins/squaremap.jar https://github.com/jpenilla/squaremap/releases/download/v1.1.8/squaremap-paper-mc1.19.2-1.1.8.jar
curl -L -o plugins/coreprotect.jar https://github.com/PlayPro/CoreProtect/releases/download/v21.2/CoreProtect-21.2.jar
curl -L -o plugins/myworlds.jar https://ci.mg-dev.eu/job/MyWorlds/168/artifact/target/MyWorlds-1.19.2-v1-SNAPSHOT-168.jar
curl -L -o plugins/bkcommonlib.jar https://ci.mg-dev.eu/job/BKCommonLib/1352/artifact/target/BKCommonLib-1.19.2-v1-1352.jar
