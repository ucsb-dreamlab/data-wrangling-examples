#!/usr/bin/env python3
"""
Yelp Review Extract
"""

__author__ = "DREAM Lab"
__version__ = "0.1.0"
__license__ = "BSD-3"



import argparse
import json
import csv
from os import path


datadir = "yelp_dataset"
csvexport = "csv_export"
businessJson = path.join(datadir, "yelp_academic_dataset_business.json")
reviewsJson = path.join(datadir, "yelp_academic_dataset_review.json")

def main(args):
    """ Main entry point of the app """
    if args.id:
        export_reviews(reviewsJson, args.id)
    else:
        print_ids(businessJson)


def print_ids(name):
    with open(name,'r') as f:
        for l in f:
            biz = json.loads(l)
            print(biz["business_id"], biz["name"])

def export_reviews(name, id):
    reviews = []
    csvFile = path.join(csvexport, "reviews-" + id + ".csv")
    with open(name,'r') as f:
        for l in f:
            review = json.loads(l)
            if review["business_id"] == id:
                # remove newlines from review text (disabled)
                # review["text"] = review["text"].replace("\n","\\n")
                reviews.append(review)
    if len(reviews) == 0:
        return
    with open(csvFile,"w") as w:
        fieldnames = reviews[0].keys()
        writer = csv.DictWriter(w, fieldnames=fieldnames)
        writer.writeheader()
        for r in reviews:
            writer.writerow(r)


if __name__ == "__main__":
    """ This is executed when run from the command line """
    parser = argparse.ArgumentParser()
    parser.add_argument("-i", "--id", action="store", dest="id")
    args = parser.parse_args()
    main(args)