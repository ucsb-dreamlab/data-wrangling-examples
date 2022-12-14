#!/bin/env bash

output="data/holdings.csv"

# API endpoint
endpoint="https://americas.discovery.api.oclc.org/worldcat/search/v2/bibs-summary-holdings"

# request access new access token using our credentials
auth_url="https://oauth.oclc.org/token"
grant_type="grant_type=client_credentials&scope=wcapi"
bearer=$(echo -n $OCLC_ID:$OCLC_SECRET | base64)
token=$(curl -s -X POST $auth_url -H "Authorization: Basic $bearer" -d "$grant_type" | jq -r ".access_token")

if [[ $token = "null" ]]; then
    echo "Failed to get OCLC API token."
    exit 1
fi

# function to get holding info for a given ocfl number
get_holdings() { 
    oclcNumber="$1"
    if [ -z "$oclcNumber" ]; then
        echo "error: no oclcNumber given"
        return -1
    fi
    curl -s --get \
        --data-urlencode oclcNumber=$oclcNumber \
        --data-urlencode holdingsAllEditions=true \
        --data-urlencode holdingsAllVariantRecords=false \
        $endpoint -H "accept: application/json" -H "Authorization: Bearer $token" \
        | jq -r '[.briefRecords[].oclcNumber , .briefRecords[].institutionHolding.totalHoldingCount] | @csv'
}

for file in $(ls data/bibs/*.json); do 
    id=$(basename $file | awk -F. '{print $1}')
    existing=$(grep "^\\\"$id\\\"," "$output" | awk -F, '{gsub(/"/,"",$2); print $2}')
    if [[ -z "$existing" ]]; then 
        holdings=$(get_holdings "$id")
        if [[ $? -gt 0 ]]; then
            echo "exiting on $id"
            exit 1
        fi
        echo "$id - saved"
        echo $holdings >> $output
    else
        echo "$id - exists"
    fi
done