#!/bin/bash
mkdir -p plugins
mkdir -p data/lists
echo [] | tee data/lists/{banned-ips.json,banned-players.json,whitelist.json}
cp -r ./secrets-default ./secrets
./mods.sh
