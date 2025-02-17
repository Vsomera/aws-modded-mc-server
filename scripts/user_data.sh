#!/usr/bin/env bash

# install dependencies
sudo apt update -y
sudo apt install -y openjdk-17-jdk unzip awscli screen

# create minecraft directory and set permissions
sudo mkdir -p /minecraft
sudo chown -R ubuntu:ubuntu /minecraft
cd /minecraft

# agree to EULA
echo '#By changing the setting below to TRUE you are indicating your agreement to our EULA (https://account.mojang.com/documents/minecraft_eula).
#Mon Aug 06 18:11:14 UTC 2018
eula=true' > eula.txt

# download contents from s3 bucket
aws s3 cp s3://<s3_bucket_name>/setup/<loader-x.xx.x-xx.x.x-installer.jar> /minecraft/
aws s3 cp s3://<s3_bucket_name>/setup/mods.zip /minecraft/mods.zip
aws s3 cp s3://<s3_bucket_name>/setup/config.zip /minecraft/config.zip
aws s3 cp s3://<s3_bucket_name>/setup/defaultconfigs.zip /minecraft/defaultconfigs.zip

unzip -o mods.zip
unzip -o config.zip
unzip -o defaultconfigs.zip

# configure minecraft to start when booting up instance
sudo aws s3 cp s3://<s3_bucket_name>/setup/minecraft.service /etc/systemd/system/minecraft.service

# install forge server
java -jar <loader-x.xx.x-xx.x.x-installer.jar> --installServer

# edit run.sh (--nogui) and .txt file ram usage

# configure linux to start minecraft on boot
sudo systemctl daemon-reload
sudo systemctl enable minecraft

# ./run.sh to start minecraft server
