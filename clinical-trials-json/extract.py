
#!/usr/bin/env python
"""
Extract tabular data from clinical trials
"""

__author__ = "DREAM Lab"
__version__ = "0.1.0"
__license__ = "BSD-3"


import argparse
import json
import csv
from os import path
from typing import List, Any

def main(args: argparse.Namespace):
    """ extract all measurements from pimary measure as csv """
    
    with open(args.csv_out, 'w') as output:
        # set csv output column names
        csvOut = csv.DictWriter(output, fieldnames=[
                                            'nctId',
                                            'briefTitle',
                                            'unitOfMeasure',
                                            'comment',
                                            'groupId',
                                            'lowerLimit',
                                            'upperLimit',
                                            'value'
                                        ])
        csvOut.writeheader()
        with open(args.json_in,'r') as input:
            studies = json.load(input)
            for study in studies:
                id = nctId(study)
                title = briefTitle(study)
                for outcome in primaryOutcomeMeasures(study):
                    unit = getVal(outcome, 'unitOfMeasure')
                    for measure in allMeasurements(outcome):
                        csvOut.writerow({
                            'nctId':id,
                            'briefTitle': title,
                            'unitOfMeasure': unit,
                            'comment': getVal(measure,'comment'),
                            'groupId': getVal(measure,'groupId'),
                            'lowerLimit': getVal(measure,'lowerLimit'),
                            'upperLimit': getVal(measure,'upperLimit'),
                            'value': getVal(measure,'value')
                        }) 

def nctId(study) -> str:
     return study['protocolSection']['identificationModule']['nctId']

def briefTitle(study) -> str:
     return study['protocolSection']['identificationModule']['briefTitle']

def primaryOutcomeMeasures(study):
     for outcome in study['resultsSection']['outcomeMeasuresModule']['outcomeMeasures']:
        if outcome['type'] == 'PRIMARY':
            yield outcome

def allMeasurements(outcomeMeasure):
    try:
        for clas in outcomeMeasure['classes']:
            for cat in clas['categories']:
                for measure in cat['measurements']:
                    yield measure
    except KeyError:
        yield {}

def getVal(val, key: str):
    try:
        return val[key]
    except KeyError:
        return ""
    



if __name__ == "__main__":
    """ This is executed when run from the command line """
    parser = argparse.ArgumentParser()
    # parser.add_argument("-i", "--id", action="store", dest="id")
    parser.add_argument("json_in")
    parser.add_argument("csv_out")
    args = parser.parse_args()
    main(args)
