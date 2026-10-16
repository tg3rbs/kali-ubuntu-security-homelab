
#!/bin/bash
set -euo pipefail

# Kali-Ubuntu Security Homelab
# Scan the authorized Ubuntu Server VM.

TARGET="192.168.122.22"

echo "================================"
echo " Kali-Ubuntu Network Scanner"
echo "================================"
echo "Target: $TARGET"
echo

if ! command -v nmap >/dev/null 2>&1; then
    echo "Error: Nmap is not installed."
    exit 1
fi

mkdir -p scans

echo "[+] Scanning open ports and services..."
nmap -sT -sV -p 22,80 "$TARGET" -oN scans/service_scan.txt

echo
echo "[+] Scan completed!"
echo "[+] Results saved to scans/service_scan.txt"
