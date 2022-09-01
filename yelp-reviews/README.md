# Yelp Reviews

Yelp provides an open dataset for academic use. You can download it [here](https://www.yelp.com/dataset/download). In this example, python is used to print the business names and IDs in the open dataset, and to extract reviews for a business using its ID.

Thes example assumes the data has been downloaded, uncompressed, and saved in a directory called `yelp_dataset`. You should have the following files

```
.
├── README.md
├── csv_export
│   └── ...
├── yelp-reviews.py
└── yelp_dataset
    ├── Dataset_User_Agreement.pdf
    ├── yelp_academic_dataset_business.json
    ├── yelp_academic_dataset_checkin.json
    ├── yelp_academic_dataset_review.json
    ├── yelp_academic_dataset_tip.json
    └── yelp_academic_dataset_user.json
```

# Usage

The example python script can be run from the command line.

```sh
# this will print all the business names and IDs -- all 150 thousand!
python yelp-reviews.py

# you can page through the results at your leisure with 'more'
python yelp-reviews.py | more

# or filter with grep
python yelp-reviews.py | grep "Spa" | more

# export reviews as csv, saved in csv_export directory
python yelp-reviews.py --id ytFuMCUQXUSWuvpZMP1uEA
```