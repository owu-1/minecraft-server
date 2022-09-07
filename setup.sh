#!/bin/bash
mkdir -p plugins
mkdir -p data/lists
mkdir -p data/plugin/{coreprotect,my-worlds,luckperms}
touch data/lists/{banned-ips.json,banned-players.json,whitelist.json}
touch data/plugin/coreprotect/database.db
touch data/plugin/my-worlds/inventories.yml
touch data/plugin/luckperms/luckperms-h2.mv.db
cp setup-files/worlds.yml data/plugin/my-worlds/worlds.yml
./mods.sh
