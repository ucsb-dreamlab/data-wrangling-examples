#!/usr/bin/env python
"""
Extract tabular data from clinical trials
"""

__author__ = "DREAM Lab"
__version__ = "0.2.0"
__license__ = "BSD-3"


import argparse
import json
import csv
from os import path
from typing import List, Any


def main(args: argparse.Namespace):
    """ extract all measurements from pimary measure as csv """
    
    # column names for output csv
    fieldnames = [
        'nctId', 'briefTitle', 'unitOfMeasure', 'comment', 
        'groupId', 'lowerLimit', 'upperLimit', 'value'
    ]

    with open(args.json_in,'r') as input, open(args.csv_out, 'w') as output:
        csv_out = csv.DictWriter(output, fieldnames=fieldnames)
        csv_out.writeheader()
        trials = json.load(input)
        for trial in trials:
            id = nct_id(trial)
            title = brief_title(trial)
            for outcome in primary_outcome_measures(trial):
                unit = outcome.get('unitOfMeasure','')
                for measure in all_measurements(outcome):
                    csv_out.writerow({
                        'nctId':id,
                        'briefTitle': title,
                        'unitOfMeasure': unit,
                        'comment': measure.get('comment',''),
                        'groupId': measure.get('groupId', ''),
                        'lowerLimit': measure.get('lowerLimit',''),
                        'upperLimit': measure.get('upperLimit',''),
                        'value': measure.get('value','')
                    }) 

def nct_id(study) -> str:
     return study['protocolSection']['identificationModule']['nctId']

def brief_title(study) -> str:
     return study['protocolSection']['identificationModule']['briefTitle']

def primary_outcome_measures(study):
    return [
        outcome for outcome in study['resultsSection']['outcomeMeasuresModule']['outcomeMeasures']
        if outcome.get('type') == 'PRIMARY'
    ]

def all_measurements(outcome_measure):
    try:
        return [
            measure for clas in outcome_measure.get('classes', [])
            for cat in clas.get('categories', [])
            for measure in cat.get('measurements', [])
        ]
    except KeyError:
        return []

 
if __name__ == "__main__":
    """ This is executed when run from the command line """
    parser = argparse.ArgumentParser()
    # parser.add_argument("-i", "--id", action="store", dest="id")
    parser.add_argument("json_in")
    parser.add_argument("csv_out")
    args = parser.parse_args()
    main(args)
