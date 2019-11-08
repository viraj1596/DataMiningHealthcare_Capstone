
library('e1071')
library('SparseM')
library('tm')
library('dplyr')
library(ROAuth) 
library(stringr) 
library(ggplot2) 
library(twitteR) 
library(plyr) 
library(rtweet)
library(syuzhet)
library("wordcloud")

#api access key
reqURL <- "https://api.twitter.com/oauth/request_token"
accessURL <- "http://api.twitter.com/oauth/access_token"
authURL <- "http://api.twitter.com/oauth/authorize"
api_key <- ""
api_secret <- ""
access_token <- ""
access_token_secret <- ""
setup_twitter_oauth(api_key,api_secret,access_token,access_token_secret)

#loading diabetes tweets
diabetes_tweets = searchTwitter('#diabetes', n=10000,lang="en")
tweets.df <-twListToDF(diabetes_tweets)
#writing tweets to csv file
write.csv(tweets.df , file = "/diabetes_tweets.csv")

#reading tweets
diabet_tweets<-read.csv("diabetes_tweets.csv")
#diabetes_tweets = strip_retweets(diabetes_tweets)
#diabetes_t <- twListToDF(diabet_tweets)
diabetes_text<-diabet_tweets$text

#diabetes tweets to vector
diabetes_vector <- as.vector(diabetes_text)
diabetes_source <- VectorSource(diabetes_vector)
diabetes_corpus <- Corpus(diabetes_source)
inspect(diabetes_corpus)

#removing whitespace
diabetes_corpus <- tm_map(diabetes_corpus,content_transformer(stripWhitespace))
inspect(diabetes_corpus)
#converting lower space characters
diabetes_corpus <- tm_map(diabetes_corpus,content_transformer(tolower))
inspect(diabetes_corpus)
#removing stopwords
diabetes_corpus <- tm_map(diabetes_corpus, content_transformer(removeWords),stopwords("english"))
inspect(diabetes_corpus)
#removing punctuations
diabetes_corpus <- tm_map(diabetes_corpus, content_transformer(removePunctuation))
inspect(diabetes_corpus)


#removing numbers
diabetes_corpus <- tm_map(diabetes_corpus,content_transformer(removeNumbers))
inspect(diabetes_corpus)
#making a document term matrix from corpus for diabetes tweets
tdm <- TermDocumentMatrix(diabetes_corpus,
                          control = list(stripWhitespace = TRUE,
                                         tolower = TRUE,
                                         stopwords = TRUE,
                                         removePunctuation = TRUE,
                                         removeNumbers = TRUE))

#generate wordcloud for diabetes tweets
wordcloud(diabetes_corpus,min.freq = 10,colors=brewer.pal(8, "Dark2"),random.color = TRUE,max.words = 50)

#loading and writing insulin tweets to dataframe
#insulin_tweets = searchTwitter('insulin', n=10000, lang="en")
#tweets.df1 <-twListToDF(insulin_tweets)
#write.csv(tweets.df1 , file = "/Users/dhwanildharia/Desktop/Data Mining/insulin_tweets.csv")
#read insulin tweets from csv files
insulin_tweets<-read.csv("insulin_tweets.csv")
#insulin <- twListToDF(insulin_tweets)
insulin_text<-insulin_tweets$text

#converting insulin tweet text to a vector and corpus
insulin_vector <- as.vector(insulin_text)
insulin_source <- VectorSource(insulin_vector)
insulin_corpus <- Corpus(insulin_source)
inspect(insulin_corpus)
#stripping whitespaces
insuslin_corpus <- tm_map(insulin_corpus,content_transformer(stripWhitespace))
#converting all words to lowercase
insulin_corpus <- tm_map(insulin_corpus,content_transformer(tolower))
inspect(insulin_corpus)
#removing stopwords
insulin_corpus <- tm_map(insulin_corpus, content_transformer(removeWords),stopwords("english"))
inspect(insulin_corpus)
#removing punctuations
insulin_corpus <- tm_map(insulin_corpus, content_transformer(removePunctuation))

inspect(insulin_corpus)
insulin_corpus <- tm_map(insulin_corpus,content_transformer(removeNumbers))
inspect(insulin_corpus)
#tdm for insulin tweets
tdm <- TermDocumentMatrix(insulin_corpus,
                          control = list(stripWhitespace = TRUE,
                                         tolower = TRUE,
                                         stopwords = TRUE,
                                         removePunctuation = TRUE,
                                         removeNumbers = TRUE))
wordcloud(insulin_corpus,min.freq = 10,colors=brewer.pal(8, "Dark2"),random.color = TRUE,max.words = 50)
#terms for insulin and price
terms <- c('"insulin","price')
#query search term together
terms_search <- paste(terms, collapse = " AND ")
insulin_prices_tweets = searchTwitter(terms_search, n=2000, lang="en")
insulin_prices_tweets <- twListToDF(insulin_prices_tweets)
insulin_prices_text<-insulin_prices_tweets$text
#converting text tweets to vector
insulin_prices_vector <- as.vector(insulin_prices_text)
insulin_prices_source <- VectorSource(insulin_prices_vector)
insulin_prices_corpus <- Corpus(insulin_prices_source)
inspect(insulin_prices_corpus)
#removinf stopwords, converting to lower case etc
insulin_prices_corpus <- tm_map(insulin_prices_corpus,content_transformer(stripWhitespace))
insulin_prices_corpus <- tm_map(insulin_prices_corpus,content_transformer(tolower))
insulin_prices_corpus<- tm_map(insulin_prices_corpus, content_transformer(removeWords),stopwords("english"))

insulin_prices_corpus <- tm_map(insulin_prices_corpus, content_transformer(removePunctuation))

insulin_prices_corpus <- tm_map(insulin_prices_corpus,content_transformer(removeNumbers))
tdm <- TermDocumentMatrix(insulin_prices_corpus,
                          control = list(stripWhitespace = TRUE,
                                         tolower = TRUE,
                                         stopwords = TRUE,
                                         removePunctuation = TRUE,
                                         removeNumbers = TRUE))
#wordcloud for insulin prices
wordcloud(insulin_prices_corpus,min.freq = 10,colors=brewer.pal(8, "Dark2"),random.color = TRUE,max.words = 50)

#loading sentiment r
library(sentimentr)
library(ggplot2)
library(plotly)
#calculating sentiment scores of insulin prices tweets ss
jscores <- sentiment_by(insulin_prices_text)
hist(jscores$ave_sentiment,breaks = 23)
x <- list(title="Sentiment Score")
y <- list(title="Frequency of Tweets")
p <- plot_ly(x=jscores$ave_sentiment, type="histogram", marker = list(colors = c("red", "blue")))%>%layout(xaxis = x, yaxis = y)
p
qplot(jscores, geom="histogram") 
# str(jscores$ave_sentiment)


