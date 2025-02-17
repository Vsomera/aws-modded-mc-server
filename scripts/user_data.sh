#!/usr/bin/env bash

# install dependencies
sudo apt update -y
sudo apt install -y openjdk-17-jdk unzip awscli screen

# create minecraft directory and set permissions
sudo mkdir -p /minecraft
cd /minecraft

# agree to EULA
echo '#By changing the setting below to TRUE you are indicating your agreement to our EULA (https://account.mojang.com/documents/minecraft_eula).
#Mon Aug 06 18:11:14 UTC 2018
eula=true' > eula.txt

# download contents from s3 bucket
aws s3 cp s3://< s3_bucket_name >/setup/forge-1.20.1-47.3.0-installer.jar /minecraft/
aws s3 cp s3://< s3_bucket_name >/setup/mods.zip /minecraft/mods.zip
aws s3 cp s3://< s3_bucket_name >/setup/config.zip /minecraft/config.zip
aws s3 cp s3://< s3_bucket_name >/setup/defaultconfigs.zip /minecraft/defaultconfigs.zip

unzip -o mods.zip
unzip -o config.zip
unzip -o defaultconfigs.zip

# configure minecraft to start when booting up instance
sudo aws s3 cp s3://< s3_bucket_name >/setup/minecraft.service /etc/systemd/system/minecraft.service

# install forge server
java -jar < forge-xxxxxx-installer.jar > --installServer

# allow permissions
sudo chown -R ubuntu:ubuntu /minecraft
sudo chmod -R 755 /minecraft

# configure linux to start minecraft on boot
sudo systemctl daemon-reload
sudo systemctl enable minecraft

# ./run.sh to start minecraft server
