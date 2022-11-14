#!/bin/env python3
from pathlib import Path
import regex
from nltk.corpus import stopwords
from nltk.tokenize import word_tokenize

# regular expression matching tokens with characters a-z
wordMatch = regex.compile(r'^[a-z]+$')

# list of english stop words (to remove)
stopWords = set(stopwords.words('english'))

# loop over every .txt file in the 'data' directory
for p in Path('data').glob('*.txt'):

    # print a status message as we work on each file 
    print("cleaning: ", p.name)

    # path to 'output' file where clean data is written
    out = Path('output') / p.name

    # read the contents of data file into variable 'text'
    text = p.read_text()

    # join lines ending with a hyphen: "word- "
    text = regex.sub(r'(\w)-\s\n',r'\1', text)

    # lowercase tokens with stop words removed
    tokens = list(filter(lambda t: t not in stopWords, word_tokenize(text.lower())))

    # only tokens that match wordMatch regexp
    tokens = list(filter(lambda t: wordMatch.match(t), tokens))

    # write tokens to file in 'output'
    out.write_text(" ".join(tokens))
    