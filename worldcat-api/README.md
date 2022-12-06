# Using the WorldCat Search API with cURL and jq

This example includes bash scripts that use `curl` and `jq` to download
bibliographic data from OCLC's [WorldCat Search
API](https://developer.api.oclc.org/wcv2). OCLC's API is not publicly
accessible. To use these scripts, you will need an API key 

## Setup

The bash scripts require `curl` and `jq`. These programs should be installed and
accessible on your PATH. In addition, you should set two environment variables
with your OCLC API id and secret:

```sh
export OCLC_ID="...YOUR API ID..."
export OCLC_SECRET="...YOUR API Secret..."
```


## `brief-bibs.sh`

This scripts uses the `brief-bibs` API to download book data based on criteria
specified in the script. The results are written to `data/brief-bibs.csv`. Run
the script from the command line:

```sh
# writes data to data/brief-bibs.csv
$ bash brief-bibs.sh
```

The scripts can be configured through variables defined in the file: 

```sh
# brief-bibs.sh

# search params for brief-bibs.
# See: https://developer.api.oclc.org/wcv2#/Bibliographic%20Resources/search-brief-bibs
q="kw:microfinance"
datePublished="1990-2010"
inLanguage="eng"
itemSubType="book-printbook"
preferredLanguage="eng"

```

## `holdings.sh`

This script uses the output of `brief-bibs.sh` as input. For each line in
`data/brief-bibs.csv`, `holdings.sh` fetches holding information for two sets of
libraries: those within 100 miles of San Franciso and those in the country of
France. The output of holdings.sh is the same as the input with the addition of two
new columns (holdings for San Francisco and France, respectively). The output is 
written to `data/holdings.csv`.