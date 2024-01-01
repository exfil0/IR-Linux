#!/bin/bash

# Check if the script is running with root privileges
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root." >&2
    exit 1
fi

# Redirecting output to IRLinux.txt in /tmp/ directory
exec > /tmp/IRLinux.txt 2>&1

echo "Incident Response Linux Investigation"
echo "--------------------------------------"
echo "Date and Time of Report: $(date)"
echo "--------------------------------------"

# Function to print section headers
print_section() {
    echo ""
    echo "======================================"
    echo "$1"
    echo "======================================"
}

# Function to check if a command exists
command_exists() {
    type "$1" &> /dev/null 
}

# Prompt for user input
read -p "Enter the username to check password status: " user_name
read -p "Enter the process ID for open file check: " pid
read -p "Enter the filename to search: " filename
read -p "Enter the number of days to check for file modifications: " num_days
read -p "Enter the size in bytes to search for files larger than: " file_size

# User Accounts
print_section "User Accounts Information"
echo "Listing user accounts..."
cat /etc/passwd
echo "Checking password status for user $user_name..."
passwd -S $user_name
echo "Showing the most recent logins..."
lastlog
echo "Showing last logged in users..."
last
echo "Showing who is logged on..."
who
echo "Showing who is logged on and what they are doing..."
w

# Additional User Account Commands
print_section "Additional User Account Commands"
echo "Finding root accounts..."
grep :0: /etc/passwd
echo "Finding files with no user..."
find / -nouser -print
echo "Viewing encrypted passwords and account expiration information..."
cat /etc/shadow
echo "Viewing group information..."
cat /etc/group
echo "Viewing sudoers file..."
cat /etc/sudoers

# Log Entries
print_section "Log Entries"
# Check for the existence of log files before attempting to read them
if [ -f /var/log/messages ]; then
    echo "Showing system messages..."
    cat /var/log/messages
else
    echo "/var/log/messages not found."
fi
if [ -f /var/log/auth.log ]; then
    echo "Showing user authentication logs..."
    cat /var/log/auth.log
else
    echo "/var/log/auth.log not found."
fi
if [ -f /var/log/secure ]; then
    echo "Showing authentication log for Red Hat based systems..."
    cat /var/log/secure
else
    echo "/var/log/secure not found."
fi
if [ -f /var/log/boot.log ]; then
    echo "Showing system boot log..."
    cat /var/log/boot.log
else
    echo "/var/log/boot.log not found."
fi
if [ -f /var/log/dmesg ]; then
    echo "Showing kernel ring buffer log..."
    cat /var/log/dmesg
else
    echo "/var/log/dmesg not found."
fi
if [ -f /var/log/kern.log ]; then
    echo "Showing kernel log..."
    cat /var/log/kern.log
else
    echo "/var/log/kern.log not found."
fi
echo "Viewing the last few entries in the authentication log..."
tail /var/log/auth.log
echo "Viewing command history..."
history | less

# System Resources
print_section "System Resources"
echo "Displaying Linux tasks..."
top -b -n 1
# Check if htop is installed before attempting to run it
if command_exists htop; then
    echo "Interactive process viewer..."
    htop -n 1
else
    echo "htop not installed."
fi
echo "Showing system uptime..."
uptime
echo "Showing currently running processes..."
ps aux
echo "Showing running processes as a tree..."
pstree
echo "Displaying memory usage..."
free -m
echo "Displaying memory information..."
cat /proc/meminfo
echo "Displaying mounted filesystems..."
cat /proc/mounts

# Processes
print_section "Processes"
echo "Displaying all the currently running processes on the system..."
ps -ef
echo "Displaying processes in a tree format with PIDs..."
pstree -p
echo "Displaying top processes..."
top -b -n 1
echo "Showing processes in custom format..."
ps -eo pid,tt,user,fname,rsz
echo "Listing open files associated with network connections..."
lsof -i
echo "Listing open files for process $pid..."
lsof -p $pid

# Services
print_section "Services"
# Check for the existence of the chkconfig and service commands
if command_exists chkconfig; then
    echo "Listing all services and their current states..."
    chkconfig --list
else
    echo "chkconfig command not found."
fi
if command_exists service; then
    echo "Showing status of all services..."
    service --status-all
    echo "Listing all services and their status..."
    service --status-all
else
    echo "service command not found."
fi
# Check if systemctl is installed before attempting to run it
if command_exists systemctl; then
    echo "Listing running services (systemd)..."
    systemctl list-units --type=service
else
    echo "systemctl not installed."
fi

# Files
print_section "Files"
echo "Showing all files in human-readable format..."
ls -alh
echo "Finding specific file named $filename..."
find / -name $filename
echo "Finding files modified in the last $num_days days..."
find / -mtime -$num_days
echo "Finding files accessed in the last $num_days days..."
find / -atime -$num_days
echo "Finding files larger than $file_size bytes..."
find / -size +${file_size}c

# Network Settings
print_section "Network Settings"
# Check if ifconfig and netstat are installed before attempting to run them
if command_exists ifconfig; then
    echo "Showing all network interfaces..."
    ifconfig -a
else
    echo "ifconfig not installed."
fi
if command_exists netstat; then
    echo "Showing active network connections..."
    netstat -antup
    echo "Showing network connections and associated programs..."
    netstat -nap
else
    echo "netstat not installed."
fi
echo "Showing all iptables rules..."
iptables -L -n -v
echo "Showing routing table..."
route -n
echo "Showing listening ports and established connections..."
ss -tuln

# Additional Commands
print_section "Additional Investigation Commands"
echo "Viewing the cron table for scheduled tasks..."
cat /etc/crontab
echo "Viewing DNS settings..."
more /etc/resolv.conf
echo "Viewing host file entries..."
more /etc/hosts
echo "Listing all iptables rules without resolving IP addresses..."
iptables -L -n
echo "Finding files larger than 512KB in home directories..."
find /home/ -type f -size +512k -exec ls -lh {} \;
echo "Finding readable files in the etc directory..."
find /etc/ -readable -type f 2>/dev/null
echo "Finding files modified in the last 2 days..."
find / -mtime -2 -ls

echo "--------------------------------------"
echo "Script execution completed."
echo "Exit Status: $?"
