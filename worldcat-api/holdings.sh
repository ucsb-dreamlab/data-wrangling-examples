#!/bin/env bash

bibList="brief-bibs.csv"
tmpJson="tmp.json" # temporary file 

# request access new access token using our credentials
auth_url="https://oauth.oclc.org/token"
grant_type="grant_type=client_credentials&scope=wcapi"
bearer=$(echo -n $OCLC_ID:$OCLC_Secret | base64)
token=$(curl -s -X POST $auth_url -H "Authorization: Basic $bearer" -d "$grant_type" | jq -r ".access_token")

if [ -z $token ]; then
    echo "Failed to get OCLC API token."
    exit 1
fi
# oclcNumber=41266045&holdingsAllEditions=true&holdingsAllVariantRecords=false&preferredLanguage=eng&heldInCountry=US' \
endpoint="https://americas.discovery.api.oclc.org/worldcat/search/v2/bibs-summary-holdings"

for i in $(awk -F, '{gsub(/"/, "", $1); print $1}' $bibList); do 
    echo "getting holdings for $i"
    # holdUS=$(curl -s --get \
    #     --data-urlencode oclcNumber=$i \
    #     --data-urlencode holdingsAllEditions=true \
    #     --data-urlencode holdingsAllVariantRecords=false \
    #     --data-urlencode heldInCountry=US \
    #     $endpoint -H "accept: application/json" -H "Authorization: Bearer $token" \
    #     | jq '.briefRecords[].institutionHolding.totalHoldingCount')
    holdSF=$(curl -s --get \
        --data-urlencode oclcNumber=$i \
        --data-urlencode holdingsAllEditions=true \
        --data-urlencode holdingsAllVariantRecords=false \
        --data-urlencode lat=37.773972 \
        --data-urlencode lon=-122.431297 \
        --data-urlencode distance=100 \
        --data-urlencode unit=M \
        $endpoint -H "accept: application/json" -H "Authorization: Bearer $token" \
        | jq '.briefRecords[].institutionHolding.totalHoldingCount')
    holdFR=$(curl -s --get \
        --data-urlencode oclcNumber=$i \
        --data-urlencode holdingsAllEditions=true \
        --data-urlencode holdingsAllVariantRecords=false \
        --data-urlencode heldInCountry=FR \
        $endpoint -H "accept: application/json" -H "Authorization: Bearer $token" \
        | jq '.briefRecords[].institutionHolding.totalHoldingCount')
    echo $i, $holdSF, $holdFR >> holdings-SF-FR.csv
done
