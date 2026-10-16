# Kali Linux & Ubuntu Server Security Homelab

## Overview
A virtualized cybersecurity homelab built using Kali Linux, Ubuntu Server 26.04.1 LTS, and KVM/QEMU. This project demonstrates Linux server administration, SSH hardening, firewall configuration, network reconnaissance, and packet analysis.

## Technologies
- Kali Linux
- Ubuntu Server 26.04.1 LTS
- KVM/QEMU and Virtual Machine Manager
- OpenSSH and ED25519 key authentication
- UFW firewall
- Fail2ban
- Nmap
- Nginx
- Wireshark
- Git and GitHub

## Lab Architecture
- Host operating system: Kali Linux
- Virtual machine: Ubuntu Server
- Virtual network: 192.168.122.0/24
- Ubuntu Server IP: 192.168.122.22
- Remote administration: SSH on TCP port 22
- Web service: Nginx on TCP port 80

## Security Configuration
1. Installed Ubuntu Server in a KVM/QEMU virtual machine.
2. Configured SSH with ED25519 public-key authentication.
3. Disabled SSH password and keyboard-interactive authentication.
4. Configured UFW to restrict incoming connections.
5. Enabled Fail2ban with an SSH monitoring jail.
6. Deployed Nginx and restricted HTTP access to the virtual subnet.

## Network Reconnaissance
Used Nmap from Kali Linux to scan the Ubuntu Server.

Initial full TCP scan:
- 1 open TCP port: 22 (SSH)
- 65,534 filtered TCP ports

After configuring Nginx and allowing HTTP traffic:
- Port 22: OpenSSH 10.2p1
- Port 80: Nginx 1.28.3

## Traffic Analysis
Captured HTTP traffic using Wireshark on the virbr0 virtual network interface. Observed an HTTP GET request and an HTTP 304 Not Modified response, demonstrating how unencrypted HTTP traffic can be inspected.

## Project Structure
- scripts/ — Network scanning and security audit scripts
- configs/ — Sanitized security configuration examples
- scans/ — Network reconnaissance results
- docs/ — Architecture and security documentation

## Security Notes
All scanning was performed against a personally controlled virtual machine in a local homelab. Private SSH keys, credentials, and raw packet captures are excluded from the public repository.

## Future Improvements
- Automate security auditing with Bash.
- Add repeatable network scanning scripts.
- Document network architecture and security findings.
- Explore HTTPS configuration and additional defensive monitoring.
