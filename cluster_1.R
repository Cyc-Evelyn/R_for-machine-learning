setwd('C:/Users/USER/Desktop/cluster')
data <- read.csv("MaaS Data 02.csv", header=T)
#remove space*1,2,3
data[data == ""] <- NA
data[data== " "] <- NA
data[data== "  "] <- NA
names(data)

#check the missing value in important features
data <- data[,c(2, 3, 4, 5, 6, 7, 9)]
names(data)
num_na <- function(x){sum(is.na(x))}
sapply(data, num_na) #no missing value

#normalize
data_z <- as.data.frame(lapply(data, scale)) 

# kmeans
kmeans_3 <- kmeans(data_z, centers=3, nstart=25)

library(factoextra)
#fviz_cluster (use PCA of top2 features,)
#fviz_cluster(kmeans_3, geom = "point", data = data_z, xlab = "PC1", ylab = "PC2")+ggtitle("k = 3")
fviz_cluster(kmeans_3, geom = "point", data = data_z)

data$cluster3 <- kmeans_3$cluster
aggregate(data=data, cbind(District,CardType,Gender,Age,MRT_Month_Mileage,BusMonthTrips) ~ cluster3,mean)


# kmeans 
kmeans_2 <- kmeans(data_z, centers=2, nstart=25)

fviz_cluster(kmeans_2, geom = "point", data = data_z)

#use 2 cluster to analysis
data$cluster2 <- kmeans_2$cluster

#observe statistic differ
aggregate(data=data, cbind(District,CardType,Gender,Age,MRT_Month_Mileage,BusMonthTrips) ~ cluster2, mean, na.rm=TRUE)


#
write.csv(data2, file="cluster_results.csv")
