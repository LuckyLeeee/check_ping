#!/bin/bash

. ./config_ping.sh
declare -a emails
IFS="," emails=( $email_default )

bash .send_email.sh mail.txt ${emails[@]}
