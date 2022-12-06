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
specified in the script. Run the script from the command line:

```sh
$ bash brief-bibs.sh
```

The query is configured through variables set in the script: 

```sh
# search params for brief-bibs.
# See: https://developer.api.oclc.org/wcv2#/Bibliographic%20Resources/search-brief-bibs
q="kw:microfinance"
datePublished="1990-2010"
inLanguage="eng"
itemSubType="book-printbook"
preferredLanguage="eng"
```

