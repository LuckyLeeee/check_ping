#!/bin/bash

# Change file directory and get variable from config file
cd ~/.check_ping
. ./config_ping.sh

# Create log with system date
echo -e "`date` - Crontab run: \n" >> log_ping

# Ping to all station 
for ((i = 5001; i <= $((5001+$number_of_stations)); i++))
do
  bash ./ping.sh $i &
done
wait

# Sort log file and put into master log
cat ./log/* | sort -V >> log_ping
echo -e "\n`date` - Crontab end: \n" >> log_ping
