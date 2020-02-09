#!/bin/bash

getUptime() {
    echo $(awk '{print int($1)}' /proc/uptime)
}

testInternet() {
    # based on https://stackoverflow.com/questions/929368/how-to-test-an-internet-connection-with-bash/932187#932187
    # Some servers requiring sudo for ping
    sudo ping -q -w 1 -c 1 8.8.8.8 > /dev/null && return 0 || return 1
}

CONTROLFILE=/tmp/raspi-util-netmonitor-lastnetaccess.log
THRESHOLD=3600 # in seconds; recommend this isn't too low 3600=1hr

while true; do
    secs=$(getUptime) 
    echo "Current uptime is $secs"   
    if [ ! -f $CONTROLFILE ]; then
        # By setting a lower limit, we ensure we won't reboot too early (e.g. if network stack not up yet)
        echo 300 >$CONTROLFILE
    fi

    lastping=$(cat $CONTROLFILE)

    if [ $lastping -ge $secs ]; then
        # Skippedy doo daa.
        waittime=$(( $lastping-$secs ))
        echo "Waiting for device to be up for long enough... sleeping for $waittime sec(s)"
        sleep $waittime        
    else
        # See if we can contact google. If so, great.
        testInternet
        if testInternet; then
            echo "Internet connection detected at uptime $secs"
            echo $secs >$CONTROLFILE
        else 
            # What's the diff?
            diff=$(( $secs-$lastping ))
            echo "Last internet connection was $diff second(s) ago. Threshold is $THRESHOLD."
            if [ $diff -ge $THRESHOLD ]; then
                echo "Triggering a reboot"
                sudo reboot
                sleep 60
            fi
        fi
        sleep 60
    fi
    sleep 1 # Sanity check
done