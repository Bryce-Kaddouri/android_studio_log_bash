#!/bin/bash

# File to store the log
log_file="/Users/bryce/test_script/android_log.txt"

# Variable to keep track of previous state
prev_state=""

# Function to write log
write_log() {
    echo "$1 at $(date +"%Y-%m-%d %H:%M:%S")" >> "$log_file"
}

# Function to check if Safari is running
check_is_open() {
    if pgrep -x "Android Studio" > /dev/null; then
        state="open"
    else
        state="closed"
    fi
}

# Initial check if Safari is running
check_is_open
prev_state="$state"

# Monitor Android Studio process
while true; do
    # Check if Android Studio is running
    check_is_open
    
    # Check if state has changed
    if [ "$state" != "$prev_state" ]; then
        if [ "$state" = "open" ] || [ "$state" = "closed" ]; then
            write_log "Android Studio $state"
            prev_state="$state"
	fi
    fi
    
    # Check every 1 seconds
    sleep 1
done
