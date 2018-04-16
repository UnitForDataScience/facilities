Text Similarity Model:
1. Currently working on approx 43000 HVAC related issues from Topic modeling.
2. Preproceessing steps:
	- Join columns 'Action.Requested', 'General.Comments', 'Task.Comments' for each issue that forms all the textual data for any issue
	- Remove Punctuations
	- Tokenize into words
	- Lemmatize the words(currently not doing POS Tagging)
	- Stem the words to get root word(Using Porter Stemmer)
	- Un-tokenize the words back into sentence
3. Get TFIDF matrix for each sentence removing stop words(add 'nan' to stop word list)
4. Train a Word2Vec model from the stemmed sentences to get text embeddings
5. Use TFIDF weighted sum of word vectors to get issue vectors(sentence or document level embedding)
6. Save the issue vectors to 'issue_text_vector.pkl'


Cost Prediction Model:
1. Use 'issue_text_vector.pkl' generated from TextSimilarity.ipynb
2. Randomly split into 80:20 Train-Test datasets
3. Use NearestNeighbors model from Scikit Learn to train the model.
4. Predict 5 nearest neighbors using the Issue vectors for the testing data.
5. Ignore High price issues and run evaluation for issues costing < $500.
6. Get average cost from 5 similar issues as predicted cost.
7. Deviation from actual cost = 25%