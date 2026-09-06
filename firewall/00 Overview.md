# Firewall

## Details

| Hostname | Domain Name | Description                   | Operating System |
| -------- | ----------- | ----------------------------- | ---------------- |
| firewall | 192.168.1.1 | Firewall for the home network | OPNsense 26.7    |

## Hardware Specifications

| Manufacturer | Model | Processor  | RAM  | System Disk  | Storage Disks | Network Interfaces                                |
| ------------ | ----- | ---------- | ---- | ------------ | ------------- | ------------------------------------------------- |
| BeeLink      | EQ14  | Intel N150 | 16GB | 1x 512GB SSD | None          | 2x Gigabit Ethernet; 1x WiFi 6 (currently unused) |

## Purpose

The firewall is a mini-PC that runs OPNsense, a free and open-source firewall and routing platform based on FreeBSD. It is responsible for managing network traffic, providing security, and controlling access to the home network.

## Configuration

Configuration of the firewall is done through the OPNsense web interface, which allows for easy management of firewall rules, VPNs, and other network settings. The entire configuration is stored in a single XML file, which can be exported and imported for backup and restoration purposes.

## Services

The firewall provides several services, including:

- **NextDNS**: A DNS filtering service that blocks ads, trackers, and malicious domains, improving privacy and security for devices on the network. This is a paid service that requires a subscription, but it is worth the cost for the added security and privacy benefits. It is run via a NextDNS install on the router done via the shell. It is not configurable via the Opnsense web interface, but it can be managed through the NextDNS website. The configuration is stored in a JSON file that can be exported and imported for backup and restoration purposes.
- **WireGuard VPN**: A fast and secure VPN protocol that allows remote access to the home network.
- **Tailscale**: A mesh VPN that enables secure connections between devices without the need for complex configuration.
- **DynDNS**: A dynamic DNS service that allows the firewall to be accessed using a domain name, even if the public IP address changes.
- **Dnsmasq**: A lightweight DNS forwarder and DHCP server that provides DNS resolution and IP address assignment for devices on the network. It is configured to use NextDNS as the upstream DNS resolver, ensuring that all DNS queries are filtered and protected. It is used for DHCP only.

## IPv4 and IPv6

The firewall is configured to support both IPv4 and IPv6.

## DHCP

Devices such as servers on the network are assigned static IP addresses via DHCP reservations, which ensures that they always receive the same IP address. This is important for services that require a consistent IP address, such as servers and networked devices.

## DNS and hostnames

DNS resolution is handled by NextDNS, which provides filtering and security features. The firewall is configured to use NextDNS as the upstream DNS resolver, ensuring that all DNS queries are filtered and protected. The configuration is stored in a JSON file that can be exported and imported for backup and restoration purposes.

Domain names used for computers and services on the home network are defined via NextDNS, which allows them to be used for devices on the LAN and on devices connected via VPN.