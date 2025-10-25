#!/bin/bash

#Live Auditd Monitoring
#First script :)

# $EUID is the present user ID 
# -ne is not equals to
# 0 = the root user
# sudo $0 = print sudo and $0 is a special variable that holds the current name and path
# if the current user is not root then echo "run as root (sudo ./audit.sh)" and exit the program
if [[ $EUID -ne 0]]; then

    echo "Run as root (sudo $0)"
    exit 1
fi

#Giving it a nice UI
echo "Starting live auditing monitoring"
echo "Press Ctrl+C to stop"
echo "---------------------------------"

#Defining coloring to make it easy on the eyes
# \033 = escaping so the script switches to command mode to interpret the next characters as colors
#"\033[<style>;<color>m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m" #Adding "Bright" to yellow
BLUE="\033[0;34m"
RED="\033[0;31m"
RESET="\033[0m"    # 0 = resetting

#Setting up the tail
#if your audit log is stored somewhere else then change path
# -F = even if the file name changes track it
# -n0 show only what happening now not the past hence 0
# | pipe this to the next statement

tail -Fn0 /var/log/audit/audit.log | 

# read = reads one line of input
# -r not to treat \ as escapes
# line variable storing each line

while read -r line; do          

    #
    if echo "$line" | grep -q "USER_LOGIN"; then

    USER=$(echo "$line" | grep -oP 'acct="[^"]+"' | cut -d'"' -f2)

    RESULT=$(echo "$line" | grep -oP 'res=[^ ]+' | cut -d'=' -f2)

    echo -e "${GREEN}[LOGIN]${RESET} User: ${YELLOW}${USER}${RESET} Result: ${RESULT}"

    fi

    

