#!/usr/bin/env bash

# Update and install dependencies
sudo apt update -y
sudo apt install -y openjdk-17-jdk unzip awscli screen

# Create Minecraft directory and set permissions
sudo mkdir -p /minecraft
sudo chown -R ubuntu:ubuntu /minecraft
cd /minecraft

# Unzip folders
unzip mods.zip
unzip config.zip

# Agree to EULA
echo '#By changing the setting below to TRUE you are indicating your agreement to our EULA (https://account.mojang.com/documents/minecraft_eula).
#Mon Aug 06 18:11:14 UTC 2018
eula=true' > eula.txt

# Download Forge installer and Mods
aws s3 cp s3://server-bucket-mc/setup/forge-1.20.1-47.3.0-installer.jar /minecraft/
aws s3 cp s3://server-bucket-mc/setup/mods.zip /minecraft/mods.zip
aws s3 cp s3://server-bucket-mc/setup/config.zip /minecraft/config.zip

# Install forge server
java -jar forge-1.20.1-47.3.0-installer.jar --installServer

### Edit run.sh and user_jvm_args.txt before running below command
./run.sh
