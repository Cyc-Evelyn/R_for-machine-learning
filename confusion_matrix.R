setwd("C:/Users/USER/Desktop/how to rate model")
bc <- read.table("wdbc.txt", header=T, sep=",")

num_na <- function(x){sum(is.na(x))}
bc <- na.exclude(bc)
num_na(bc)

#WE DON'T NEED ID,so remove it
bc <- bc[,-1]
class(bc$diagnosis)
#encode diagnosis
bc$diagnosis <- as.factor(bc$diagnosis)

#train test
n <- 0.3*nrow(bc)
test.index <- sample(1:nrow(bc), n)
bc.train <- bc[-test.index,]
bc.test <- bc[test.index,]

#use tree to classify
library(tree)
bc.tree <- tree(diagnosis ~ ., bc.train)

true <- bc.test$diagnosis
pred <- predict(bc.tree, bc.test, type='class')
pred.table <- table(pred, true)
pred.table

#performance
total <- nrow(bc.test)
total
num.correct <- sum(diag(pred.table))
num.correct
accuracy <- num.correct / total
accuracy

TP <- pred.table[2,2]
FP <- pred.table[2,1]
TN <- pred.table[1,1]
FN <- pred.table[1,2]
TPR <- TP / (TP+FN)
Precision <- TP / (TP+FP)

TP
FP
TN
FN
TP
Precision

pred.prob <- pred.table / total
pred.prob

