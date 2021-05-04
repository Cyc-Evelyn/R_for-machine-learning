setwd("C:/Users/USER/Desktop/Probabilities")

n <- nrow(iris)
index <- sample(1:n, size=0.7*n)
train <- iris[index,]
test <- iris[-index,]

library(class)
trainLabels <- train$Species
#DEL LABEL
knnTrain <- train[,-5]
knnTest <- test[,-5]
#class result
prediction <- knn(train=knnTrain, test=knnTest, cl=trainLabels, k=11)
t <- table(x = prediction, y = test$Species, dnn=c("預測","實際"))
knnAccuracy = sum(diag(t))/sum(t)
knnAccuracy
t

#SVM
library(e1071)
svmM <- svm(Species ~ ., data=train)
result <- predict(svmM, test)
t <- table(x = result, y = test$Species, dnn=c("預測","實際"))
SVMaccuracy <- sum(diag(t)) / sum(t)
SVMaccuracy

#BAYES
nbM <- naiveBayes(Species ~ ., data=train)
result <- predict(nbM, test)
t <- table(x = result, y = test$Species, dnn=c("預測","實際"))
nbAccuracy <- sum(diag(t)) / sum(t)
nbAccuracy
t

#use another dataset
library(MASS)
nbPima <- naiveBayes(type ~ ., data=Pima.tr)
result <- predict(nbPima, Pima.te)
t <- table(x=Pima.te$type, y=result, dnn=c("預測","實際"))

nbAccuracy <- sum(diag(t)) / sum(t)
nbAccuracy

#another dataset
blood <- read.csv("bloodtw.csv", header=T)
blood <- na.exclude(blood)
blood$March2007 <- as.factor(blood$March2007)
n <- nrow(blood)
index <- sample(1:n, size=0.8*n)
blood.train <- blood[index,]
blood.test <- blood[-index,]

nb.blood <- naiveBayes(March2007 ~ ., data=blood.train)
result <- predict(nb.blood, blood.test)
true <- blood.test$March2007
t <- table(x = result, y = true, dnn=c("預測","實際"))

Accuracy <- sum(diag(t)) / sum(t)
Accuracy
#didn't fit well
