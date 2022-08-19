#!/bin/bash

# Setup system
sudo yum -y install java-17-amazon-corretto-headless amazon-efs-utils
useradd -r -u 995 -g 993 -s /usr/bin/nologin minecraft

# Setup minecraft folder
sudo mkdir /opt/minecraft
sudo chown minecraft: /opt/minecraft
cd /opt/minecraft

# Setup minecraft server
curl -o paperclip.jar https://api.papermc.io/v2/projects/paper/versions/1.19.2/builds/131/downloads/paper-1.19.2-131.jar
echo "eula=true" > eula.txt
#cp ?? /etc/systemd/system/minecraft-server.service
#cp ?? start.sh
chmod u+x start.sh
mkdir worlds
echo "!!EFS_ID!! /opt/minecraft/worlds efs _netdev,noresvport,tls,iam,accesspoint=!!EFS_ACCESSPOINT!! 0 0" | sudo tee -a /etc/fstab
sudo systemctl daemon-reload
sudo systemctl enable minecraft-server
echo "stop" | MEMORY=2G ./start.sh
# set velocity in paper config to true
# set server.properties online-mode to false
# set keep-spawn-loaded to false in paper-world-config for faster startup time
