#!/bin/env bash

# query params
sf_lat="37.7775"        # San Francisco Latitude
sf_long="-122.416389"   # San Francisco Longitude
sf_distance="100"       # Distance in miles from SF
fr_country="FR"         # France - ISO 3166

#input list
bibList="data/brief-bibs.csv"

# output
holdingList="data/holdings.csv"
tmpJson="tmp.json" # removed at the end

# API endpoint
endpoint="https://americas.discovery.api.oclc.org/worldcat/search/v2/bibs-summary-holdings"

# request access new access token using our credentials
auth_url="https://oauth.oclc.org/token"
grant_type="grant_type=client_credentials&scope=wcapi"
bearer=$(echo -n $OCLC_ID:$OCLC_SECRET | base64)
token=$(curl -s -X POST $auth_url -H "Authorization: Basic $bearer" -d "$grant_type" | jq -r ".access_token")

if [ $token = "null" ]; then
    echo "Failed to get OCLC API token."
    exit 1
fi

# function to get holding info for a given ocfl number
get_holdings() { 
    oclcNumber=$1
    if [ -z "$oclcNumber" ]; then
        echo "error: no oclcNumber given"
        return -1
    fi
    echo "getting holdings for $oclcNumber"
    holdSF=$(curl -s --get \
        --data-urlencode oclcNumber=$oclcNumber \
        --data-urlencode holdingsAllEditions=true \
        --data-urlencode holdingsAllVariantRecords=false \
        --data-urlencode lat=$sf_lat \
        --data-urlencode lon=$sf_long \
        --data-urlencode distance=$sf_distance \
        --data-urlencode unit=M \
        $endpoint -H "accept: application/json" -H "Authorization: Bearer $token" \
        | jq '.briefRecords[].institutionHolding.totalHoldingCount')
    holdFR=$(curl -s --get \
        --data-urlencode oclcNumber=$oclcNumber \
        --data-urlencode holdingsAllEditions=true \
        --data-urlencode holdingsAllVariantRecords=false \
        --data-urlencode heldInCountry=$fr_country \
        $endpoint -H "accept: application/json" -H "Authorization: Bearer $token" \
        | jq '.briefRecords[].institutionHolding.totalHoldingCount')
    echo "$holdSF,$holdFR"
}

if [ ! -z "$1" ]; then
    echo "holdings for SF and FR: $(get_holdings $1)"
    exit
fi

# loop over input csv
while read -r line; do
    # just the OCLC number
    i=$(echo $line | awk -F, '{gsub(/"/, "", $1); print $1}')
    
    echo $line,$(get_holdings $i) >> $holdingList
done < $bibList

echo "done"
