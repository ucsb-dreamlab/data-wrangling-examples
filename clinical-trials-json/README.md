# Wrangling JSON from clinicaltrials.gov

This example illustrates how to exctract tabular data from json objects
downloaded from [clinicaltrials.gov](https://clinicaltrials.gov).

### Usage

The script requires two arguments: the input json file and the output csv file name:

```sh
python extract.py ctg-studies.json measures.csv
```

The dataset was downloaded with this query: 

https://clinicaltrials.gov/api/int/studies/download?format=json&cond=PTSD&aggFilters=results%3Awith%2Cstatus%3Acom
