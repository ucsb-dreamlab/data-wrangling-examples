#!/bin/env python3
from pathlib import Path
import regex
from nltk.corpus import stopwords
from nltk.corpus import words
from nltk.tokenize import word_tokenize

# word sets to filter on
stopWords = set(stopwords.words('english'))
engWords = set(words.words())

# Loop over every .txt file in the 'data' directory. For each file, combine
# words split with hyphenated line endings, convert to lower case, filter out
# stopwords and words not in the NLTK list of English words. Save output to the
# 'output' directory using the same filename as the input.
for p in Path('data').glob('*.txt'):

    # print a status message as we work on each file 
    print("cleaning: ", p.name)

    # path to 'output' file where clean data is written
    out = Path('output') / p.name

    # read the contents of data file into variable 'text'
    text = p.read_text(encoding="utf-8")

    # join lines ending with a hyphen: "word- "
    text = regex.sub(r'(\w)-\s\n',r'\1', text)

    # tokenize
    tokens = word_tokenize(text.lower())

    # lowercase tokens with stop words removed
    tokens = list(filter(lambda t: t not in stopWords, tokens))

    # only tokens in english word list
    tokens = list(filter(lambda t: t in engWords, tokens))

    # write tokens to file in 'output'
    out.write_text(" ".join(tokens))
    