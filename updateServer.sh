#!/bin/bash

sudo git pull || exit
sudo chmod +x mods.sh
sudo chmod +x updateServer.sh
sudo chmod +x restart.sh
sudo chmod +x pluginAPIs.sh
./mods.sh
sudo ./restart.sh
