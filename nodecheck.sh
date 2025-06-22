# This script queries asterisk to see whether the node 621750 on which it runs
# is connected to several other nodes 47970, 621751, 621752, and 621753 and
# writes the connected nodes to a file on the apache web server for Home Assistant
# to retrieve for dashboard updates

#!/bin/bash

# Define the output file
OUTPUT_FILE="/var/www/html/connections.txt"
SEARCH_STRINGS=("47970" "621750" "621751" "621752" "621753")
COMMAND='/usr/sbin/asterisk -rx "rpt nodes 621750"'


# Write timestamp to file
current_time=$(date "+%Y-%m-%d %H:%M:%S")
echo "$current_time" > "$OUTPUT_FILE"


# Execute the command and capture output
output=$(eval "$COMMAND" 2>&1)
exit_code=$?
#echo "$output"


if [ $exit_code -eq 0 ]; then
    found_strings=()
    for s in "${SEARCH_STRINGS[@]}"; do
        if echo "$output" | grep -E "\bT$s\b" > /dev/null; then
            found_strings+=("$s")
        fi
    done

    if [ ${#found_strings[@]} -gt 0 ]; then
        printf "%s\n" "${found_strings[@]}" >> "$OUTPUT_FILE"
    fi
else
    echo "Command failed with error: $output" >&2
fi
