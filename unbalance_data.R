setwd("C:/Users/USER/Desktop/how to rate model")
data <- read.csv("Mass Data 03.csv", header=T, sep=",")
names(data)
#only select important features
data <- data[c(2,3,4,5)]

data_original <- data
#encode Package
data$Package <- ifelse(data$Package == 'A', 1, data$Package)
data$Package <- ifelse(data$Package == 'B', 2, data$Package)
data$Package <- ifelse(data$Package == 'C', 3, data$Package)
data$Package <- ifelse(data$Package == 'L', 4, data$Package)
data$Package <- as.numeric(data$Package)

table(data$Package) #most of the data are class '1'

dataA <- data[data$Package == 1,]
dataB <- data[data$Package == 2,]
dataC <- data[data$Package == 3,]
dataL <- data[data$Package == 4,]

#use smote to balance data
install.packages('smotefamily')
library(smotefamily)

#first balance class A,B('1'&'2')
dataAB <- rbind(dataA, dataB)
balanced <- SMOTE(dataAB, dataAB$Package, dup_size = 10)
names(balanced)
balanced <- balanced$data

#THERE'S A NEW COLUMN 'CLASS' ,SAME AS Package ,SO REMOVE
names(balanced)

balanced <- balanced[,-5]
#CHECK BEFORE AFTER BALANCE
table(dataAB$Package)
table(balanced$Package)

#replace class 2 with balanced data
dataB <- balanced[balanced$Package == 2,]

#each other class use same method
dataAC <- rbind(dataA, dataC)
table(dataAC$Package)
balanced <- SMOTE(dataAC, dataAC$Package, dup_size = 10)
balanced <- balanced$data
names(balanced)
balanced <- balanced[,-5]
table(balanced$Package)

dataC <- balanced[balanced$Package == 3,]


dataAL <- rbind(dataA, dataL)
table(dataAL$Package)
balanced <- SMOTE(dataAL, dataAL$Package, dup_size = 10)
balanced <- balanced$data
names(balanced)
balanced <- balanced[,-5]
table(balanced$Package)

dataL <- balanced[balanced$Package == 4,]

#combine balanced data
balanced <- rbind(dataA, dataB, dataC, dataL)
#return into the original class
balanced$Package <- ifelse(balanced$Package == 1, 'A', balanced$Package)
balanced$Package <- ifelse(balanced$Package == 2, 'B', balanced$Package)
balanced$Package <- ifelse(balanced$Package == 3, 'C', balanced$Package)
balanced$Package <- ifelse(balanced$Package == 4, 'L', balanced$Package)
balanced$Package <- as.factor(balanced$Package)

data <- data_original
data$Package <- as.factor(data$Package)

table(data$Package)
table(balanced$Package)
write.csv(balanced, file="balanced.csv")
