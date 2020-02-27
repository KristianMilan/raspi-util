#!/bin/bash

getUptime() {
    echo $(awk '{print int($1)}' /proc/uptime)
}

THRESHOLD=290 

while true; do
    secs=$(getUptime) 

    if [ $secs -ge $THRESHOLD ]; then
        echo "u" > /proc/sysrq-trigger
    fi
    sleep 60
done