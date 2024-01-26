
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


def main(args):
    """ Main entry point of the app """
    json.load()


if __name__ == "__main__":
    """ This is executed when run from the command line """
    parser = argparse.ArgumentParser()
    # parser.add_argument("-i", "--id", action="store", dest="id")
    args = parser.parse_args()
    main(args)
