# Add the following to the crontab for root:

# 00 * * * * /etc/asterisk/local/saytime.sh
# * * * * * /usr/local/bin/SkywarnPlus/SkywarnPlus.py
# @reboot /usr/local/sbin/allstar-autoconnect.sh

# Save the following to /usr/local/sbin/allstar-autoconnect.sh

#!/bin/bash

count=0
max_attempts=20
check_asterisk=false
check_internet=false

sleep 60

while [ $count -lt $max_attempts ]; do

    if ! $check_asterisk && pgrep -f "sbin\/asterisk" > /dev/null; then
        check_asterisk=true
    fi

    if ! $check_internet && ping -c 1 8.8.8.8 &> /dev/null; then
        check_internet=true
    fi

    # If both conditions are met, exit the loop
    if $check_asterisk && $check_internet; then
        break
    fi

    sleep 5

done

# Example: /usr/sbin/asterisk -rx "rpt cmd 54321 ilink 3 55553"
/usr/sbin/asterisk -rx "rpt cmd [localnode] ilink 3 [remotenode]"
