setwd("C:/Users/USER/Desktop/Visualize_performance")
data <- read.csv("Titanic2.csv", header=T)

n <- 0.2 * nrow(data)
index <- sample(1:nrow(data), n)
train <- data[-index,]
test <- data[index,]

#Predict survived or not
model <- glm(Survived ~ ., family=binomial(link='logit'),data=train)

guess <- predict(model, test, type="response")
label <- test$Survived

#try to plot ROC curve
install.packages("ROCR")
library(ROCR)
pred <- prediction(guess, label)
perf <- performance(pred,"tpr","fpr")
plot(perf)

############  pROC : DIFFER PLOT PACKAGES #############

install.packages('pROC')
library(pROC)

#pROC_obj <- roc(df$labels,df$predictions,
#                smoothed = TRUE,
#                # arguments for ci
#                ci=TRUE, ci.alpha=0.9, stratified=FALSE,
#                # arguments for plot
#                plot=TRUE, auc.polygon=TRUE, max.auc.polygon=TRUE, grid=TRUE,
#                print.auc=TRUE, show.thres=TRUE)

pROC_obj <- roc(label, guess, plot=TRUE, auc.polygon=TRUE, max.auc.polygon=TRUE, print.auc=TRUE)


#sens.ci <- ci.se(pROC_obj)
#plot(sens.ci, type="shape", col="lightblue")
## Warning in plot.ci.se(sens.ci, type = "shape", col = "lightblue"): Low
## definition shape.
#plot(sens.ci, type="bars")
