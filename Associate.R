setwd("C:/Users/USER/Desktop/Associate")


music <- read.table(file="music.csv", header=T, sep=",")
str(music)
#how much user
length(unique(music$user))
music$user <- as.factor(music$user)
nlevels(music$user)

install.packages('arules')
library(arules)
playlist01 <- lapply(split(x=music[,"artist"], f=music$user),sort)
#for differ user order same artist's song
rules01 <- apriori(playlist01, parameter=list(support=0.01, confidence=0.5))
#there's some repeat artist (need sort first or receive error)
playlist01[5290]

rules01
#looking for what kind of rule we just found
inspect(rules01)

playlist02 <- as(playlist01, "transactions")

playlist01[1]
playlist02[1]
inspect(playlist02[1])

itemFrequencyPlot(playlist01, support=0.08)
itemFrequencyPlot(playlist02, support=0.08)
itemFrequency(playlist02)

#check the most frequent item
itemFrequencyPlot(playlist02, support=0.08, topN=10)

rules02 <- apriori(playlist02, parameter=list(support=0.01, confidence=0.5))
inspect(rules02)
inspect(sort(subset(rules02, subset=lift > 5), by="confidence"))

#another dataset
cdr <- read.table("CDR.csv", header=T, sep=",", stringsAsFactors = T)
tour <- read.csv("Kaohsiung.csv", header = T, stringsAsFactors = F, encoding="BIG5")

length(unique(cdr$id))
length(unique(cdr$sz))

cdr_trans <- as(split(cdr$sz, cdr$id),'transactions')

rules <- apriori(cdr_trans, parameter=list(support=0.0003, confidence=0.5))
inspect(rules)

install.packages('arulesViz')
library(arulesViz)
plot(rules, method = 'graph')
#plot(rules, pch = 20, cex = 1.1)
