# Homelab

## Details

| Hostname | Domain Name              | Description                                | Operating System |
| -------- | ------------------------ | ------------------------------------------ | ---------------- |
| homelab  | homelab.lan.19781013.syz | Homelab server for testing and development | Debian 13        |

## Hardware Specifications

| Manufacturer | Model       | Processor       | RAM | System Disk  | Storage Disks | Network Interfaces  |
| ------------ | ----------- | --------------- | --- | ------------ | ------------- | ------------------- |
| Lenovo       | ThinkCentre | AMD Ryzen 5 PRO | 8GB | 1x 240GB SSD | none          | 1x Gigabit Ethernet |

## Purpose

The homelab server is used for testing and development purposes. It is not intended to host any production services or applications. The server is used to experiment with new technologies, test configurations, and develop scripts and automation tools. At present, it is set up with Debian 13 for experimentation with Podman and quadlets, as well as for testing various services and applications in a controlled environment. The server is also used for learning and practicing system administration skills.

## Virtualization

Podman is used for containerization over Docker, LXC, or other virtualization technologies.

## Filesystems

The server contains one physical SSD used for the root filesystem. The root filesystem is formatted with XFS for no particular reason other than testing it out. The root filesystem is used for the operating system, applications, and other storage needs. The root filesystem is mounted on `/`. The disk is 240GB in size.

## Setup Instructions

The server is used for testing and development purposes, and any configurations or changes made to the server are not intended to be permanent. Nothing on this server needs to be set up again in the same way. Therefore, no setup instructions are provided.