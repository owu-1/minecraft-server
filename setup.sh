#!/bin/bash
mkdir -p plugins
mkdir -p data/lists
echo [] | tee data/lists/{banned-ips.json,banned-players.json,whitelist.json}
./mods.sh
