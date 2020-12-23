#!/bin/bash

# Declare array variable
declare -a hosts
declare -a status
declare -a pkg_thresholds
declare -a resp_time_thresholds
declare -a emails
declare -a email_content
declare -a email_flag

# Default variable
packages=50
resent_email_delay_steps=20
pkg_threshold_default=20
resp_time_threshold_default=100
#email_default="vinhnt@vdtc.com.vn,daint@vdtc.com.vn,hann2@vdtc.com.vn,tungnk@vdtc.com.vn"
email_default="vinhnt@vdtc.com.vn,luckylee2110@gmail.com,vinh.nt2110@gmail.com"
time=`date +'%R'` 

# Variable in each stations
email_flag=( [0]="- No Email"  [1]="- Email" )
email_content=( [404]="- Station not found - Error 404 - $time"  [00]="- Stable connection - Code 00 - $time"
              [10]="- Connection fixed - Code 10 - $time"      [20]="- Connection fixed - Code 20 - $time"
              [01]="- Unstable connection - Error 01 - $time"  [11]="- Connection has not been fixed - Error 11 - $time"
              [21]="- Destination host reachable but unstable connection - Error 21 - $time"
              [02]="- Destination host unreachable - Error 02 - $time"
              [12]="- Destination host unreachable - Error 12 - $time"
              [22]="- Destination host unreachable - Error 22 - $time" ) 
hosts=( [5001]=10.254.255.138  [5002]=10.254.248.1   [5003]=10.254.248.6   [5004]=10.254.248.11  [5005]=10.254.248.16
        [5006]=10.254.248.21   [5007]=10.254.247.11  [5008]=10.254.247.12  [5009]=10.254.247.13  [5010]=10.254.247.14  
        [5011]=10.254.247.15   [5012]=10.254.247.16  [5013]=10.254.247.17  [5014]=10.254.247.22  [5015]=10.254.247.23  
        [5016]=10.254.247.30   [5017]=10.254.247.31  [5018]=10.254.247.32  [5019]=10.254.247.33  [5020]=10.254.247.41
        [5021]=10.254.247.42   [5022]=10.254.247.43  [5023]=10.254.247.44  [5024]=10.254.246.2   [5025]=10.254.246.3 
        [5026]=10.254.246.4    [5027]=10.254.246.5  )

number_of_stations=${#hosts[@]}

pkg_thresholds=(
        [5001]=20  [5002]=20  [5003]=20  [5004]=20  [5005]=20 
        [5006]=20  [5007]=20  [5008]=20  [5009]=20  [5010]=20 
        [5011]=20  [5012]=20  [5013]=20  [5014]=20  [5015]=20 
        [5016]=20  [5017]=20  [5018]=20  [5019]=20  [5020]=20
        [5021]=20  [5022]=20  [5023]=20  [5024]=20  [5025]=20 
        [5026]=20  [5027]=20  )

resp_time_thresholds=(
        [5001]=100  [5002]=100  [5003]=100  [5004]=100  [5005]=100 
        [5006]=100  [5007]=100  [5008]=100  [5009]=100  [5010]=100 
        [5011]=100  [5012]=100  [5013]=100  [5014]=100  [5015]=100 
        [5016]=100  [5017]=100  [5018]=100  [5019]=100  [5020]=100
        [5021]=100  [5022]=100  [5023]=100  [5024]=100  [5025]=100 
        [5026]=100  [5027]=100  )
emails=(
)
