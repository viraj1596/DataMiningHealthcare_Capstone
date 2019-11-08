#KNN to predict whether a patient is likely to be readmitted or not
library(caret)
library(mice)
library(stats)
library(knitr)
library(dplyr)
library(corrplot)
library(naniar)
library(dummies)
library(e1071)
library(class)
library(tidyverse)

# Read in CSV with data
df_readmission <- read.csv("cleaneddiabetesrev.csv")
df_readmission$X <- NULL
set.seed(1)
df_readmission$readmited <- as.factor(df_readmission$readmited)

#Standardization
fun <- function(x){ 
  a <- mean(x, na.rm = TRUE) 
  b <- sd(x) 
  (x - a)/(b) 
}

df_readmission[1:143] <- apply(df_readmission[1:143], 2, fun)

#Partitioning the data
set.seed(12345)
splitrule <- sample(nrow(df_readmission),0.7*nrow(df_readmission))
df_train <- data.frame(df_readmission[splitrule,])
test <- data.frame(df_readmission[-splitrule,])

splitrule2 <- sample(nrow(test),0.5*nrow(test))
df_test <- data.frame(test[splitrule2,])
df_validation <- data.frame(test[-splitrule2,])

#knn
train_input     <- as.matrix(df_train[,-144])
train_output    <- as.vector(df_train[,144])
validate_input  <- as.matrix(df_validation[,-144])
test_input      <- as.matrix(df_test[,-144])

kmax <- 15
ER1 <- rep(0,kmax)
ER2 <- rep(0,kmax)

for (i in 1:kmax){
  prediction <-  knn(train_input, train_input,train_output, k=i)
  prediction2 <- knn(train_input, validate_input,train_output, k=i)
  
  CM1 <- table(prediction, df_train$readmited)
  ER1[i] <- (CM1[1,2]+CM1[2,1])/sum(CM1)
  CM2 <- table(prediction2, df_validation$readmited)
  ER2[i] <- (CM2[1,2]+CM2[2,1])/sum(CM2)
}

#Plot
plot(c(1,kmax),c(0,50),type="n", xlab="k",ylab="Error Rate")
lines(ER1*100,col="red")
lines(ER2*100,col="blue")
legend(10, 15, c("Training","Validation"),lty=c(1,1), col=c("red","blue"))
z <- which.min(ER2)
cat("Minimum Validation Error k:", z)
(x <- min(ER2))

#Scoring at optimal k
prediction  <- knn(train_input, train_input,train_output, k=z)
prediction2 <- knn(train_input, validate_input,train_output, k=z)

#Error rate and Confusion Matrix
CM1 <- table(prediction, dftrain$profit)
CM2 <- table(prediction2, dfvalidation$profit)

#Scoring at optimal k for test datasets
prediction  <- knn(train_input, train_input,train_output, k=z)
prediction2 <- knn(train_input, test_input,train_output, k=z)

confusionMatrix( prediction2, df_test$readmited)






