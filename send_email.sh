#!/bin/bash

# Get email content in variable 1 and the rest for received email
content="$1"
shift
email=("$@")

# Send content to all email
for i in "${email[@]}";
do
  curl --url smtps://smtp.vdtc.com.vn --mail-from "support@vdtc.com.vn" --mail-rcpt $i --upload-file $content --user "support@vdtc.com.vn:Etc@2020"
done
