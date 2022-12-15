#!/bin/env bash

holdings="data/holdings.csv"

extract_bibs() {
    bibsDir="$1"
    fields="oclcNumber,mainTitle,firstName,secondName,nonPersonName,creatorType,isPrimary,publisherName,publicationPlace,machineReadableDate,itemLanguage,physicalDescription,holdings"
    echo "$fields"
    for f in $(ls $bibsDir/*.json); do 
        # get holdings
        id=$(basename "$f" | cut -d "." -f 1)
        hold=$(grep "^\\\"$id\\\"," "$holdings" | awk -F, '{print $2}' )
        bib=$(jq -r '[.identifier.oclcNumber,
            .title.mainTitles[0].text,
            .contributor.creators[0].firstName.text,
            .contributor.creators[0].secondName.text,
            .contributor.creators[0].nonPersonName.text,
            .contributor.creators[0].type,
            .contributor.creators[0].isPrimary,
            .publishers[0].publisherName.text, 
            .publishers[0].publicationPlace,
            .date.machineReadableDate,
            .language.itemLanguage, 
            .description.physicalDescription] | @csv' "$f")
        echo "$bib,$hold"
    done
}

extract_authors() {
    bibsDir="$1"
    echo "oclcNumber,mainTitle,firstName,secondName,nonPersonName,creatorType,isPrimary,creatorPosition"
    for f in $(ls $bibsDir/*.json); do
        jq -r '. as $all | foreach .contributor.creators[] as $creator (0;.+1; [
            $all.identifier.oclcNumber,
            $all.title.mainTitles[0].text, 
            $creator.firstName.text, 
            $creator.secondName.text, 
            $creator.nonPersonName.text,
            $creator.type,
            $creator.isPrimary, .]) | @csv' "$f" 
    done
}

extract_bibs "data/bibs" > "data/bibs.csv"
extract_authors "data/bibs" > "data/authors.csv"