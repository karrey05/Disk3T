# 3/8/2016 
# Aggregate hourly grabs of tweets with "bought" in them, 
# and produce a wordcloud. 

#connect all libraries
 library(tm) 
 library(wordcloud)
 library(plyr)
 library(dplyr)
 library(stringr)
 library(ggplot2)

 setwd("/home/yudong/data/Twitter") 
 # consolidate hourly file 
 imgfile <- format(Sys.time(), "bought/%Y-%m-%d.png")
 dailyptn <- format(Sys.time(), "^%Y-%m-%d-[0-9][0-9]_text.csv")
 files=list.files("bought/", pattern=dailyptn) 

 alltext = data.frame(); 

 for (i in 1:length(files) ) {
   cat("doing ", files[i], "\n")
   df <- read.csv(paste("bought/", files[i], sep='')) 

   df$text <- as.factor(df$text)

   # clean up 
   clean_text <- laply(df$text, function(some_txt){
    some_txt = gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", some_txt)
    some_txt = gsub("@\\w+", "", some_txt)
    some_txt = gsub("[[:punct:]]", "", some_txt)
    some_txt = gsub("[[:digit:]]", "", some_txt)
    some_txt = gsub("http\\w+", "", some_txt)
    some_txt = gsub("[ \t]{2,}", "", some_txt)
    some_txt = gsub("^\\s+|\\s+$", "", some_txt)
    some_txt = gsub("amp", "", some_txt)
    some_txt = gsub("tickets", "ticket", some_txt)
    some_txt <- tolower(iconv(some_txt, "ASCII", "UTF-8", sub=""))
    names(some_txt) = NULL
    return(some_txt) 
   } ) 

   c1=removeWords(clean_text, stopwords("english"))
   c2=removeWords(c1, c("bought", "today", "just", "yesterday", "can", "home", 
                      "store", "last", "now", "back", "dont", "get", "trump", 
                      "time", "feel", "day", "went", "got", "spreading", "like", 
                      "new", "love", "first", "one", "great", "ago", "good", 
                      "look", "cant", "cool", "buy", "two", "another", "really", 
                      "week", "night", "happy", "said", "money", "year", "thank", 
                      "wanted", "place", "made", "know", "people", "think", 
                      "well", "finally", "todaysign", "somecardsfeel", 
                      "yet", "say", "amazing", "free", "paid", "thing", "didnt",
                      "gonna", "want", "couldnt", "even", "morning", "wait",
                      "excited", "dad", "mom", "ive", "going", "lol", 
                      "havent", "ever", "awesome", "still", "right", "will", 
                      "never", "already", "come", "always", "little", "sure", 
                      "many", "since", "purchase", "trying", "instead", "tonight", 
                      "yeah", "yes", "real", "something", "city", "way", 
                      "much", "keep", "much", "focus", "stop", "big", "best", 
                      "facts", "entire", "everyone", "take", "youre", "glad", 
                      "also", "shop", "bad", "shit", "favorite", "give", "looking", 
                      "cuz", "came", "thanks", "better", "super", "bring", "make", 
                      "help", "high", "nice", "month", "see", "tell", "definitely", 
                      "please", "hey", "pretty", "dollar", "find", "ill", "cute",
                      "fucking", "everything", "may", "worth", "getting", "hope", 
                      "tho", "cause", "guess", "believe", "less", "fucked", "mad",
                      "must", "pissed", "nobody", "forget", "doesnt", "sayin", 
                      "says", "spent", "true", "asked", "coming", "sold", "thought", 
                      "someone", "need", "remember", "caign", "candidates", "selffunding", 
                      "feels", "hes", "else", "wont", "thats", "fact", "htt", 
                      "isnt", "play", "check", "break", "lot", "looks", "later", 
                      "talk", "actually", "every", "almost", "whole", "show", 
                      "weve", "gave", "saw", "extra", "late", "hillaryboughtandsold",
                      "read", "cruz", "refuting", "years", "loved", "set", "yall", 
                      "special", "told", "narrative" 
                       ) ) 

 alltext = c(alltext, c2) 

 } # ene of for 

 corpus = Corpus(VectorSource(alltext))
 tdm = TermDocumentMatrix(corpus)
 tdm = as.matrix(tdm)

 # define tdm as matrix
 m = as.matrix(tdm)
 # get word counts in decreasing order
 word_freqs = sort(rowSums(m), decreasing=TRUE) 
 # create a data frame with words and their frequencies
 dm = data.frame(word=names(word_freqs), freq=word_freqs)
 
 # plot wordcloud
# wordcloud(dm$word, dm$freq, min.freq=80, max.words=100, random.order=FALSE, colors=brewer.pal(8, "Dark2"))

 # save the image in png format
 png(imgfile, width=800, height=800, res=200)
 wordcloud(dm$word, dm$freq, min.freq=40, max.words=100, random.order=FALSE, colors=brewer.pal(8, "Dark2"))
 dev.off()

