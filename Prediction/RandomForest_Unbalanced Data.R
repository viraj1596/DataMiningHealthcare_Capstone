#Random Forest to predict whether a patient will be readmitted to the hopsital or not

# The following code is implemented on an unbalanced dataset

#Library caret has been used to create confusion matrix and get performance measures of the model
library(caret)
library(randomForest)

#Read cleaned dataset
df_readmission <- read.csv("cleaneddiabetesrev.csv")
#Remove index number from the dataset 
df_readmission$X <- NULL
set.seed(1)

#Convert the dependent variable readmitted into factor
df_readmission$readmited <- as.factor(df_readmission$readmited)
#Split the dataset into 90% training and 10% test data
splitrule <- sample(nrow(df_readmission),0.9*nrow(df_readmission))
df_final <- data.frame(df_readmission[splitrule,])
test <- data.frame(df_readmission[-splitrule,])
attach(df_final)

#Creating random forest model 
forest.readmit<-randomForest(readmited~.,data = df_final , mtry = sqrt(143), importance = TRUE)
forest.readmit
test$yhat.forest<-predict(forest.readmit,newdata = test)
forest.test<-test$readmited
(confusionmatrix_RF=table(forest.test,test$yhat.forest))
(accuracy_RF = (confusionmatrix_RF[1,1]+confusionmatrix_RF[2,2])/sum(confusionmatrix_RF))
importance(forest.readmit)
varImpPlot(forest.readmit)
#Profitability of Random Forest
test$forest_readmit<-ifelse(test$yhat.forest=="1",test$readmited,0)
(sum(test$forest_readmit))

confusionMatrix(test$yhat.forest,forest.test, positive = "1")
