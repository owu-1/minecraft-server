#!/bin/bash

# Setup system
sudo yum -y install java-17-amazon-corretto-headless
groupadd -g 993 minecraft
useradd -r -u 995 -g 993 -s /usr/bin/nologin minecraft

# Setup minecraft folder
sudo mkdir /opt/minecraft
sudo chown minecraft: /opt/minecraft
cd /opt/minecraft

# Setup proxy
curl -o velocity.jar https://api.papermc.io/v2/projects/velocity/versions/3.1.2-SNAPSHOT/builds/177/downloads/velocity-3.1.2-SNAPSHOT-177.jar
mkdir plugins
# cp ?? plugins/velocity-auto-reconnect.jar
# cp ?? start.sh
echo "stop" | MEMORY=512M ./start.sh
# set forwarding.secret to secret
# set online-mode to true
# set player-info-forwarding-mode to modern

# limbo = "127.0.0.1:65535"
# minecraft = "127.0.0.1:25565"

# try = [ "minecraft", "limbo" ]