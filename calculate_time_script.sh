#!/bin/bash

# Function to convert date/time to seconds since epoch
date_to_seconds() {
    date -j -f "%Y-%m-%d %H:%M:%S" "$1" "+%s"
}

# Function to calculate time difference in seconds
calculate_time_difference() {
    start_seconds=$(date_to_seconds "$1")
    end_seconds=$(date_to_seconds "$2")
    echo "$((end_seconds - start_seconds))"
}

# Prompt for start date
read -p "Enter the start date (YYYY-MM-DD HH:MM:SS): " start_date

# Prompt for end date
read -p "Enter the end date (YYYY-MM-DD HH:MM:SS): " end_date

# Read Android Studio log file
while read -r line; do
    # Extract the date and time from the line
    timestamp=$(echo "$line" | awk '{print $4, $5}')
    # Check if the timestamp is within the specified range
    if [[ "$timestamp" > "$start_date" && "$timestamp" < "$end_date" ]]; then
        # Check if Android Studio was opened or closed
        if [[ "$line" == *"Android Studio open"* ]]; then
            # Android Studio was opened, store the start timestamp
            start_timestamp="$timestamp"
        elif [[ "$line" == *"Android Studio closed"* && -n "$start_timestamp" ]]; then
            # Android Studio was closed, calculate the time difference and add to total time
            end_timestamp="$timestamp"
            total_time=$((total_time + $(calculate_time_difference "$start_timestamp" "$end_timestamp")))
            # Reset start timestamp
            start_timestamp=""
        fi
    fi
done < android_studio_log.txt

echo "Total time Android Studio was open between $start_date and $end_date: $total_time seconds"
