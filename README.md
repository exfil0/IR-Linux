![alt text](https://github.com/exfil0/IR-Linux/blob/main/IR-Linux-Wallpaper.png)

# Incident Response Linux Investigation Script Guide

## Introduction
This guide is for using the Incident Response Linux Investigation script. This script gathers extensive information about a Linux system's current state, vital for incident response and troubleshooting.

## Prerequisites
- **Root Access**: The script requires root privileges.
- **Linux Environment**: Designed for Linux systems, compatibility varies.
- **Command Line Knowledge**: Basic understanding of Linux command line is needed.

## Getting Started
### Locate the Script
Ensure the script `IRLinuxInvestigation.sh` is on the system where it needs to run.

### Make the Script Executable
```bash
chmod +x IRLinuxInvestigation.sh
```

### Run the Script
Execute as root:
```bash
sudo ./IRLinuxInvestigation.sh
```
Follow prompts to enter your password.

## User Input
The script prompts for:
- **Username**: Check password status.
- **Process ID**: List open files for a process.
- **Filename**: Search for a file.
- **Number of Days**: Find recently modified or accessed files.
- **File Size**: Locate large files.

## Output
All output is redirected to `/tmp/IRLinux.txt`.

## Script Sections
- **User Accounts**: User account details and activities.
- **Log Entries**: System logs including boot logs and authentication logs.
- **System Resources**: Running processes and system usage data.
- **Processes**: Information on current processes.
- **Services**: System service statuses.
- **Files**: File permissions and specific file details.
- **Network Settings**: Network interfaces and connections, firewall rules.
- **Additional Commands**: Scheduled tasks, DNS settings, etc.

## Safety and Security
- Perform read-only operations; however, ensure data backups.
- Handle the output file securely as it contains sensitive data.

## Troubleshooting
- Install missing utilities via your distribution's package manager.
- Run the script with root privileges for permission-related issues.

## Conclusion
This script is essential for system administrators and IT professionals in incident response, providing an efficient way to gather system information securely.
