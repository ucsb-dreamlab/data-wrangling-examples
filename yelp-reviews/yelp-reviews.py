#!/usr/bin/env python3
"""
Yelp Review Extract
"""

__author__ = "DREAM Lab"
__version__ = "0.1.0"
__license__ = "BSD-3"



import argparse
import json
from os import path

datadir = "yelp_dataset"
businessJson = path.join(datadir, "yelp_academic_dataset_business.json")
reviewsJson = path.join(datadir, "yelp_academic_dataset_review.json")

def main(args):
    """ Main entry point of the app """
    if args.id:
        print_reviews(reviewsJson, args.id)
    else:
        print_ids(businessJson)


def print_ids(name):
    with open(name,'r') as f:
        for l in f:
            biz = json.loads(l)
            print(biz["name"] +", "+ biz["business_id"])

def print_reviews(name, id):
    with open(name,'r') as f:
        for l in f:
            review = json.loads(l)
            if review["business_id"] == id:
                print(review)


if __name__ == "__main__":
    """ This is executed when run from the command line """
    parser = argparse.ArgumentParser()
    parser.add_argument("-i", "--id", action="store", dest="id")


    args = parser.parse_args()
    main(args)