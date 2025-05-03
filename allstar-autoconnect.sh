# Add the following to the crontab for root:

# 00 * * * * /etc/asterisk/local/saytime.sh
# * * * * * /usr/local/bin/SkywarnPlus/SkywarnPlus.py
# @reboot /usr/local/sbin/allstar-autoconnect.sh

# Save the following to /usr/local/sbin/allstar-autoconnect.sh
#!/bin/bash

count=0
max_attempts=20

sleep 60
while [ $count -lt $max_attempts ]; do
    if pgrep -f "sbin\/asterisk" > /dev/null; then
        break
    else
        sleep 5
        count=$((count + 1))
    fi
done

# Example: /usr/sbin/asterisk -rx "rpt cmd 54321 ilink 3 55553"
/usr/sbin/asterisk -rx "rpt cmd [localnode] ilink 3 [remotenode]"
