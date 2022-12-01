#!/bin/env bash

bibList="brief-bibs.csv"
tmpJson="tmp.json"


# request access new access token using our credentials
auth_url="https://oauth.oclc.org/token"
grant_type="grant_type=client_credentials&scope=wcapi"
bearer=$(echo -n $OCLC_ID:$OCLC_Secret | base64)
token=$(curl -s -X POST $auth_url -H "Authorization: Basic $bearer" -d "$grant_type" | jq -r ".access_token")

if [ -z $token ]; then
    echo "Failed to get OCLC API token."
    exit 1
fi

endpoint="https://americas.discovery.api.oclc.org/worldcat/search/v2/brief-bibs"

echo "getting 50 records from offset=0 ..."
curl -s --get \
    --data-urlencode q="kw:microfinance" \
    --data-urlencode datePublished=1990-2010 \
    --data-urlencode inLanguage=eng \
    --data-urlencode itemType=book \
    --data-urlencode itemSubType=book-printbook \
    --data-urlencode preferredLanguage=eng \
    --data-urlencode orderBy=mostWidelyHeld \
    --data-urlencode limit=50 \
    $endpoint -H "accept: application/json" -H "Authorization: Bearer $token" > $tmpJson

# first 50 records
jq -r '.briefRecords[] | [.oclcNumber, .title, .creator, .date, .language, .generalFormat, .specificFormat ] | @csv'  $tmpJson > $bibList

# loop over remaining records
numRecs=$(jq '.numberOfRecords' $tmpJson)
i=51
while [ $i -le $numRecs ]
do
    echo "getting 50 records from offset=$i ..."
    curl -s --get \
        --data-urlencode q="kw:microfinance" \
        --data-urlencode datePublished=1990-2010 \
        --data-urlencode inLanguage=eng \
        --data-urlencode itemType=book \
        --data-urlencode itemSubType=book-printbook \
        --data-urlencode preferredLanguage=eng \
        --data-urlencode orderBy=mostWidelyHeld \
        --data-urlencode limit=50 \
        --data-urlencode offset=$i \
        $endpoint -H "accept: application/json" -H "Authorization: Bearer $token" \
        | jq -r '.briefRecords[] | [.oclcNumber, .title, .creator, .date, .language, .generalFormat, .specificFormat ] | @csv' >> $bibList
  ((i=i+50))
done