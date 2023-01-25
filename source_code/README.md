# How to program bitstream file for LLRF chassis
---

In any of the directories, run

```bash
make config_marble
```

# Python setup
---

```bash
pip install -r requirements.txt
```

# EPICS
---

## Prerequisites for running IOC and Phoebus

In order to run the IOC and Phoebus the following tools
are needed to be installed on the host machine:

* Docker 20.10.22 (other versions might work)

Follow the instructions from the [Docker website](https://docs.docker.com/get-docker/)

## How to get docker images for the EPICS IOC and Phoebus

There are some ways to get those images.

The straightforward way is to get the images from
dockerhub with:

```bash
docker pull lerwys/epics_feed_alsu
docker pull lerwys/epics_phoebus_alsu
```

## How to run EPICS IOC

```bash
./docker_ioc.sh
```
# How to run Phoebus GUI
```bash
./docker_phoebus.sh
```
