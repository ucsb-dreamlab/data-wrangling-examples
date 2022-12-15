# WorldCat Search API with cURL and jq

This example includes bash scripts that use `curl` and `jq` to download and process
bibliographic data from OCLC's [WorldCat Search
API](https://developer.api.oclc.org/wcv2). OCLC's API is not publicly
accessible, so you will need an API key to use the scripts.

## Setup

The bash scripts use `curl` and `jq`. These programs should be installed and
accessible on your PATH. In addition, you should set two environment variables
with your OCLC API id and secret:

```sh
export OCLC_ID="...YOUR API ID..."
export OCLC_SECRET="...YOUR API Secret..."
```

## Usage

Scripts are describe below. They should be run in the order described.

### `bibs.sh`

This scripts uses OCLC's `search-bibs` API to download book data based on
criteria specified in the script. The results are downloaded to `data/bib/` as
per-resource json files (e.g., `data/bibs/1001251007.json`). Run the script from
the command line:

```sh
# writes data to data/brief-bibs.csv
$ bash bibs.sh
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

### `holdings.sh`

This script fetches holding information for each resource (json file) in
`data/bibs` (downloaded by `bibs.sh`) . The output is written to
`data/holdings.csv`. It includes two columns: an OCLC number and a holding
count.  Run the script from the command line:

```sh
# this will take a long time if you have a lot of json files in data/bibs
$ bash holdings.sh
```


### `extract.sh`

This script generates two csv files, `data/bibs.csv` and `data/authors.csv` from
the json files in `data/bibs` and the csv, `data/holdings.csv`. 

```sh
$ bash holdings.sh
```

#### `data/bibs.csv`

Each row in the spreadsheet represents a unique OCLC resource with a unique
“oclcNumber”. Additionally, for each record, there is a “holdings” count using
the OCLC holdings API. Only the first author’s name information is included
here. Additional author names are included in the “authors” spreadsheet,
described below.

Columns:
- oclcNumber: the OCLC record number (unique for each row)
- mainTitle: The book title
- firstName: first author’s first name
- secondName: first author’s second name
- nonPersonName: if the first author is not a person, the name of the “non-person” first author is here.
- creatorType: the “type” of the first author (person or corporation).
- isPrimary: whether the first author is primary
- publisherName: publisher of the book
- publicationPlace: where the book was published
- machineReadableDate: machine readable publication date
- itemLanguage: primary language of book
- physicalDescription: physical description of the book
- Holdings: holdings count for the book, from holdings API

#### `data/authors.csv`

Each resource is repeated multiple times for each author. 

Columns:
- oclcNumber: oclcNumber (not unique for each row)
- mainTitle: Book title
- firstName: name of book author
- secondName: second name of book author:
- nonPersonName:for non-person authors (corporations)
- creatorType: creator type (person or corporation).
- isPrimary: whether the author is a primary author of the book
- creatorPosition: the position of the authors name on the list of authors.
