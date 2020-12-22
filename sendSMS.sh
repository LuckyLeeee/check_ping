#!/bin/bash

# Get sms content in variable 1 and the rest for phone number
sms="$1"
shift
arr=("$@")

# Send sms to all phone number
for i in "${arr[@]}";
do
echo -e '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:impl="http://impl.bulkSms.ws/">
   <soapenv:Header/>
   <soapenv:Body>
      <impl:wsCpMt>
         <!--Optional:-->
         <User>vdtc</User>
         <!--Optional:-->
         <Password>$18ac#75%@</Password>
         <!--Optional:-->
         <CPCode>VDTC</CPCode>
         <!--Optional:-->
         <RequestID>1</RequestID>
         <!--Optional:-->
         <UserID>'$i'</UserID>
         <!--Optional:-->
         <ReceiverID>'$i'</ReceiverID>
         <!--Optional:-->
         <ServiceID>ePass-VDTC</ServiceID>
         <!--Optional:-->
         <CommandCode>bulksms</CommandCode>
         <!--Optional:-->
         <Content>'$sms'</Content>
         <!--Optional:-->
         <ContentType>0</ContentType>
      </impl:wsCpMt>
   </soapenv:Body>
</soapenv:Envelope>'| curl -X POST -H "Content-Type: text/xml" \
    -H 'SOAPAction: "http://ams.tinnhanthuonghieu.vn:8009/bulkapi?wsdl"' \
    --data-binary @- \
http://ams.tinnhanthuonghieu.vn:8009/bulkapi?wsdl > /dev/null 2>&1
done
