#!/bin/bash

# Get variable from config file
. ./config_ping.sh

# Get station ID from user parameter and check if it exits, if not exit 1
stationID=$1
if [[ $stationID -lt 5001 ]] || [[ $stationID -gt $((5001+$number_of_stations)) ]]
then
    echo "$stationID ${SMS_flag[0]} ${SMS_content[404]}" >> log_ping
    exit 1
fi

# Check if status_ping file and SMSDelayTimes file exits, if not create it
[ ! -f ./status_ping/$stationID ] && echo "0" > ./status_ping/$stationID
[ ! -f ./SMSDelayTimes/$stationID ] && echo "0" > ./SMSDelayTimes/$stationID

# Configurable parameters, you can change these parameters in ping_config.sh file
host=${hosts[$stationID]}
package=$packages

# Get packages and respone time threshold from config file. Return default if null
pkg_threshold=${pkg_thresholds[$stationID]}
resp_time_threshold=${resp_time_thresholds[$stationID]}
if [[ -z "$pkg_threshold" ]]; then pkg_threshold=$pkg_threshold_default; fi
if [[ -z "$resp_time_threshold" ]]; then resp_time_threshold=$resp_time_threshold_default; fi

# Get phone number to an array, if null return default
declare -a phoneNumber
all_phoneNumber=${phone_number[$stationID]}
IFS="," phoneNumber=( $all_phoneNumber )
if [[ ${#phoneNumber[@]} -eq 0 ]]; then phoneNumber+=$phone_number_default; fi

# Ping to FE and read 2 last line from output, remove '%' and 'ms'and write to ./output_ping/$1 file
ping -c $packages $host | tail -n2 | sed 's/%//' | sed 's/ms//' > ./output_ping/$1

# Get package lost percent in field 6 of ./output_ping/$1
packages_lost=`awk '{print $6}' ./output_ping/$1`

# Get event status in file ./status_ping/$stationID
eventStatus=`cat ./status_ping/$stationID`

# Get system date and delay step
sysDate=`date +'%Y-%m-%d %T'`
resentSMSDelayStep=$resentSMSDelaySteps
resentSMSDelay=`cat ./SMSDelayTimes/$stationID`

# Check status case of station, return message and send SMS if error
if [[ ! -z "$packages_lost" ]]
then
    avg_resp_time=`tail -n1 ./output_ping/$1 | awk -F/ '{print int($5)}'`
    if [[ $packages_lost -lt $pkg_threshold ]] && [[ $avg_resp_time -lt $resp_time_threshold ]]
    then
        currentStatus=0
        if [[ $eventStatus -gt 0 ]]
        then
            if [[ sysDate > resentSMSDelay ]]
            then  
                bash ./sendSMS.sh "$stationID ${SMS_flag[1]} ${SMS_content[$eventStatus$currentStatus]}" ${phoneNumber[@]}
                resentSMSDelay=$(date +'%Y-%m-%d %T' --date="$sysDate $resentSMSDelayStep minutes")
                echo $resentSMSDelay > ./SMSDelayTimes/$stationID
                echo "$stationID ${SMS_content[10]}" > ./log/$stationID
            else
                echo "$stationID ${SMS_flag[0]} ${SMS_content[$eventStatus$currentStatus]}" > ./log/$stationID
            fi
            echo "0" > ./status_ping/$stationID
        else 
            echo "$stationID ${SMS_flag[0]} ${SMS_content[00]}" > ./log/$stationID 
        fi
    elif [[ $packages_lost -ge $threshold ]] || [[ $avg_resp_time -ge $resp_time_threshold ]]
    then
        currentStatus=1
        if [[ $eventStatus -eq 0 ]]
        then
            if [[ sysDate > resentSMSDelay ]]
            then
                bash ./sendSMS.sh "$stationID ${SMS_flag[1]} ${SMS_content[01]}" ${phoneNumber[@]}
                echo "$stationID ${SMS_flag[1]} ${SMS_content[01]}" > ./log/$stationID
                resentSMSDelay=$(date +'%Y-%m-%d %T' --date="$sysDate $resentSMSDelayStep minutes")
                echo $resentSMSDelay > ./SMSDelayTimes/$stationID
            else
                echo "$stationID ${SMS_flag[0]} ${SMS_content[01]}" > ./log/$stationID
            fi
            echo "1" > ./status_ping/$stationID
        elif [[ $eventStatus -eq 1 ]]
        then
            if [[ sysDate > resentSMSDelay ]]
            then
                bash ./sendSMS.sh "$stationID ${SMS_flag[1]} ${SMS_content[11]}" ${phoneNumber[@]}
                echo "$stationID ${SMS_flag[1]} ${SMS_content[11]}" > ./log/$stationID
                resentSMSDelay=$(date +'%Y-%m-%d %T' --date="$sysDate $resentSMSDelayStep minutes")
                echo $resentSMSDelay > ./SMSDelayTimes/$stationID
            else
                echo "$stationID ${SMS_flag[0]} ${SMS_content[11]}" > ./log/$stationID
            fi
        elif [[ $eventStatus -eq 2 ]]
        then
            bash ./sendSMS.sh "$stationID ${SMS_flag[1]} ${SMS_content[21]}" ${phoneNumber[@]}
            echo "$stationID ${SMS_flag[1]} ${SMS_content[21]}" > ./log/$stationID
            echo "1" > ./status_ping/$stationID
        fi  
    fi
else
    currentStatus=2
    if [[ sysDate > resentSMSDelay ]]
    then
        bash ./sendSMS.sh "$stationID ${SMS_flag[1]} ${SMS_content[$eventStatus$currentStatus]}" ${phoneNumber[@]}
        echo "$stationID ${SMS_flag[1]} ${SMS_content[$eventStatus$currentStatus]}" > ./log/$stationID
        echo "2" > ./status_ping/$stationID
        resentSMSDelay=$(date +'%Y-%m-%d %T' --date="$sysDate $resentSMSDelayStep minutes")
        echo $resentSMSDelay > ./SMSDelayTimes/$stationID 
    else
        echo "$stationID ${SMS_flag[0]} ${SMS_content[$eventStatus$currentStatus]}" > ./log/$stationID
    fi 
fi
