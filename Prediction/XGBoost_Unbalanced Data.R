#Gradient Boosting to predict whether a patient is readmitted or not
#Done on unbalanced data
library(caTools)
library(rpart)
library(rpart.plot)
library(dplyr)
library(caret)
library(class)
library(mlr)
library(e1071)
library(tree)
library(ISLR)
library(dplyr)
library(randomForest)
library(gbm)
library(caTools)
library(rpart)
library(rpart.plot)
library(dplyr)


df_readmission <- read.csv("cleaneddiabetesrev.csv")
df_readmission$X <- NULL

#Splitting the dataset into train and test
set.seed(1)
df_readmission$readmited <- as.factor(df_readmission$readmited)
splitrule <- sample(nrow(df_readmission),0.7*nrow(df_readmission))
train <- data.frame(df_readmission[splitrule,])
test <- data.frame(df_readmission[-splitrule,])


#Running the boosting code
boost.readmit<-gbm(readmited~.,data= train, distribution = "gaussian", n.trees=5000, interaction.depth = 4)
boost.readmit
test$yhat.boost=predict(boost.readmit,newdata=test,n.trees=5000,type="response")
pred_acc<-ifelse(test$yhat.boost>=1.5,1,0)
pred_acc<-as.factor(pred_acc)
levels(pred_acc)
(cm.boost<-confusionMatrix(pred_acc,test$readmited,positive = "1"))

