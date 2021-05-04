library(rpart)
library(MASS)

names(Pima.tr)
set.seed(123456789)
# cp=0 means without penalty, not deal with overfitting(no cut branch)
Pima.tree <- rpart(type ~ ., data=Pima.tr, cp=0, minsplit=10)
plot(Pima.tree, margin=0.001)
text(Pima.tree, use.n=TRUE, cex=0.75)

plotcp(Pima.tree)
# see differ cp & error
results <- printcp(Pima.tree)

order(results[, 4])
#order & choose least error
min_position <- order(results[, 4])[1]
min_position
best_cp <- results[min_position, 1]
best_cp

tree.prune <- prune(Pima.tree, cp=best_cp)
plot(tree.prune, margin=0.1)
text(tree.prune, use.n=TRUE, cex=0.75)

Pima.predict <- predict(tree.prune, Pima.te, type="class")
compare <- table(true=Pima.te[,8], predict=Pima.predict)
compare
accuracy <- sum(diag(compare)) / sum(compare)
accuracy

#looking for crossvalidation set how to influence error &
library(tree)
#tmax <- tree(type ~ ., , data = Pima.tr)
tmax <- tree(type ~ ., data = Pima.tr)
plot(tmax)
text(tmax)

tcv <- cv.tree(tmax)
tcv

#looking for lowest error
err <- tcv$dev
order(err)
min_position <- order(err)[1]
min_position
best_k <- tcv$k[min_position]
best_k

#cut tree
tree.prune <- prune.tree(tmax, k=13.29368)
plot(tree.prune)
text(tree.prune)

result1 <- predict(tmax, Pima.te,type="class")
result2 <- predict(tree.prune, Pima.te, type="class")
t1 <- table(Pima.te$type, result1)
t2 <- table(Pima.te$type, result2)
t1
t2
accuracy1 <- sum(diag(t1)) / sum(t1)
accuracy2 <- sum(diag(t2)) / sum(t2)
accuracy1
accuracy2
