# Classification Tree method to predict whether a diabetic patient is likely to be readmitted or nto
# The following code is implemented on balanced dataset

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

#Read cleaned dataset 
df_readmission <- read.csv("cleaneddiabetesrev.csv")

#Remove the index of the dataset
df_readmission$X <- NULL
set.seed(1)
#Convert the dependent variable readmitted into factor
df_readmission$readmited <- as.factor(df_readmission$readmited)

#Split the dataset into 70% training and 30% test data
splitrule <- sample(nrow(df_readmission),0.7*nrow(df_readmission))
train <- data.frame(df_readmission[splitrule,])
test <- data.frame(df_readmission[-splitrule,])

# To resolve class imbalance problem, performing under sampling
pos <- train[ which(train$readmited==1), ]
negative <- train[which(train$readmited==0),]
splitrule_pos <- sample(nrow(pos),nrow(pos))
splitrule_neg <- sample(nrow(negative),0.1294*nrow(negative))
train_pos <- data.frame(pos[splitrule_pos,])
train_neg <- data.frame(negative[splitrule_neg,])
df_final <- rbind(train_pos,train_neg)
df_final <- df_final[sample(nrow(df_final)),]

model=rpart(readmited~.,data=df_final,method="class",cp=0.01099)
summary(model)
rpart.plot(model,extra=104)
pred=predict(model,test,type="prob")
pred1=predict(model,test,type="class")
head(pred)
data_pred=cbind(test,pred)
head(data_pred)
mean(data_pred$`0`)
save(model,file="model.rda")
conf_class<-table(pred1,test$readmited)

confusionMatrix(pred1, test$readmited, positive="1")
