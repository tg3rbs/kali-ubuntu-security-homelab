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

## Reproduce the Scans and Security Checks

### Scope and prerequisites
Run scans only against your own lab VM or a system you have explicit permission to test. The examples target the Ubuntu VM at `192.168.122.22` on the local libvirt network; do not run them against campus, workplace, or public networks. A private IP alone does not establish authorization.

For scanning, use Bash and Nmap on the Kali host, with the Ubuntu VM running and reachable on the virtual network. On Kali, install Nmap if needed:

```bash
sudo apt update
sudo apt install nmap
cd /path/to/kali-ubuntu-security-homelab
```

### scripts/network_scan.sh
The only script currently committed checks for Nmap, creates `scans/`, and runs:

```bash
nmap -sT -sV -p 22,80 192.168.122.22 -oN scans/service_scan.txt
```

- **Purpose:** TCP connect scan (`-sT`) of ports 22 and 80 with service-version detection (`-sV`). This is a limited service inventory, not a full-port scan or a vulnerability assessment.
- **Permissions:** No sudo/root required for this TCP connect scan. Your user must be able to create/write `scans/service_scan.txt`.
- **Target:** Hard-coded in the script's `TARGET` variable; command-line arguments do not change it. Confirm the VM's address with `ip -4 addr` on the guest before running. If needed, edit `TARGET` to the authorized lab VM's current address.
- **Working directory:** Run from the repository root. The output path is relative to your current directory.
- **Output:** Nmap results appear in the terminal and in `scans/service_scan.txt`. Every run overwrites that report; copy it first if you want a baseline.

```bash
# On Kali, from the repository root:
bash scripts/network_scan.sh
cat scans/service_scan.txt
```

A successful execution prints `[+] Scan completed!` and the report path. The committed example contains:

```text
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 10.2p1 Ubuntu 2ubuntu3.8
80/tcp open  http    nginx 1.28.3
```

Versions and port states depend on the current VM configuration. An `open` port means a service is reachable; it is not itself proof of a vulnerability. `filtered` generally means probes received no conclusive response or were blocked; `closed` means the port is reachable but no service is listening.

If Nmap is missing, the script prints `Error: Nmap is not installed.` and exits with status 1. Other command failures stop the script because it uses `set -euo pipefail`. If the VM appears down, check its address, virtual network, and firewall. Review the report's host count: a completed Nmap invocation does not guarantee that the VM was reachable or that any ports were open.

### Security checks on the Ubuntu VM
The previously used `security_audit.sh` is **not committed**, so there is no repository command to run that script yet. To reproduce the underlying checks manually, run these commands **inside the Ubuntu guest**, using a sudo-enabled account:

| Command | What to look for |
| --- | --- |
| `sudo /usr/sbin/sshd -T \| grep -E '^(passwordauthentication\|kbdinteractiveauthentication\|pubkeyauthentication) '` | `passwordauthentication no`, `kbdinteractiveauthentication no`, and `pubkeyauthentication yes` |
| `sudo ufw status verbose` | Active firewall, default deny incoming, SSH allowed, and HTTP allowed from `192.168.122.0/24` |
| `sudo fail2ban-client status sshd` | An active `sshd` jail, with failed/banned counts and a banned-IP list; zero bans is normal |

These checks require OpenSSH server, UFW, and Fail2ban to be installed/configured on the guest. They inspect configuration/status without changing rules or restarting services. `sshd -T` reports effective global settings; configurations using `Match` blocks require connection-specific checks with `sshd -T -C`.

Results print to the terminal; no report file is created by these commands. Missing commands, an inactive firewall, or a missing Fail2ban jail indicate setup to investigate, not a passing audit. Review and sanitize hostnames, usernames, and IP addresses before publishing captured output.

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
