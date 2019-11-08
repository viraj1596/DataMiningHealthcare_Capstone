#Logistic Regression to predict whether a patient will be readmitted to the hopsital or not

# The following code is implemented on an unbalanced dataset

#Library caret has been used to create confusion matrix and get performance measures of the model
library(caret)

#Read cleaned dataset
df_readmission <- read.csv("cleaneddiabetesrev.csv")
#Remove index number from the dataset 
df_readmission$X <- NULL
set.seed(1)

#Convert the dependent variable readmitted into factor
df_readmission$readmited <- as.factor(df_readmission$readmited)

#Split the dataset into 70% training and 30% test data
splitrule <- sample(nrow(df_readmission),0.7*nrow(df_readmission))
df_final <- data.frame(df_readmission[splitrule,])
test <- data.frame(df_readmission[-splitrule,])


attach(df_final)

#Run logistic regression on train dataset
logisticModel <- glm(readmited~.,data=df_final,family="binomial",control = list(maxit = 50))
summary(logisticModel)
predictedlog <- predict(logisticModel, newdata=test, type="response")

#If the cutoff is greater than 0.5 then the patient is likely to get readmitted to the hospital
predicted_log <- ifelse(predictedlog>0.5,1,0)
predicted_log <- as.factor(predicted_log)

#Get the performance measures of the logistic model
confusionMatrix(predicted_log,test$readmited, positive="1")



