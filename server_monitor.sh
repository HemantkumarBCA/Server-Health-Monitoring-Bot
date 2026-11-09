#!/bin/bash

# =================================================================
# Project: Automated Server Health Monitoring & Alerting System
# Developer: Hemant Kumar (Linux Administrator)
# Description: This script automatically monitors CPU, RAM, and Disk space.
# =================================================================

clear
echo "=========================================================="
echo "          SERVER SYSTEM HEALTH REPORT                     "
echo "=========================================================="
echo "Current Timestamp : $(date)"
echo "Server Hostname   : $(hostname)"
echo "----------------------------------------------------------"

# 1. Check CPU Utilization
# Extracts the percentage of CPU currently being used
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
echo "📊 CPU Utilization : $CPU_USAGE%"

# 2. Check RAM (Memory) Usage
# Calculates the ratio of used memory to total memory in percentage
MEM_USAGE=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
printf "🧠 Memory Usage    : %.2f%%\n" "$MEM_USAGE"

# 3. Check Disk Space Usage
# Monitors the storage percentage used on the root '/' partition
DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')
echo "💾 Disk Space Usage: $DISK_USAGE%"

echo "----------------------------------------------------------"

# 4. Alerting Mechanism (Threshold Limit)
# If any resource utilization exceeds 80%, a critical alert triggers
CRITICAL_LIMIT=80

if (( $(echo "$CPU_USAGE > $CRITICAL_LIMIT" | bc -l) )) || (( $(echo "$MEM_USAGE > $CRITICAL_LIMIT" | bc -l) )) || [ "$DISK_USAGE" -gt "$CRITICAL_LIMIT" ]; then
    echo "⚠️ ALERT WARNING: High resource utilization detected! Please check immediately."
else
    echo "✅ SYSTEM STATUS: All server resources are under safe limits."
fi
echo "=========================================================="
