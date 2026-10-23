# Kali Linux & Ubuntu Server Security Homelab

## Overview
A virtualized cybersecurity homelab built using Kali Linux, Ubuntu Server 26.04.1 LTS, and KVM/QEMU. This project demonstrates Linux server administration, SSH hardening, firewall configuration, automated network reconnaissance, Bash security auditing, and packet analysis.

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
- Bash scripting

## Host System Deployment

- Repurposed an existing Windows 11 desktop into a dedicated Kali Linux cybersecurity workstation.
- Replaced Windows 11 with a bare-metal Kali Linux installation using bootable USB installation media.
- Configured Linux networking and enabled AMD hardware virtualization (AMD-V).
- Installed and configured KVM/QEMU with libvirt to host virtual machines.
- Deployed Ubuntu Server 26.04.1 LTS as a virtualized security testing environment.

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

## Automated Network Scanning
Implemented a repeatable Nmap workflow in [scripts/network_scan.sh](scripts/network_scan.sh). The Bash script checks that Nmap is installed, creates the scans directory, and runs a TCP connect scan with service-version detection against ports 22 and 80 on the authorized Ubuntu Server VM:

```bash
# Run from the repository root on the Kali host.
bash scripts/network_scan.sh
```

Each run saves results to [scans/service_scan.txt](scans/service_scan.txt), replacing the previous report. The recorded scan confirms SSH and HTTP are open.

## Security Audit Workflow
Created and ran a Bash security audit script (`security_audit.sh`) locally on the Ubuntu Server VM with sudo. The audit reports SSH authentication settings, UFW firewall status and rules, and the Fail2ban SSH jail status to support repeatable checks of the server's defensive configuration.

The audit script has been completed and used locally but is not yet included in this repository.

## Traffic Analysis
Captured HTTP traffic using Wireshark on the virbr0 virtual network interface. Observed an HTTP GET request and an HTTP 304 Not Modified response, demonstrating how unencrypted HTTP traffic can be inspected.

## Project Structure
- scripts/ — Automated Nmap network scanning script
- scans/ — Saved network reconnaissance results

## Security Notes
All scanning was performed against a personally controlled virtual machine in a local homelab. Private SSH keys, credentials, and raw packet captures are excluded from the public repository.

## Future Improvements
- Add the completed local security audit script and sanitized example output to the repository.
- Document network architecture and security findings in docs/.
- Add sanitized security configuration examples in configs/.
- Explore HTTPS configuration and additional defensive monitoring.
