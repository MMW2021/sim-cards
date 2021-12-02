#!/bin/bash


# copy the service file to systemd
sudo cp simppp.service /lib/systemd/system/

# enable the service
sudo systemctl enable simppp.service

# print status
sudo systemctl status simppp.service

