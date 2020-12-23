#!/bin/bash
# declare STRING variable
curl -X POST -H "Content-Type: text/xml" \
    -H 'SOAPAction: "http://ams.tinnhanthuonghieu.vn:8009/bulkapi?wsdl"' \
    --data-binary @getIPSoap.xml \
http://ams.tinnhanthuonghieu.vn:8009/bulkapi?wsdl

