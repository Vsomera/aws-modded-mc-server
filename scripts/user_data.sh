#!/usr/bin/env bash

# Update and install dependencies
sudo apt update -y
sudo apt install -y openjdk-8-jdk unzip awscli screen

# Create Minecraft directory and set permissions
sudo mkdir -p /minecraft
sudo chown -R ec2-user:ec2-user /minecraft
cd /minecraft

# Download Forge installer and Mods
aws s3 cp s3://server-bucket-mc/setup/forge-1.20.1-47.3.0-installer.jar /minecraft/forge-installer/
aws s3 cp s3://server-bucket-mc/setup/mods.zip /minecraft/mods.zip

# Install forge server
java -jar forge-1.20.1-47.3.0-installer.jar --installServer

# Unzip mods
unzip mods.zip

# Agree to EULA
echo "eula=true" > eula.txt

# Download and setup systemd service
sudo aws s3 cp s3://server-bucket-mc/setup/minecraft.service /etc/systemd/system/minecraft.service
sudo chmod 644 /etc/systemd/system/minecraft.service

# Reload systemd and start service
sudo systemctl daemon-reload

sudo service minecraft start

screen -S mcserver

java -Xms2G -Xmx8G -XX:+UseG1GC -jar minecraft_server.1.20.1.jar nogui

### TODO OPTIMIZE ARGUMENTS