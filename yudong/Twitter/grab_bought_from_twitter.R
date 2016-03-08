# 12/12/2015
# Based on: http://www.r-bloggers.com/twitter-sentiment-analysis-with-r/
# with updated authentication, and simplified data flow and data output
# put in a cron job and run daily at the end of the day


#connect all libraries
 library(twitteR)
 library(ROAuth)
 library(plyr)
 library(dplyr)
 library(stringr)
 library(ggplot2)

# what to search
 searchterm <- "bought" 

# ---- users: do not change below ----------
 searchdate <- format(Sys.time(), "%Y-%m-%d-%H") 
 #searchdate <- format(Sys.time(), "%Y-%m-%d") 
 #yesterday <- format(Sys.Date()-1, "%Y-%m-%d") 
 setwd("/media/Disk3T/Team/yudong/Twitter") 
 reqURL <- 'https://api.twitter.com/oauth/request_token'
 accessURL <- 'https://api.twitter.com/oauth/access_token'
 authURL <- 'https://api.twitter.com/oauth/authorize'
 #put the Consumer Key from Twitter Application
 consumerKey <- 'thd2KhXUX4i2RZWR1eNVJZslR'
 #put the Consumer Secret from Twitter Application
 consumerSecret <- 'kRFZuZNeUIVGKNzusOyFgPfKJLpq6l4ZR8GpppLlJxgZNRKDcX'
 access_token <- '2923086225-ItNFqBtNuI3PVsleJCoozukcwiBomypmtKikS0J'
 access_secret <- 'UpiTPF2FmyIfaxujcOnYjXQD3GGGzmeWgJ4FhDgvuohj8'

 options(httr_oauth_cache=F)
 setup_twitter_oauth(consumerKey, consumerSecret, access_token, access_secret)

 #list <- searchTwitter(searchterm, n=10000, lang='en', since=yesterday, until=searchdate)
 #list <- searchTwitter(searchterm, n=10000, lang='en') 
 # do US only
 list <- searchTwitter(searchterm, n=10000, lang='en', geocode='39.8,-95.58,2500km') 
 len = length(list) 
 df <- twListToDF(list)
 df <- df[, order(names(df))]
 df$created <- strftime(df$created, '%Y-%m-%d')

 #dir.create(searchterm) 
 write.csv(df, file=paste(searchterm, "/", paste(searchdate, 'text.csv', sep='_'), 
                     sep=''), row.names=F)

 

