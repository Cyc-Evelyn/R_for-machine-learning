setwd("C:/Users/USER/Desktop/cluster")

teens <- read.csv(file = "snsdata.csv", header=T)
str(teens) 

#min max has large distance
#a lot of missing value
summary(teens$age)
summary(teens$gradyear)

#discard too big or too small value
teens$age <- ifelse(teens$age >= 13 & teens$age <= 20, teens$age, NA)
summary(teens$age)                      

#looking for differ grade of avg age               
ave_age <- aggregate(data=teens, age ~ gradyear, mean, na.rm=TRUE)     
class(ave_age)
ave_age

#head(teens$age)
#head(is.na(teens$age))
#head(teens$gradyear == 2006)
#head(is.na(teens$age) &  teens$gradyear==2006)

#fill in missing value with avg age in differ grade
teens$age <- ifelse(is.na(teens$age) & teens$gradyear==2006, ave_age$age[1], teens$age)
teens$age <- ifelse(is.na(teens$age) & teens$gradyear==2007, ave_age$age[2], teens$age)
teens$age <- ifelse(is.na(teens$age) & teens$gradyear==2008, ave_age$age[3], teens$age)
teens$age <- ifelse(is.na(teens$age) & teens$gradyear==2009, ave_age$age[4], teens$age)
summary(teens$age)

#looking for is there any missing value
num_na <- function(x){
  sum(is.na(x))
}


num_na(teens$gender)

#remove missing gender data(can't fill)
teens <- teens[!is.na(teens$gender),]
num_na(teens$gender)

#encode categorical data
teens$gender <- ifelse(teens$gender == "F", 1, 0)

interests <- teens[,5:40]
head(interests)

interests_z <- sapply(interests, scale)
head(interests_z)

#clustering
kc <- kmeans(interests_z, iter.max = 30, centers=5, nstart=10)
names(kc)

kc$cluster[1:10]
kc$size
teens$cluster <- kc$cluster
teens[1:3, c("cluster","gender","age","friends")]

#statistic for each group
aggregate(data=teens, age ~ cluster, mean, na.rm=TRUE)
aggregate(data=teens, friends ~ cluster, mean, na.rm=TRUE)
aggregate(data=teens, gender ~ cluster, mean, na.rm=TRUE)

install.packages('fpc')
library(fpc)

#DBSCAN
part <- interests[1:100,]
dc <- dbscan(interests_z, 2.0, MinPts=10)
#dc <- dbscan(part, 0.5, MinPts=100)
names(dc)
dc
#too much compute to my laptop ...

#compare 
kc <- kmeans(interests_z, iter.max = 30, centers=2, nstart=10)
diff <- ifelse(kc$cluster == dc$cluster, 1, 0)
sum(diff)
sum(diff) / length(kc$cluster)
