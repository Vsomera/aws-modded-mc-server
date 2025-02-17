#!/usr/bin/env bash

sudo apt update -y
sudo apt install -y openjdk-17-jdk unzip awscli screen

sudo mkdir -p /minecraft
cd /minecraft

echo '#By changing the setting below to TRUE you are indicating your agreement to our EULA (https://account.mojang.com/documents/minecraft_eula).
#Mon Aug 06 18:11:14 UTC 2018
eula=true' > eula.txt

sudo chown -R ubuntu:ubuntu /minecraft
