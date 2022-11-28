# Cleaning text files using python and NLTK

This is an example of how to use python and the NLTK package to clean text files
for further processing. The script, `cleanup.py`, loops over every .txt file in
the 'data' directory. For each input file, it combines words split with
hyphenated line endings, converts to lower case, and filters out stopwords and
words not in the NLTK list of English words. Output is saved to the 'output'
directory using the same filename as the input.

```
├── README.md
├── cleanup.py
├── data
│   ├── data1.txt
│   ├── data2.txt
│   └── ...
│ 
└── output
    ├── data1.txt
    ├── data2.txt
    └── ...
```

# Setup

- Beforing running the `cleanup.py` script, you should install NLTK and download
necessary data. See instructions on the [NLTK
website](https://www.nltk.org/install.html).
 
- Place `.txt` files to process in the `data` directory. These files should not
  be modified during cleaning.

# Usage

From the command line, run the `cleanup.py` script:

```sh
python cleanup.py
```