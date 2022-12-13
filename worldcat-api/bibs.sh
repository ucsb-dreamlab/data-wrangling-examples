#!/bin/env bash

# get a response with 50 bibs
get_bibs() {
    declare off="$1"

    # Search bibs endpoint
    # See: https://developer.api.oclc.org/wcv2#/Bibliographic%20Resources/search-bibs
    endpoint="https://americas.discovery.api.oclc.org/worldcat/search/v2/bibs"
    q="kw:microfinance OR kw:microcredit" # or microcredit
    datePublished="1970-2022"
    inLanguage="eng"
    itemSubType="book-printbook"
    preferredLanguage="eng"
    orderBy="mostWidelyHeld"

    # set offset
    if [[ -z "$off" ]]; then
        off="1"
    fi

    curl -s --get \
        --data-urlencode q="$q" \
        --data-urlencode datePublished="$datePublished" \
        --data-urlencode inLanguage="$inLanguage" \
        --data-urlencode itemSubType="$itemSubType" \
        --data-urlencode preferredLanguage="$preferredLanguage" \
        --data-urlencode orderBy="$orderBy" \
        --data-urlencode limit=50 \
        --data-urlencode offset="$off" \
        $endpoint -H "accept: application/json" -H "Authorization: Bearer $token"
}

save_bibs() {
    dir="$1"
    result="$2"
    resulSize=$(echo $result | jq '.bibRecords | length')
     if [ $? -gt 0 ]; then
            echo "exiting with error"
            exit 1
        fi
    i=0
    while [[ $i -lt $resulSize ]]; do
        bib=$(echo $result | jq ".bibRecords[$i]")
        if [ $? -gt 0 ]; then
            echo "exiting with error"
            exit 1
        fi
        id=$(echo $bib | jq -r ".identifier.oclcNumber")
        if [ $? -gt 0 ]; then
            echo "exiting with error"
            exit 1
        fi
        # save output
        file="$dir/$id.json"
        if [[ -a $file ]]; then
            echo "file already exists: $file"
        else
            echo $bib > "$file"
        fi
        ((i=i+1))
    done
}



# config output files
bibJsonDir="data/bibs"

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
if [[ -z "$OCLC_ID" ]]; then
    echo 'set $OCLC_ID to your OCLC API ID'
    exit 1
fi

if [[ -z $OCLC_SECRET ]]; then
    echo 'set $OCLC_SECRET to your OCLC API Secret'
    exit 1
fi

# request a new access token using our credentials
auth_url="https://oauth.oclc.org/token"
grant_type="grant_type=client_credentials&scope=wcapi"
bearer=$(echo -n "$OCLC_ID:$OCLC_SECRET" | base64)
token=$(curl -s -X POST $auth_url -H "Authorization: Basic $bearer" -d "$grant_type" | jq -r ".access_token")

if [[ $token = "null" ]]; then
    echo "Failed to get OCLC API token: $token"
    exit 1
fi

# first 50 records
echo "getting first 50 records"
result=$(get_bibs 1)

if [ $? -gt 0 ]; then
    echo "exiting"
    exit 1
fi

totalRecs=$(echo $result | jq '.numberOfRecords')

if [ $totalRecs = "null" ]; then
    echo $result
    exit 1
fi

# save first 50 bibs
save_bibs "$bibJsonDir" "$result"

offset=51
while [[ $offset -lt $totalRecs ]]; do 
    echo "getting records $offset-$((($offset+50)))/$totalRecs"
    result=$(get_bibs $offset)
    save_bibs "$bibJsonDir" "$result"
    ((offset=offset+50))
done




# echo "downloading $totalRecs records ..."
# i=51
# while [ $i -le $totalRecs ]
# do
#     get_bibs
#     ((i=i+50))
# done

# rm $tmpJson
# echo "done"
