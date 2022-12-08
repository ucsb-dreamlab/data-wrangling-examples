#!/bin/env bash

# search params for brief-bibs.
# See: https://developer.api.oclc.org/wcv2#/Bibliographic%20Resources/search-brief-bibs
q="kw:microfinance OR kw:microcredit" # or microcredit
datePublished="1970-2022"
inLanguage="eng"
itemSubType="book-printbook"
preferredLanguage="eng"
orderBy="mostWidelyHeld"

# API enddpoint
endpoint="https://americas.discovery.api.oclc.org/worldcat/search/v2/bibs"
jqexpr='.briefRecords[] | [.oclcNumber, .title, .creator, .machineReadableDate, .language, .generalFormat, .specificFormat ] | @csv'

# config output files
bibJsonDir="data/bibs"
tmpJson="data/tmp.json" # removed at the end of the script

# check curl is installed
if ! command -v curl &> /dev/null;then
    echo "command 'curl' not found"
    exit 1
fi

# check jq is installed
if ! command -v jq &> /dev/null;then
    echo "command 'jq' not found"
    exit 1
fi

# check API credentials
if [ -a $OCLC_ID ]; then
    echo 'set $OCLC_ID to your OCLC API ID'
    exit 1
fi

if [ -a $OCLC_SECRET ]; then
    echo 'set $OCLC_SECRET to your OCLC API Secret'
    exit 1
fi

# request a new access token using our credentials
auth_url="https://oauth.oclc.org/token"
grant_type="grant_type=client_credentials&scope=wcapi"
bearer=$(echo -n $OCLC_ID:$OCLC_SECRET | base64)
token=$(curl -s -X POST $auth_url -H "Authorization: Basic $bearer" -d "$grant_type" | jq -r ".access_token")

if [ $token = "null" ]; then
    echo "Failed to get OCLC API token: $token"
    exit 1
fi

offset=1
totalRecs=0
response=""

get_bibs() {
    curl -s --get \
        --data-urlencode q=$q \
        --data-urlencode datePublished=$datePublished \
        --data-urlencode inLanguage=$inLanguage \
        --data-urlencode itemSubType=$itemSubType \
        --data-urlencode preferredLanguage=$preferredLanguage \
        --data-urlencode orderBy=$orderBy \
        --data-urlencode limit=501 \
        --data-urlencode offset=$offset \
        $endpoint -H "accept: application/json" -H "Authorization: Bearer $token"
}

# first 50 records
result=$(get_bibs)

if [ $? -gt 0 ]; then
    echo "exiting"
    exit 1
fi

numRecs=$(echo $result | jq '.numberOfRecords')

if [ $numRecs = "null" ]; then
    echo $result
    exit 1
fi


echo "downloading $numRecs records ..."
i=51
while [ $i -le $numRecs ]
do
    get_bibs
    ((i=i+50))
done

rm $tmpJson
echo "done"
