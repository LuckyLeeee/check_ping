#!/bin/bash

# Declare array variable
declare -a id
declare -a hosts
declare -a status
declare -a pkg_thresholds
declare -a resp_time_thresholds
declare -a phone_number
declare -a SMS_content
declare -a SMS_flag

# Default variable
packages=10
resentSMSDelaySteps=5
pkg_threshold_default=20
resp_time_threshold_default=80
phone_number_default=( 84967236147 84
time=`date +'%R'` 

# Variable in each stations
SMS_flag=( [0]="- No SMS"  [1]="- SMS" )
SMS_content=( [404]="- Station not found - Error 404 - $time"  [00]="- Stable connection - Code 00 - $time"
              [10]="- Connection fixed - Code 10 - $time"      [20]="- Connection fixed - Code 20 - $time"
              [01]="- Unstable connection - Error 01 - $time"  [11]="- Connection has not been fixed - Error 11 - $time"
              [21]="- Destination host reachable but unstable connection - Error 21 - $time"
              [02]="- Destination host unreachable - Error 02 - $time"
              [12]="- Destination host unreachable - Error 12 - $time"
              [22]="- Destination host unreachable - Error 22 - $time" )
hosts=( [5001]=google.com   [5002]=fb.com         [5003]=reddit.com     [5004]=youtube.com   [5005]=github.com    
        [5006]=amazon.com   [5007]=wikipedia.org  [5008]=archlinux.org  [5009]=linkedin.com  [5010]=duckduckgo.com  
        [5011]=google.com   [5012]=fb.com         [5013]=reddit.com     [5014]=youtube.com   [5015]=github.com  
        [5016]=amazon.com   [5017]=wikipedia.org  [5018]=archlinux.org  [5019]=linkedin.com  [5020]=duckduckgo.com
        [5021]=google.com   [5022]=fb.com         [5023]=reddit.com     [5024]=youtube.com   [5025]=github.com 
        [5026]=amazon.com   [5027]=wikipedia.org  [5028]=archlinux.org  [5029]=linkedin.com  [5030]=duckduckgo.com
        [5031]=google.com   [5032]=fb.com         [5033]=reddit.com     [5034]=youtube.com   [5035]=github.com  
        [5036]=amazon.com   [5037]=wikipedia.org  [5038]=archlinux.org  [5039]=linkedin.com  [5040]=duckduckgo.com )
number_of_stations=${#hosts[@]}
pkg_thresholds=(
        [5001]=10  [5002]=10  [5003]=10  [5004]=10  [5005]=10 
        [5006]=10  [5007]=10  [5008]=10  [5009]=10  [5010]=10 
        [5011]=10  [5012]=10  [5013]=10  [5014]=10  [5015]=10 
        [5016]=10  [5017]=10  [5018]=10  [5019]=10  [5020]=10
        [5021]=10  [5022]=10  [5023]=10  [5024]=10  [5025]=10 
        [5026]=10  [5027]=10  [5028]=10  [5029]=10  [5030]=10 
        [5031]=10  [5032]=10  [5033]=10  [5034]=10  [5035]=10
        [5036]=10  [5037]=10  [5038]=10  [5039]=10  [5040]=10 )
resp_time_thresholds=(
        [5001]=50  [5002]=50  [5003]=50  [5004]=50  [5005]=50 
        [5006]=50  [5007]=50  [5008]=50  [5009]=50  [5010]=50 
        [5011]=50  [5012]=50  [5013]=50  [5014]=50  [5015]=50 
        [5016]=50  [5017]=50  [5018]=50  [5019]=50  [5020]=50
        [5021]=50  [5022]=50  [5023]=50  [5024]=50  [5025]=50 
        [5026]=50  [5027]=50  [5028]=50  [5029]=50  [5030]=50 
        [5031]=50  [5032]=50  [5033]=50  [5034]=50  [5035]=50
        [5036]=50  [5037]=50  [5038]=50  [5039]=50  [5040]=50 )
phone_number=(
  [5030]=84965101998,84967236147
)
