#Naive Bayes to predict whether a patient will be readmitted to the hopsital or not
# The following code is implemented on unbalanced dataset
library(magrittr)
library(Metrics)
library(plotly)
library(corrplot)
library(PerformanceAnalytics)
library(Hmisc)
library(knitr)
library(mctest)
library(caret)
library(pROC)
library(ggplot2)
library(klaR)
library(e1071)
df <- read.csv("Clean Data_DiabeticPatients_NaiveBayes.csv")

df[,1] <- NULL
df[,2]<-NULL
df$readmitted<-ifelse(df$readmitted == "<30","1","0")
df$readmitted<-as.factor(df$readmitted)

#Split the data into 70% training and 30% test data
splitrule <- sample(nrow(df),0.7*nrow(df))
train <- data.frame(df[splitrule,])
test <- data.frame(df[-splitrule,])

#Undersampling done to balance the dataset 
pos <- train[ which(train$readmitted=="1"), ]
negative <- train[which(train$readmitted=="0"),]
splitrule_pos <- sample(nrow(pos),nrow(pos))
splitrule_neg <- sample(nrow(negative),0.1294*nrow(negative))
train_pos <- data.frame(pos[splitrule_pos,])
train_neg <- data.frame(negative[splitrule_neg,])
df_final <- rbind(train_pos,train_neg)
df_final <- df_final[sample(nrow(df_final)),]
model_nb<-naiveBayes(train$readmitted~.,data = train)
model_nb
predicted <- predict(model_nb, newdata = test[,-45])

#Performance metrics of Naive Bayes Model
(conf_nb<-confusionMatrix(predicted,test$readmitted,positive = "1"))
