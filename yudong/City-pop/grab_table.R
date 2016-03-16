
library(XML)
library(RCurl)
xData = getURL("https://en.wikipedia.org/wiki/List_of_United_States_cities_by_population")
tables= readHTMLTable(xData, encoding="UTF-8")
length(tables)
# tables is a list. the fourth one is what we need 

t4=tables[[4]]
city=t4["City"]
pop=t4["2014 estimate"]

write.csv(t4, "US-cities.csv")  

# > class(t4$City)
# [1] "factor"
# > class(t4["City"])
# [1] "data.frame"
# > class(t4[["City"]])
# [1] "factor"
# > class(t4)
# [1] "data.frame"
# > names(t4)
# [1] "2014 rank"               "City"
# [3] "State[5]"                "2014 estimate"
# [5] "2010 Census"             "Change"
# [7] "2014 land area"          "2010 population density"
# [9] "Location"
# > class(t4[, 2])
# [1] "factor"
# > class(t4[, "City"])
# [1] "factor"
# 
