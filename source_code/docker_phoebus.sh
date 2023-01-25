#!/bin/sh
xhost local:root
docker run --rm -it --name phoebus_alsu --network="host" -e DISPLAY=${DISPLAY} -v /tmp/.X11-unix:/tmp/.X11-unix -v $HOME/.Xauthority:/root/.Xauthority lerwys/epics_phoebus_alsu
