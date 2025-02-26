#!/bin/bash

PORT=25565

CONNECTED_PLAYERS=$(sudo netstat -an | grep ":$PORT" | grep ESTABLISHED | wc -l)

if [ "$CONNECTED_PLAYERS" -eq 0 ]; then
    echo "No players connected, stopping Minecraft service and shutting down EC2 instance..."

    sudo systemctl stop minecraft.service

    sleep 20

    sudo shutdown -h now
else
    echo "Aborting Shutdown... $CONNECTED_PLAYERS player(s) connected to server"
fi
