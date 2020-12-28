#!/bin/bash

# Get variable from config file
. ./config_ping.sh

# Get station ID from user parameter and check if it exits, if not exit 1
station_id=$1
if [[ $station_id -lt 5001 ]] || [[ $station_id -gt $((5001+$number_of_stations)) ]]
then
    echo "$station_id ${email_flag[0]} ${email_content[404]}" >> log_ping
    exit 1
fi

# Check if status_ping file and email_delay_time file exits, if not create it
[ ! -f ./status_ping/$station_id ] && echo "0" > ./status_ping/$station_id
[ ! -f ./email_delay_time/$station_id ] && echo "0" > ./email_delay_time/$station_id

# Configurable parameters, you can change these parameters in ping_config.sh file
host=${hosts[$station_id]}
package=$packages

# Get packages and respone time threshold from config file. Return default if null
pkg_threshold=${pkg_thresholds[$station_id]}
resp_time_threshold=${resp_time_thresholds[$station_id]}
if [[ -z "$pkg_threshold" ]]; then pkg_threshold=$pkg_threshold_default; fi
if [[ -z "$resp_time_threshold" ]]; then resp_time_threshold=$resp_time_threshold_default; fi

# Push email to an array, if null return default
declare -a email
IFS="," email=( $email_default )

# Ping to FE and read 2 last line from output, remove '%' and 'ms'and write to ./output_ping/$1 file
ping -c $package $host | tail -n2 | sed 's/%//' | sed 's/ms//' > ./output_ping/$1

# Get package lost percent in field 6 of ./output_ping/$1
packages_lost=`awk '{print $6}' ./output_ping/$1`

# Get event status in file ./status_ping/$station_id
event_status=`cat ./status_ping/$station_id`

# Get system date and delay step
system_date=`date +'%Y-%m-%d %T'`
resent_email_delay_step=$resent_email_delay_steps
resent_email_delay=`cat ./email_delay_time/$station_id`

# Check status case of station, return message and send email if error
if [[ ! -z "$packages_lost" ]]
then
    avg_resp_time=`tail -n1 ./output_ping/$1 | awk -F/ '{print int($5)}'`
    if [[ $packages_lost -lt $pkg_threshold ]] && [[ $avg_resp_time -lt $resp_time_threshold ]]
    then
        current_status=0
        if [[ $event_status -gt 0 ]]
        then
            if [[ $system_date > $resent_email_delay ]]
            then  
                echo "$station_id $host ${email_flag[1]} ${email_content[$event_status$current_status]}" > ./log/$station_id
                resent_email_delay=$(date +'%Y-%m-%d %T' --date="$system_date $resent_email_delay_step minutes")
                echo $resent_email_delay > ./email_delay_time/$station_id
                bash .send_email.sh ./log/$station_id ${email[@]}
            else
                echo "$station_id $host ${email_flag[0]} ${email_content[$event_status$current_status]}" > ./log/$station_id
            fi
            echo "0" > ./status_ping/$station_id
        else 
            echo "$station_id $host ${email_flag[0]} ${email_content[00]}" > ./log/$station_id 
        fi
    elif [[ $packages_lost -ge $threshold ]] || [[ $avg_resp_time -ge $resp_time_threshold ]]
    then
        current_status=1
        if [[ $event_status -eq 0 ]]
        then
            if [[ $system_date > $resent_email_delay ]]
            then
                echo "$station_id $host ${email_flag[1]} ${email_content[01]}" > ./log/$station_id
                resent_email_delay=$(date +'%Y-%m-%d %T' --date="$system_date $resent_email_delay_step minutes")
                echo $resent_email_delay > ./email_delay_time/$station_id
                bash .send_email.sh ./log/$station_id ${email[@]}
            else
                echo "$station_id $host ${email_flag[0]} ${email_content[01]}" > ./log/$station_id
            fi
            echo "1" > ./status_ping/$station_id
        elif [[ $event_status -eq 1 ]]
        then
            if [[ $system_date > $resent_email_delay ]]
            then
                echo "$station_id $host ${email_flag[1]} ${email_content[11]}" > ./log/$station_id
                resent_email_delay=$(date +'%Y-%m-%d %T' --date="$system_date $resent_email_delay_step minutes")
                echo $resent_email_delay > ./email_delay_time/$station_id
                bash .send_email.sh ./log/$station_id ${email[@]}
            else
                echo "$station_id $host ${email_flag[0]} ${email_content[11]}" > ./log/$station_id
            fi
        elif [[ $event_status -eq 2 ]]
        then
            echo "$station_id $host ${email_flag[1]} ${email_content[21]}" > ./log/$station_id
            echo "1" > ./status_ping/$station_id
            bash .send_email.sh ./log/$station_id ${email[@]}
        fi  
    fi
else
    current_status=2
    if [[ $system_date > $resent_email_delay ]]
    then
        echo "$station_id $host ${email_flag[1]} ${email_content[$event_status$current_status]}" > ./log/$station_id
        echo "2" > ./status_ping/$station_id
        resent_email_delay=$(date +'%Y-%m-%d %T' --date="$system_date $resent_email_delay_step minutes")
        echo $resent_email_delay > ./email_delay_time/$station_id
        bash .send_email.sh ./log/$station_id ${email[@]}
    else
        echo "$station_id $host ${email_flag[0]} ${email_content[$event_status$current_status]}" > ./log/$station_id
    fi 
fi
