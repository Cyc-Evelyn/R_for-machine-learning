install.packages('e1071')
install.packages('mlbench')
library(e1071)
library(mlbench)

data(HouseVotes84)

n <- 0.1*nrow(HouseVotes84)
index <- sample(1:nrow(HouseVotes84), n)
train <- HouseVotes84[-index,]
test <- HouseVotes84[index,]

bayes_model <- naiveBayes(Class ~ ., data = train)
predict(bayes_model, test[1:5,])
predict(bayes_model, test[1:5,], type = "raw")#output probabilities
pred <- predict(bayes_model, test)
table(pred, test$Class)

bayes_model_laplace <- naiveBayes(Class ~ ., data = HouseVotes84, laplace = 3)

bayes_iris <- naiveBayes(Species ~ ., data = iris)
iris_pred <- predict(bayes_iris,iris, type="raw")
table(iris_pred,iris$Species)

#some note:
#if continuous data=>use distribution and standard dev as clue to do bayes
