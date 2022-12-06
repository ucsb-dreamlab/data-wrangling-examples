#!/bin/env bash

# search params for brief-bibs.
# See: https://developer.api.oclc.org/wcv2#/Bibliographic%20Resources/search-brief-bibs
q="kw:microfinance"
datePublished="1990-2010"
inLanguage="eng"
itemSubType="book-printbook"
preferredLanguage="eng"

# API enddpoint
endpoint="https://americas.discovery.api.oclc.org/worldcat/search/v2/brief-bibs"

# config output files
bibList="data/brief-bibs.csv"
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


echo "getting 50 records from offset=0 ..."
curl -s --get \
    --data-urlencode q=$q \
    --data-urlencode datePublished=$datePublished \
    --data-urlencode inLanguage=$inLanguage \
    --data-urlencode itemSubType=$itemSubType \
    --data-urlencode preferredLanguage=$preferredLanguage \
    --data-urlencode orderBy=mostWidelyHeld \
    --data-urlencode limit=50 \
    $endpoint -H "accept: application/json" -H "Authorization: Bearer $token" > $tmpJson

# first 50 records
jq -r '.briefRecords[] | [.oclcNumber, .title, .creator, .date, .language, .generalFormat, .specificFormat ] | @csv'  $tmpJson > $bibList

# loop over remaining records
numRecs=$(jq '.numberOfRecords' $tmpJson)
echo "downloading $numRecs records ..."
i=51
while [ $i -le $numRecs ]
do
    echo "getting next 50 records from offset=$i ..."
    curl -s --get \
        --data-urlencode q=$q \
        --data-urlencode datePublished=$datePublished \
        --data-urlencode inLanguage=$inLanguage \
        --data-urlencode itemSubType=$itemSubType \
        --data-urlencode preferredLanguage=$preferredLanguage \
        --data-urlencode orderBy=mostWidelyHeld \
        --data-urlencode limit=50 \
        --data-urlencode offset=$i \
        $endpoint -H "accept: application/json" -H "Authorization: Bearer $token" \
        | jq -r '.briefRecords[] | [.oclcNumber, .title, .creator, .date, .language, .generalFormat, .specificFormat ] | @csv' >> $bibList
  ((i=i+50))
done

rm $tmpJson
echo "done: saved to $bibList"